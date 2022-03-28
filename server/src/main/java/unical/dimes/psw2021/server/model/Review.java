package unical.dimes.psw2021.server.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import unical.dimes.psw2021.server.support.exception.RatingOutOfBoundException;

import javax.persistence.*;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

/* lombok auto-generated code */
@Getter
@Setter
@EqualsAndHashCode
@ToString
/* lombok auto-generated code */

@Entity
@Table(
        name = "review",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "review_reservation_id_unique",
                        columnNames = "reservation_id"
                )
        },
        schema = "booking_system"
)
public class Review {
    private static final int MIN_RATING = 0;
    private static final int MAX_RATING = 5;
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "reservation_id", nullable = false)
    @JsonIgnore
    @ToString.Exclude
    public Reservation reservation;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;
    @NotNull
    @Min(MIN_RATING)
    @Max(MAX_RATING)
    @Basic
    @Column(name = "food_rating", nullable = false)
    private int foodRating;
    @NotNull
    @Min(MIN_RATING)
    @Max(MAX_RATING)
    @Basic
    @Column(name = "service_rating", nullable = false)
    private int serviceRating;
    @NotNull
    @Min(MIN_RATING)
    @Max(MAX_RATING)
    @Basic
    @Column(name = "location_rating", nullable = false)
    private int locationRating;
    @Column(name = "review_text")
    private String reviewText;

    public void setFoodRating(int foodRating) throws RatingOutOfBoundException {
        if (!checkBounds(foodRating))
            throw new RatingOutOfBoundException();
        this.foodRating = foodRating;
    }

    public void setLocationRating(int locationRating) throws RatingOutOfBoundException {
        if (!checkBounds(locationRating))
            throw new RatingOutOfBoundException();
        this.locationRating = locationRating;
    }

    public void setServiceRating(int serviceRating) throws RatingOutOfBoundException {
        if (!checkBounds(serviceRating))
            throw new RatingOutOfBoundException();
        this.serviceRating = serviceRating;
    }

    private boolean checkBounds(int rating) {
        return rating <= MAX_RATING && rating >= MIN_RATING;
    }
}



