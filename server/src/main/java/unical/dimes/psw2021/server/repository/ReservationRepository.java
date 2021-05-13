package unical.dimes.psw2021.server.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.stereotype.Repository;
import unical.dimes.psw2021.server.model.Reservation;
import unical.dimes.psw2021.server.model.Restaurant;
import unical.dimes.psw2021.server.model.TableService;
import unical.dimes.psw2021.server.model.User;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, Long> {
    List<Reservation> findByRestaurantAndDate(Restaurant restaurant, LocalDate date);
    List<Reservation> findByTableService(TableService tableService);
    boolean existsByUserAndRestaurantAndDateAndStartTime(User user, Restaurant restaurant, LocalDate date, LocalTime startTime);
}
