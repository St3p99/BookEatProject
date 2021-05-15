package unical.dimes.psw2021.server.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import unical.dimes.psw2021.server.model.Reservation;
import unical.dimes.psw2021.server.model.Review;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    boolean existsByReservation(Reservation reservation);
}
