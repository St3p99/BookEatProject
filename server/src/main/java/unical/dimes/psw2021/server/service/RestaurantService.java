package unical.dimes.psw2021.server.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.support.MutableSortDefinition;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.data.domain.*;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import unical.dimes.psw2021.server.model.Reservation;
import unical.dimes.psw2021.server.model.Restaurant;
import unical.dimes.psw2021.server.model.TableService;
import unical.dimes.psw2021.server.repository.ReservationRepository;
import unical.dimes.psw2021.server.repository.RestaurantRepository;
import unical.dimes.psw2021.server.repository.TableServiceRepository;
import unical.dimes.psw2021.server.support.exception.TableServiceOverlapException;
import unical.dimes.psw2021.server.support.exception.UniqueKeyViolationException;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;

@Service
public class RestaurantService {
    private final RestaurantRepository restaurantRepository;
    private final TableServiceRepository tableServiceRepository;
    private final ReservationRepository reservationRepository;


    @Autowired
    public RestaurantService(RestaurantRepository restaurantRepository,
                             TableServiceRepository tableServiceRepository,
                             ReservationRepository reservationRepository) {
        this.restaurantRepository = restaurantRepository;
        this.tableServiceRepository = tableServiceRepository;
        this.reservationRepository = reservationRepository;
    }

    @Transactional(readOnly = true)
    public List<Restaurant> showRestaurantByNameAndCity(
            String name, String city, int pageNumber, int pageSize, String sortBy) {

        Pageable paging = PageRequest.of(pageNumber, pageSize, Sort.by(sortBy));
        Page<Restaurant> pagedResult = restaurantRepository.findByNameIgnoreCaseContainingAndCityIgnoreCase(name, city, paging);
        return pagedResult.hasContent() ? pagedResult.getContent() : new ArrayList<>();
    }

    @Transactional(readOnly = true)
    public List<Restaurant> showRestaurantByCity(String city, int pageNumber, int pageSize, String sortBy) {

        Pageable paging = PageRequest.of(pageNumber, pageSize, Sort.by(sortBy));
        Page<Restaurant> pagedResult = restaurantRepository.findByCityIgnoreCase(city, paging);
        return pagedResult.hasContent() ? pagedResult.getContent() : new ArrayList<>();
    }

    @Transactional
    public Restaurant addRestaurant(Restaurant newRestaurant) throws UniqueKeyViolationException {

        if (restaurantRepository.existsByNameAndCityAndAddress(newRestaurant.getName(),
                newRestaurant.getCity(),
                newRestaurant.getAddress())) {
            throw new UniqueKeyViolationException();
        }
        return restaurantRepository.save(newRestaurant);
    }

    @Transactional
    public void deleteRestaurant(Long id) {
        Optional<Restaurant> opt = restaurantRepository.findById(id);
        if (opt.isEmpty()) return;
        Restaurant r = opt.get();
        tableServiceRepository.deleteAll(r.getTableServices());
        restaurantRepository.delete(r);
    }

    @Transactional
    public TableService addTableService(Long restaurantId, TableService newTableService) throws UniqueKeyViolationException, TableServiceOverlapException, ResourceNotFoundException {
        Optional<Restaurant> optRestaurant = restaurantRepository.findById(restaurantId);
        if (optRestaurant.isEmpty()) throw new ResourceNotFoundException();
        Restaurant restaurant = optRestaurant.get();
        newTableService.setRestaurant(restaurant);

        // check unique constraint
        Optional<TableService> optTableService =
                tableServiceRepository.findByServiceNameAndRestaurant(newTableService.getServiceName(), optRestaurant.get());
        if (optTableService.isPresent()) throw new UniqueKeyViolationException();

        // check overlap
        Optional<TableService> overlappedService = checkOverlap(newTableService);
        if (overlappedService.isPresent())
            throw new TableServiceOverlapException(overlappedService.get());

        return tableServiceRepository.save(newTableService);
    }

