package unical.dimes.psw2021.server.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
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

    @NotBlank(message = "Name is mandatory")
    @Basic
    @Column(name = "name", nullable = false)
    private String name;

    @NotBlank(message = "Country is mandatory")
    @Column(name = "country", nullable = false, length = 30)
    private String country;

    @NotBlank(message = "City is mandatory")
    @Column(name = "city", nullable = false, length = 30)
    private String city;

    @NotBlank(message = "Address is mandatory")
    @Column(name = "address", nullable = false, length = 50)
    private String address;

    @NotBlank(message = "Private phone is mandatory")
    @Basic
    @Column(name = "private phone", nullable = false)
    private String privatePhone;

    @Basic
    @Column(name = "public_phone")
    private String publicPhone;

    @Basic
    @Column(name = "private_mail", nullable = false)
    private String privateMail;

    @Basic
    @Column(name = "public_mail")
    private String publicMail;

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
