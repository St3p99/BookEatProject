class Constants{
  // addresses
  static final String ADDRESS_STORE_SERVER = "http://localhost:8080/api/";
  static final String ADDRESS_AUTHENTICATION_SERVER = "http://localhost:8081/auth";

  // authentication
  static final String REALM = "BookIT-Realm";
  static final String CLIENT_ID = "springboot-microservice";
  static final String CLIENT_SECRET = "dbdfddec-e0a3-4d0c-9ef0-c46fca0d248c";
  static final String REQUEST_LOGIN = "/auth/realms/" + REALM + "/protocol/openid-connect/token";
  static final String REQUEST_LOGOUT = "/auth/realms/" + REALM + "/protocol/openid-connect/logout";

  // requests
  static final String REQUEST_SEARCH_PRODUCTS = "/products/search/by_name";
  static final String REQUEST_ADD_USER = "/users";

  // roles
  static final String STATE_CLUB = "club";

  // responses
  static final String RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS = "ERROR_MAIL_USER_ALREADY_EXISTS";

  // messages
  static final String MESSAGE_CONNECTION_ERROR = "connection_error";
}