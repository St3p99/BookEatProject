// general
const int MAX_NOP = 15;

// addresses

// ANDROID DEVICE DEBUGGING
// const String ADDRESS_STORE_SERVER = "192.168.1.54:8080";
// const String ADDRESS_AUTHENTICATION_SERVER = "192.168.1.54:8180";

// WEB DEBUGGING
const String ADDRESS_STORE_SERVER = "localhost:8080";
const String ADDRESS_AUTHENTICATION_SERVER = "localhost:8180";

// authentication
const String REALM = "BookIT-Realm";
const String CLIENT_ID = "springboot-microservice";
const String CLIENT_SECRET = "af4b7613-eb0c-400e-86f6-13f90e227f03";
const String REQUEST_LOGIN =
    "/auth/realms/" + REALM + "/protocol/openid-connect/token";

const String REQUEST_LOGOUT =
    "/auth/realms/" + REALM + "/protocol/openid-connect/logout";

// requests

// SEARCH CONTROLLER
const String REQUEST_SEARCH_RESTAURANTS_BY_CITY = "/api/search/paged/byCity";

const String REQUEST_SEARCH_RESTAURANTS_BY_NAME_AND_CITY =
    "/api/search/paged/byNameAndCity";
const String REQUEST_SEARCH_RESTAURANTS_BY_NAME_AND_CITY_AND_CATEGORIES =
    "/api/search/paged/byNameAndCityAndCategories";
const String REQUEST_SEARCH_RESTAURANTS_BY_CITY_AND_CATEGORIES =
    "/api/search/paged/byCityAndCategories";
const String REQUEST_SEARCH_REVIEW_BY_RESTAURANT = "/api/search/review";

const int REQUEST_DEFAULT_PAGE_SIZE = 2;

// USER CONTROLLER
const String REQUEST_ADD_USER = "api/users/new";
const String REQUEST_SEARCH_USER_BY_EMAIL = "/api/users";
const String REQUEST_GET_RESERVATIONS = "/api/users/reservations";
const String REQUEST_POST_REVIEW = "/api/users/post-review";
const String REQUEST_NEW_USER = "/api/users/new";

// RESERVATION CONTROLLER
const String REQUEST_GET_SERVICES_BY_DATE = "/api/booking/services";
const String REQUEST_GET_AVAILABILITY = "/api/booking/availability";
const String REQUEST_NEW_RESERVATION = "/api/booking/new";
const String REQUEST_DELETE_RESERVATION = "/api/booking/delete";

// ERROR MESSAGE
const String ERROR_RESERVATION_ALREADY_EXIST =
    "ERROR_RESERVATION_ALREADY_EXIST";
const String ERROR_SEATS_UNAVAILABLE = "ERROR_SEATS_UNAVAILABLE";
const String ERROR_REVIEW_ALREADY_EXISTS = "ERROR_REVIEW_ALREADY_EXISTS";

// roles

// STORAGE
const String STORAGE_REFRESH_TOKEN = "refresh_token";
const String STORAGE_EMAIL = "email";

// categories
const List<String> categories = ["pizza", "sushi", "pub", "grill", "cafe"];

// responses
const String RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS =
    "ERROR_MAIL_USER_ALREADY_EXISTS";

// messages
const String MESSAGE_CONNECTION_ERROR = "connection_error";
