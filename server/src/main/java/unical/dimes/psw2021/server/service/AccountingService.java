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
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import unical.dimes.psw2021.server.model.Restaurant;
import unical.dimes.psw2021.server.model.User;
import unical.dimes.psw2021.server.repository.RestaurantRepository;
import unical.dimes.psw2021.server.repository.UserRepository;
import unical.dimes.psw2021.server.support.exception.UniqueKeyViolationException;

import javax.ws.rs.core.Response;
import java.net.ConnectException;
import java.util.Arrays;
import java.util.Collections;
import java.util.Optional;

@Service
public class AccountingService {
    private final UserRepository userRepository;
    private final RestaurantRepository restaurantRepository;
    private final RestaurantService restaurantService;
    private final UserService userService;

    @Value("${keycloak.auth-server-url}") private String serverUrl;
    @Value("${admin.username.keycloak}") private String adminUsername;
    @Value("${keycloak.client-key-password}")  private String adminPwd;
    @Value("${keycloak.resource}") private String clientId;
    @Value("${keycloak.realm}") private String realm;
    @Value("${keycloak.credentials.secret}") private String clientSecret;
    @Value("${role-user}") private String USER_ROLE;
    @Value("${role-restaurant-manager}") private String RESTAURANT_MANAGER_ROLE;



    @Autowired
    public AccountingService(UserRepository userRepository, RestaurantRepository restaurantRepository, RestaurantService restaurantService, UserService userService) {
        this.userRepository = userRepository;
        this.restaurantRepository = restaurantRepository;
        this.restaurantService = restaurantService;
        this.userService = userService;
    }


    @Transactional
    public User registerUser(User user, String pwd) throws UniqueKeyViolationException, ConnectException{
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

        return userService.addUser(user);
    }

    @Transactional
    public Restaurant registerRestaurant(Restaurant restaurant, String pwd) throws UniqueKeyViolationException, ConnectException {

        Keycloak keycloak = getKeycloakObj();

        // Define user
        UserRepresentation userRepresentation = new UserRepresentation();
        userRepresentation.setEnabled(true);
        userRepresentation.setUsername( restaurant.getPrivateMail() );
        userRepresentation.setEmail( restaurant.getPrivateMail() );
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
        RoleRepresentation userClientRole = realmResource.clients().get(app1Client.getId()).roles().get(RESTAURANT_MANAGER_ROLE).toRepresentation();
        // Assign client level role to user
        userResource.roles().clientLevel(app1Client.getId()).add(Arrays.asList(userClientRole));

        return restaurantService.addRestaurant(restaurant);
    }

    @Transactional
    public void deleteUser(Long id) {
        Optional<User> opt = userRepository.findById(id);
        if (opt.isEmpty()) return;
        User user = opt.get();

        Keycloak keycloak = getKeycloakObj();

        // Get realm
        RealmResource realmResource = keycloak.realm(realm);
        UsersResource usersResource = realmResource.users();

        // delete user with email(unique)
        usersResource.delete(
                usersResource.search(user.getEmail(), true).get(0).getId()
        );

        userService.deleteUser(user);
    }

    @Transactional
    public void deleteRestaurant(Long id){
        Optional<Restaurant> opt = restaurantRepository.findById(id);
        if (opt.isEmpty()) return;
        Restaurant r = opt.get();

        Keycloak keycloak = getKeycloakObj();

        // Get realm
        RealmResource realmResource = keycloak.realm(realm);
        UsersResource usersResource = realmResource.users();

        // delete user with email(unique)
        usersResource.delete(
                usersResource.search(r.getPrivateMail(), true).get(0).getId()
        );

        restaurantService.deleteRestaurant(r);
    }

    @Transactional(propagation = Propagation.SUPPORTS )
    public Keycloak getKeycloakObj(){
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
