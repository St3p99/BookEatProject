// general
const int MAX_NOP = 15;

// addresses
const String ADDRESS_STORE_SERVER = "192.168.1.54:8080";
const String ADDRESS_AUTHENTICATION_SERVER = "192.168.1.54:8081";

// authentication
const String REALM = "BookIT-Realm";
const String CLIENT_ID = "springboot-microservice";
const String CLIENT_SECRET = "dbdfddec-e0a3-4d0c-9ef0-c46fca0d248c";
const String REQUEST_LOGIN =
    "/auth/realms/" + REALM + "/protocol/openid-connect/token";
const String REQUEST_LOGOUT =
    "/auth/realms/" + REALM + "/protocol/openid-connect/logout";

// requests
const String REQUEST_SEARCH_RESTAURANTS_BYCITY = "/api/search/byCity";
const String REQUEST_SEARCH_REVIEW_BYRESTAURANT = "/api/search/review";
const String REQUEST_ADD_USER = "/users/new";

// roles

// responses
const String RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS =
    "ERROR_MAIL_USER_ALREADY_EXISTS";


const String RESPONSE_NO_CONTENT =
    "ERROR_MAIL_USER_ALREADY_EXISTS";

// messages
const String MESSAGE_CONNECTION_ERROR = "connection_error";
