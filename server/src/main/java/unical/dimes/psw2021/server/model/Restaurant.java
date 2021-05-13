package unical.dimes.psw2021.server.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Positive;
import java.util.List;

/* lombok auto-generated code */
@Getter
@Setter
@EqualsAndHashCode
@ToString
/* lombok auto-generated code */

@Entity
@Table(
        name = "restaurant",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "restaurant_name_city_address_unique",
                        columnNames = {"name", "city", "address"})
        },
        schema = "booking_system"
)
public class Restaurant {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @NotBlank
    @Basic
    @Column(name = "name", nullable = false)
    private String name;

    @NotBlank
    @Column(name = "country", nullable = false, length = 30)
    private String country;

    @NotBlank
    @Column(name = "city", nullable = false, length = 30)
    private String city;

    @NotBlank
    @Column(name = "address", nullable = false, length = 50)
    private String address;

    @NotBlank
    @Basic
    @Column(name = "private phone", nullable = false)
    private String privatePhone;

    @NotBlank
    @Column(name = "public_phone", nullable = false)
    private String publicPhone;

    @NotBlank
    @Column(name = "private_mail", nullable = false)
    private String privateMail;

    @Basic
    @Column(name = "public_mail")
    private String publicMail;

    @NotNull
    @Positive
    @Basic
    @Column(name = "seating_capacity", nullable = false)
    private int seatingCapacity;

    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    @JsonIgnore
    @OneToMany(mappedBy = "restaurant", cascade = CascadeType.MERGE)
    @Column(insertable = false, updatable = false)
    private List<TableService> tableServices;

    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    @JsonIgnore
    @OneToMany(mappedBy = "restaurant", cascade = CascadeType.MERGE)
    @Column(insertable = false, updatable = false)
    private List<Reservation> reservations;
}
