// addresses
const String ADDRESS_STORE_SERVER = "http://localhost:8080/api/";
const String ADDRESS_AUTHENTICATION_SERVER =
    "http://localhost:8081/auth";

// authentication
const String REALM = "BookIT-Realm";
const String CLIENT_ID = "springboot-microservice";
const String CLIENT_SECRET = "dbdfddec-e0a3-4d0c-9ef0-c46fca0d248c";
const String REQUEST_LOGIN =
    "/auth/realms/" + REALM + "/protocol/openid-connect/token";
const String REQUEST_LOGOUT =
    "/auth/realms/" + REALM + "/protocol/openid-connect/logout";

// requests
const String REQUEST_SEARCH_PRODUCTS = "/products/search/by_name";
const String REQUEST_ADD_USER = "/users";

// roles
const String STATE_CLUB = "club";

// responses
const String RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS =
    "ERROR_MAIL_USER_ALREADY_EXISTS";

// messages
const String MESSAGE_CONNECTION_ERROR = "connection_error";

