//package unical.dimes.psw2021.server.model;
//
//import lombok.EqualsAndHashCode;
//import lombok.Getter;
//import lombok.ToString;
//import unical.dimes.psw2021.server.support.exception.RatingOutOfBoundException;
//
//import javax.persistence.*;
//
///* lombok auto-generated code */
//@Getter
//@EqualsAndHashCode
//@ToString
///* lombok auto-generated code */
//
//@Entity
//@Table(
//        name = "review",
//        uniqueConstraints = {
//                @UniqueConstraint(
//                        name = "review_reservation_id_key",
//                        columnNames = "reservation_id"
//                )
//        },
//        schema = "booking_system"
//)
//public class Review {
//    private static final int MIN_RATING = 0;
//    private static final int MAX_RATING = 10;
//    @OneToOne
//    public Reservation reservation;
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    @Column(name = "id", nullable = false)
//    private Long id;
//    @Basic
//    @Column(name = "food_rating", nullable = false)
//    private int foodRating;
//    @Basic
//    @Column(name = "service_rating", nullable = false)
//    private int serviceRating;
//    @Basic
//    @Column(name = "location_rating", nullable = false)
//    private int locationRating;
//
//    public void setFoodRating(int foodRating) throws RatingOutOfBoundException {
//        if (foodRating > MAX_RATING || foodRating < MIN_RATING)
//            throw new RatingOutOfBoundException();
//        this.foodRating = foodRating;
//    }
//
//    public void setLocationRating(int locationRating) throws RatingOutOfBoundException {
//        if (locationRating > MAX_RATING || locationRating < MIN_RATING)
//            throw new RatingOutOfBoundException();
//        this.locationRating = locationRating;
//    }
//
//    public void setServiceRating(int serviceRating) throws RatingOutOfBoundException {
//        if (serviceRating > MAX_RATING || serviceRating < MIN_RATING)
//            throw new RatingOutOfBoundException();
//        this.serviceRating = serviceRating;
//    }
//}
