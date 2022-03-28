package unical.dimes.psw2021.server.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import unical.dimes.psw2021.server.model.Reservation;
import unical.dimes.psw2021.server.model.Restaurant;
import unical.dimes.psw2021.server.model.TableService;
import unical.dimes.psw2021.server.model.User;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, Long> {
    List<Reservation> findByUserAndRejectedTrue(User user);

    List<Reservation> findByUserAndRejectedFalse(User user);

    List<Reservation> findByRestaurantAndDateAndRejectedFalse(Restaurant restaurant, LocalDate date);

    List<Reservation> findByTableServiceAndRejectedFalse(TableService tableService);

    boolean existsByUserAndTableServiceAndDateAndRejectedFalse(User user, TableService tableService, LocalDate date);

    Optional<Reservation> findByIdAndRejectedFalse(Long id);


    List<Reservation> findByTableServiceAndDateAndRejectedFalse(TableService tableService, LocalDate date);
}
