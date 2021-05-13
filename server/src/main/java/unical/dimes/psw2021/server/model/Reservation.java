package unical.dimes.psw2021.server.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Date;

/* lombok auto-generated code */
@Getter
@Setter
@EqualsAndHashCode
@ToString
/* lombok auto-generated code */

@Entity
@Table(
        name = "reservation",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "reservation_customer_id_restaurant_id_booking_timestamp_unique",
                        columnNames = {"customer_id", "restaurant_id", "reservation_date", "start_time"}
                )
        },
        schema = "booking_system"
)
public class Reservation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @Basic
    @CreationTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "booking_timestamp")
    private Date bookingTimestamp;

    @JsonFormat(pattern = "yyyy-MM-dd")
    @Column(name = "reservation_date", nullable = false)
    private LocalDate date;

    @JsonFormat(pattern = "HH:mm:ss")
    @Column(name = "start_time", nullable = false)
    private LocalTime startTime;

    @Basic
    @Column(name = "n_guests", nullable = false)
    private int nGuests;

    @Basic
    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @ManyToOne
    @JoinColumn(name = "customer_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "restaurant_id")
    private Restaurant restaurant; // if null the reservation was rejected by restaurant manager

    @NotNull
    @ManyToOne
    @JoinColumn(name = "table_service_id")
    private TableService tableService;
}
