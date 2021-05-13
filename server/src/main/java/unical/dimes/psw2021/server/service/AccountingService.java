package unical.dimes.psw2021.server.service;

import org.keycloak.OAuth2Constants;
import org.keycloak.admin.client.KeycloakBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.keycloak.admin.client.CreatedResponseUtil;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.admin.client.resource.UserResource;
import org.keycloak.admin.client.resource.UsersResource;
import org.keycloak.representations.idm.ClientRepresentation;
import org.keycloak.representations.idm.CredentialRepresentation;
import org.keycloak.representations.idm.RoleRepresentation;
import org.keycloak.representations.idm.UserRepresentation;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.support.MutableSortDefinition;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import unical.dimes.psw2021.server.model.Reservation;
import unical.dimes.psw2021.server.model.Restaurant;
import unical.dimes.psw2021.server.model.User;
import unical.dimes.psw2021.server.repository.ReservationRepository;
import unical.dimes.psw2021.server.repository.UserRepository;
import unical.dimes.psw2021.server.support.exception.UniqueKeyViolationException;

import javax.ws.rs.core.Response;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Service
public class AccountingService {
    private final UserRepository userRepository;
    private final ReservationRepository reservationRepository;

    @Value("${keycloak.auth-server-url}") private String serverUrl;
    @Value("${admin.username.keycloak}") private String adminUsername;
    @Value("${keycloak.client-key-password}")  private String adminPwd;
    @Value("${keycloak.resource}") private String clientId;
    @Value("${keycloak.realm}") private String realm;
    @Value("${keycloak.credentials.secret}") private String clientSecret;
    @Value("${role.user}") public final String USER_ROLE = "user";


    @Autowired
    public AccountingService(UserRepository userRepository, ReservationRepository reservationRepository) {
        this.userRepository = userRepository;
        this.reservationRepository = reservationRepository;
    }

    @Transactional(propagation = Propagation.REQUIRED)
    public User registerUser(User user, String pwd) throws UniqueKeyViolationException {
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new UniqueKeyViolationException();
        }

        registerOnKeycloak(user, pwd);

        return userRepository.save(user);
    }

    private void registerOnKeycloak(User user, String pwd){
        Keycloak keycloak = getKeycloakObj();

        // Define user
        UserRepresentation userRepresentation = new UserRepresentation();
        userRepresentation.setEnabled(true);
        userRepresentation.setUsername( user.getEmail() );
        userRepresentation.setEmail( user.getEmail() );
        userRepresentation.setAttributes(Collections.singletonMap("origin", Arrays.asList("demo")));

        // Get realm
        RealmResource realmResource = keycloak.realm(realm);
        UsersResource usersResource = realmResource.users();

        // Create user (requires manage-users role)
        Response response = usersResource.create(userRepresentation);
        String userId = CreatedResponseUtil.getCreatedId(response);

        // Define password credential
        CredentialRepresentation passwordCred = new CredentialRepresentation();
        passwordCred.setTemporary(false);
        passwordCred.setType(CredentialRepresentation.PASSWORD);
        passwordCred.setValue(pwd);

        UserResource userResource = usersResource.get(userId);

        // Set password credential
        userResource.resetPassword(passwordCred);


        // Get client
        ClientRepresentation app1Client = realmResource.clients().findByClientId(clientId).get(0);

        // Get client level role (requires view-clients role)
        RoleRepresentation userClientRole = realmResource.clients().get(app1Client.getId()).roles().get(USER_ROLE).toRepresentation();
        // Assign client level role to user
        userResource.roles().clientLevel(app1Client.getId()).add(Arrays.asList(userClientRole));

        // Send password reset E-Mail
        // VERIFY_EMAIL, UPDATE_PROFILE, CONFIGURE_TOTP, UPDATE_PASSWORD, TERMS_AND_CONDITIONS
//      usersResource.get(userId).executeActionsEmail(Arrays.asList("UPDATE_PASSWORD"));

    }

    @Transactional
    public void deleteUser(Long id) {
        Optional<User> opt = userRepository.findById(id);
        if (opt.isEmpty()) return;
        User user = opt.get();

        userRepository.delete(user);

        Keycloak keycloak = getKeycloakObj();

        // Get realm
        RealmResource realmResource = keycloak.realm(realm);
        UsersResource usersResource = realmResource.users();

        // delete user with email(unique)
        usersResource.delete(
                usersResource.search(user.getEmail(), true).get(0).getId()
        );
    }

    private Keycloak getKeycloakObj(){
        return KeycloakBuilder.builder()
                .serverUrl(serverUrl)
                .realm(realm)
                .grantType(OAuth2Constants.PASSWORD)
                .clientId(clientId)
                .clientSecret(clientSecret)
                .username(adminUsername)
                .password(adminPwd)
                .build();
    }


}
