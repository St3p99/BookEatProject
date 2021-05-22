package unical.dimes.psw2021.server.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import unical.dimes.psw2021.server.model.Reservation;
import unical.dimes.psw2021.server.model.Restaurant;
import unical.dimes.psw2021.server.model.Review;

import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    boolean existsByReservation(Reservation reservation);

    @Query( "SELECT R.review FROM Reservation AS R WHERE R.restaurant = ?1" )
    List<Review> findReviewByReservation(Restaurant restaurant);
}