    @Transactional(readOnly = true)
    public Optional<TableService> checkOverlap(TableService newTableService) {
        List<TableService> existingTableServices =
                tableServiceRepository.findByRestaurant(newTableService.getRestaurant());
        LocalTime newStartHour = newTableService.getStartTime();
        LocalTime newEndHour = newTableService.getEndTime();
        Set<DayOfWeek> daysOfWeek = newTableService.getDaysOfWeek();
        for (TableService existingTableService : existingTableServices) {
            for (DayOfWeek dow : daysOfWeek) { // check time overlap in shared days
                if (existingTableService.getDaysOfWeek().contains(dow)) {
                    // newTableService and existingTableService share at least a day
                    if (((newStartHour.compareTo(existingTableService.getStartTime()) >= 0) &&
                            (newStartHour.compareTo(existingTableService.getEndTime()) < 0))
                            ||
                            ((newEndHour.compareTo(existingTableService.getStartTime()) > 0) &&
                                    (newEndHour.compareTo(existingTableService.getEndTime()) <= 0))) { // time overlap
                        return Optional.of(existingTableService);
                    }
                }
            }
        }
        return Optional.empty();
    }

    @Transactional(readOnly = true)
    public List<TableService> showTableServices(Long restaurantId) throws ResourceNotFoundException {
        return restaurantRepository.findById(restaurantId).map(
                restaurant -> restaurant.getTableServices()
        ).orElseThrow(ResourceNotFoundException::new);
    }

    @Transactional(readOnly = true)
    public List<TableService> showTableServicesByDay(Long restaurantId, DayOfWeek dayOfWeek) {
        List<TableService> tableServices = showTableServices(restaurantId);
        List<TableService> result = new LinkedList<>();
        for (TableService tableService : tableServices)
            if (tableService.getDaysOfWeek().contains(dayOfWeek))
                result.add(tableService);
        return result;
    }

    @Transactional
    public void deleteTableService(Long id) {
        Optional<TableService> opt = tableServiceRepository.findById(id);
        if (opt.isEmpty()) return;
        TableService tableService = opt.get();
        List<Reservation> reservations = reservationRepository.findByTableServiceAndRejectedFalse(tableService);
        // set reservations out of service
        reservations.forEach(reservation -> {
            reservation.setTableService(null);
            reservationRepository.save(reservation);
        });
        tableServiceRepository.delete(tableService);
    }

    @Transactional(readOnly = true)
    public List<Reservation> showReservations(Long id,  int pageNumber, int pageSize, String sortBy) throws ResourceNotFoundException {
        Optional<Restaurant> optRestaurant = restaurantRepository.findById(id);
        if(optRestaurant.isEmpty()) throw new ResourceNotFoundException();

        List<Reservation> reservations = optRestaurant.get().getReservations();
        if( reservations.isEmpty() ) return reservations;

        PagedListHolder<Reservation> pagedResult = new PagedListHolder(reservations);
        pagedResult.setPageSize(pageSize);
        pagedResult.setPage(pageNumber);
        pagedResult.setSort(new MutableSortDefinition(sortBy, true, true));
        return pagedResult.getPageList();
    }

    @Transactional(readOnly = true)
    public List<Reservation> showReservationsByRestaurantAndDate(Long restaurantId, LocalDate date) throws ResourceNotFoundException{
        Optional<Restaurant> optRestaurant = restaurantRepository.findById(restaurantId);
        if(optRestaurant.isEmpty()) throw new ResourceNotFoundException();

        List<Reservation> reservations = reservationRepository.findByRestaurantAndDateAndRejectedFalse(optRestaurant.get(), date);
        return reservations;
    }

    @Transactional
    public void rejectReservation(Long id) {
        Optional<Reservation> opt = reservationRepository.findById(id);
        if (opt.isEmpty()) return;
        Reservation reservation = opt.get();
        reservation.setRejected(true);
        reservationRepository.save(reservation);
    }
}
