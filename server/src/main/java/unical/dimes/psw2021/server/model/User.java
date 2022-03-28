package unical.dimes.psw2021.server.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.*;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.util.List;


/* lombok auto-generated code */
@Getter
@Setter
@EqualsAndHashCode
@ToString
/* lombok auto-generated code */

@Entity
@Table(
        name = "user",
        uniqueConstraints = {
                @UniqueConstraint(name = "user_email_unique", columnNames = "email")
        },
        schema = "booking_system"
)
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @NotBlank
    @Column(name = "first_name", nullable = false, length = 30)
    private String firstName;

    @NotBlank
    @Column(name = "last_name", nullable = false, length = 30)
    private String lastName;

    @NotBlank
    @Column(name = "phone", nullable = false, length = 15)
    private String phone;

    @NotNull
    @Email
    @Column(name = "email", nullable = false, length = 50)
    private String email;

    @NotBlank
    @Column(name = "city", nullable = false, length = 100)
    private String city;

    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    @JsonIgnore
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    @Column(insertable = false, updatable = false)
    private List<Reservation> reservations;
}
