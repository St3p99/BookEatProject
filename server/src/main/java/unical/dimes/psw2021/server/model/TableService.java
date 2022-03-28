package unical.dimes.psw2021.server.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.*;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.Set;

/* lombok auto-generated code */
@Getter
@Setter
@EqualsAndHashCode()
@ToString
/* lombok auto-generated code */

@Entity
@Table(
        name = "table_service",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "table_service_restaurant_id_service_name_unique",
                        columnNames = {"restaurant_id", "service_name"}),

        },
        schema = "booking_system"
)
public class TableService implements Comparable<TableService> {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @NotNull
    @Basic
    @Column(name = "service_name", nullable = false, length = 50)
    private String serviceName;

    @NotNull
    @ElementCollection
    @CollectionTable(name = "service_days_of_week", joinColumns = @JoinColumn(name = "service_id"), schema = "booking_system")
    private Set<DayOfWeek> daysOfWeek;

    @NotNull
    @JsonFormat(pattern = "HH:mm:ss")
    @Column(name = "start_time", nullable = false)
    private LocalTime startTime;

    @NotNull
    @JsonFormat(pattern = "HH:mm:ss")
    @Column(name = "end_time", nullable = false)
    private LocalTime endTime;

    @NotNull
    @Min(10)
    @Max(180)
    @Column(name = "average_meal_duration", nullable = false)
    private int averageMealDuration;

    @ManyToOne
    @JoinColumn(name = "restaurant_id", nullable = false)
    private Restaurant restaurant;

    @Version
    @Column(name = "version", nullable = false)
    @JsonIgnore
    @ToString.Exclude
    private long version;

    public int compareTo(TableService t) {
        return this.startTime.compareTo(t.startTime);
    }
}
