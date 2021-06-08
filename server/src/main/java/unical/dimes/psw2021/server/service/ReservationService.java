package unical.dimes.psw2021.server.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import unical.dimes.psw2021.server.model.Reservation;
import unical.dimes.psw2021.server.model.TableService;
import unical.dimes.psw2021.server.model.User;
import unical.dimes.psw2021.server.repository.ReservationRepository;
import unical.dimes.psw2021.server.repository.RestaurantRepository;
import unical.dimes.psw2021.server.repository.TableServiceRepository;
import unical.dimes.psw2021.server.repository.UserRepository;
import unical.dimes.psw2021.server.support.exception.SeatsUnavailable;
import unical.dimes.psw2021.server.support.exception.UniqueKeyViolationException;

import javax.persistence.EntityManager;
import javax.persistence.LockModeType;
import javax.persistence.OptimisticLockException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Service
public class ReservationService {
    private final ReservationRepository reservationRepository;
    private final TableServiceRepository tableServiceRepository;
    private final RestaurantRepository restaurantRepository;
    private final UserRepository userRepository;

    @Autowired
    private EntityManager entityManager;

    @Value("${default-average-meal-duration}")
    private int defaultAvgMealDuration;


    @Autowired
    public ReservationService(ReservationRepository reservationRepository, TableServiceRepository tableServiceRepository, RestaurantRepository restaurantRepository, UserRepository userRepository) {
        this.reservationRepository = reservationRepository;
        this.tableServiceRepository = tableServiceRepository;
        this.restaurantRepository = restaurantRepository;
        this.userRepository = userRepository;
    }

    @Transactional( readOnly = true)
    public int getSeatsAvailable(Long serviceId, LocalDate date, LocalTime startTime) throws ResourceNotFoundException {
        return tableServiceRepository.findById(serviceId).map(tableService -> {
            if (!itIsAcceptable(tableService, date, startTime)) return 0;

            List<Reservation> reservationsOfRestaurantInDate = reservationRepository.
                    findByRestaurantAndDateAndRejectedFalse(tableService.getRestaurant(), date);

            int reservedSeats = countReservedSeats(reservationsOfRestaurantInDate, tableService, startTime);
            return tableService.getRestaurant().getSeatingCapacity() - reservedSeats;
        }).orElseThrow(ResourceNotFoundException::new);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class, timeout = 2000)
    public Reservation addReservation(Reservation newReservation) throws UniqueKeyViolationException, SeatsUnavailable, OptimisticLockException {
        Optional<TableService> optTableService = tableServiceRepository.findById(newReservation.getTableService().getId());
        if (optTableService.isEmpty()) throw new ResourceNotFoundException();
        TableService tableService = optTableService.get();
        newReservation.setTableService(tableService);
        newReservation.setRestaurant(tableService.getRestaurant());

        Optional<User> optUser = userRepository.findById(newReservation.getUser().getId());
        if (optUser.isEmpty()) throw new ResourceNotFoundException();
        newReservation.setUser(optUser.get());

        if (reservationRepository.existsByUserAndTableServiceAndDateAndRejectedFalse(
                newReservation.getUser(),
                newReservation.getTableService(),
                newReservation.getDate())) {
            throw new UniqueKeyViolationException();
        }

        // acquire lock
        entityManager.lock(tableService, LockModeType.OPTIMISTIC_FORCE_INCREMENT);

        boolean seatsAreAvailable = getAvailabilityWithLock(newReservation.getTableService(),
                newReservation.getDate(),
                newReservation.getStartTime(),
                newReservation.getGuests());

        if (!seatsAreAvailable) throw new SeatsUnavailable();

        return reservationRepository.saveAndFlush(newReservation);
    }

    @Transactional(propagation = Propagation.REQUIRED)
    public boolean getAvailabilityWithLock(TableService tableService, LocalDate date, LocalTime startTime, int nGuests) {
        if (!itIsAcceptable(tableService, date, startTime)) {
            return false;
        }

        List<Reservation> reservationsOfRestaurantInDate = reservationRepository.
                findByRestaurantAndDateAndRejectedFalse(tableService.getRestaurant(), date);

        int reservedSeats = countReservedSeats(reservationsOfRestaurantInDate, tableService, startTime);
        return tableService.getRestaurant().getSeatingCapacity() - reservedSeats - nGuests >= 0;
    }

    @Transactional(propagation = Propagation.SUPPORTS)
    public boolean itIsAcceptable(TableService tableService, LocalDate date, LocalTime startTime) {
        // Service available at date and at time
        return tableService.getDaysOfWeek().contains(date.getDayOfWeek())
                && tableService.getStartTime().compareTo(startTime) <= 0
                && tableService.getEndTime().compareTo(startTime) >= 0
                && LocalDateTime.now().compareTo(LocalDateTime.of(date, startTime)) <= 0;
    }

    @Transactional(propagation = Propagation.SUPPORTS)
    public int countReservedSeats(
            List<Reservation> reservations, TableService tableService, LocalTime startTime) {

        LocalTime endTime = startTime.plusMinutes(tableService.getAverageMealDuration());
        int reservedSeats = 0;
        LocalTime reservationStartTime;
        LocalTime reservationEndTime;
        for (Reservation reservation : reservations) {
            reservationStartTime = reservation.getStartTime();
            if (reservation.getTableService() == null) //  reservation out of service
                reservationEndTime = reservationStartTime.plusMinutes(defaultAvgMealDuration);
            else reservationEndTime = reservationStartTime.plusMinutes(tableService.getAverageMealDuration());

            if ((reservationStartTime.compareTo(startTime) <= 0
                    && reservationEndTime.compareTo(startTime) > 0) ||
                    ((reservationStartTime.compareTo(endTime) < 0
                            && reservationEndTime.compareTo(endTime) >= 0))) {
                // counts seats in reservation as reserved
                reservedSeats += reservation.getGuests();
            }
        }
        return reservedSeats;
    }
}
