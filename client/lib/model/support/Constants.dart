// general
const int MAX_NOP = 15;

// addresses

// ANDROID DEVICE DEBUGGING
const String ADDRESS_STORE_SERVER = "192.168.1.54:8080";
const String ADDRESS_AUTHENTICATION_SERVER = "192.168.1.54:8444";

// WEB DEBUGGING
// const String ADDRESS_STORE_SERVER = "localhost:8080";
// const String ADDRESS_AUTHENTICATION_SERVER = "localhost:8444";


// authentication
const String REALM = "BookIT-Realm";
const String CLIENT_ID = "springboot-microservice";
const String CLIENT_SECRET = "af4b7613-eb0c-400e-86f6-13f90e227f03";
const String REQUEST_LOGIN = "/auth/realms/" + REALM + "/protocol/openid-connect/token";

const String REQUEST_LOGOUT =
    "/auth/realms/" + REALM + "/protocol/openid-connect/logout";

// requests

// SEARCH CONTROLLER
const String REQUEST_SEARCH_RESTAURANTS_BY_CITY = "/api/search/byCity";
const String REQUEST_SEARCH_RESTAURANTS_BY_NAME_AND_CITY = "/api/search/byNameAndCity";
const String REQUEST_SEARCH_RESTAURANTS_BY_NAME_AND_CITY_AND_CATEGORIES = "/api/search/byNameAndCityAndCategories";
const String REQUEST_SEARCH_RESTAURANTS_BY_CITY_AND_CATEGORIES = "/api/search/byCityAndCategories";
const String REQUEST_SEARCH_REVIEW_BY_RESTAURANT = "/api/search/review";

// USER CONTROLLER
const String REQUEST_ADD_USER = "api/users/new";
const String REQUEST_SEARCH_USER_BY_EMAIL = "/api/users";

// roles

// categories
const List<String> categories = ["pizza", "sushi", "pub", "grill", "cafe"];

// responses
const String RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS =
    "ERROR_MAIL_USER_ALREADY_EXISTS";



// messages
const String MESSAGE_CONNECTION_ERROR = "connection_error";
