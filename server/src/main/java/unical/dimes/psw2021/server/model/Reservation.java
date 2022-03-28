package unical.dimes.psw2021.server.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Positive;
import java.time.LocalDate;
import java.time.LocalDateTime;
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
        schema = "booking_system"
)
public class Reservation implements Comparable<Reservation> {
    @EqualsAndHashCode.Exclude
    @OneToOne(mappedBy = "reservation")
    public Review review;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;
    @Basic
    @CreationTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "booking_timestamp")
    @JsonIgnore
    private Date bookingTimestamp;
    @NotNull
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Column(name = "reservation_date", nullable = false)
    private LocalDate date;
    @NotNull
    @JsonFormat(pattern = "HH:mm:ss")
    @Column(name = "start_time", nullable = false)
    private LocalTime startTime;
    @Basic
    @NotNull
    @Positive
    @Column(name = "guests", nullable = false)
    private int guests;
    @Basic
    @Column(name = "rejected", nullable = false)
    private boolean rejected = false; // default: false
    @NotNull
    @ManyToOne
    @JoinColumn(name = "customer_id", nullable = false)
    private User user;
    @ManyToOne
    @JoinColumn(name = "restaurant_id")
    private Restaurant restaurant;
    @NotNull
    @ManyToOne
    @JoinColumn(name = "table_service_id")
    private TableService tableService;

    public int compareTo(Reservation r) {
        return LocalDateTime.of(date, startTime).compareTo(LocalDateTime.of(r.date, r.startTime));
    }
}
