import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:client/UI/screens/login/login_screen.dart';
import 'package:client/model/managers/persistent_storage_manager.dart';
import 'package:client/model/managers/rest_manager.dart';
import 'package:client/model/objects/authentication_data.dart';
import 'package:client/model/objects/reservation.dart';
import 'package:client/model/objects/restaurant.dart';
import 'package:client/model/objects/table_service.dart';
import 'package:client/model/objects/user.dart';
import 'package:client/model/service/navigation_service.dart';
import 'package:client/model/support/booking_response.dart';
import 'package:client/model/support/constants.dart';
import 'package:client/model/support/login_result.dart';
import 'package:client/model/support/review_response.dart';
import 'package:http/http.dart';

import 'objects/review.dart';

class Model {
  static Model sharedInstance = Model();

  RestManager _restManager = RestManager();
  AuthenticationData _authenticationData;
  PersistentStorageManager _persistentStorageManager =
      PersistentStorageManager();
  User currentUser;

  Future<LoginResult> logIn(String email, String password) async {
    try {
      Map<String, dynamic> params = Map();
      params["grant_type"] = "password";
      params["client_id"] = CLIENT_ID;
      params["client_secret"] = CLIENT_SECRET;
      params["username"] = email;
      params["password"] = password;
      String result = (await _restManager.makePostRequest(
              ADDRESS_AUTHENTICATION_SERVER, REQUEST_LOGIN, params,
              type: TypeHeader.urlencoded, httpsEnabled: false))
          .body;
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if (_authenticationData.hasError()) {
        if (_authenticationData.error == "Invalid user credentials") {
          return LoginResult.error_wrong_credentials;
        } else if (_authenticationData.error == "Account is not fully set up") {
          return LoginResult.error_not_fully_setupped;
        } else {
          return LoginResult.error_unknown;
        }
      }
      _persistentStorageManager.setString(
          STORAGE_REFRESH_TOKEN, _authenticationData.refreshToken);
      _persistentStorageManager.setString(STORAGE_EMAIL, email);
      _restManager.token = _authenticationData.accessToken;
      await _loadUser(email);
      Timer.periodic(Duration(seconds: (_authenticationData.expiresIn - 50)),
          (Timer t) async {
        bool result = await _refreshToken();
        print('refreshToken: $result');
        if (!result) {
          print('refreshToken: cancel Timer.periodic');
          t.cancel();
        }
      });
      return LoginResult.logged;
    } catch (e) {
      print(e);
      return LoginResult.error_unknown;
    }
  }

  Future<String> getLastEmailAccess() async {
    return _persistentStorageManager.getString(STORAGE_EMAIL);
  }

  Future<bool> autoLogin() async {
    String email = await _persistentStorageManager.getString(STORAGE_EMAIL);
    String refreshToken =
        await _persistentStorageManager.getString(STORAGE_REFRESH_TOKEN);
    if (refreshToken != null && email != null) {
      _authenticationData = AuthenticationData();
      _authenticationData.refreshToken = refreshToken;
      bool autoLogInResult = await _refreshToken();
      if (autoLogInResult) {
        await _loadUser(email);
        return true;
      }
    }
    return false;
  }

  Future<void> _loadUser(String email) async {
    currentUser = await Model.sharedInstance.searchUserByEmail(email);
  }

  Future<bool> _refreshToken() async {
    try {
      Map<String, dynamic> params = Map();
      params["grant_type"] = "refresh_token";
      params["client_id"] = CLIENT_ID;
      params["client_secret"] = CLIENT_SECRET;
      params["refresh_token"] = _authenticationData.refreshToken;
      Response response = await _restManager.makePostRequest(
          ADDRESS_AUTHENTICATION_SERVER, REQUEST_LOGIN, params,
          type: TypeHeader.urlencoded, httpsEnabled: false);
      String result = response.body;
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if (response.statusCode == HttpStatus.badRequest ||
          _authenticationData.hasError()) {
        NavigationService.instance.navigateToReplacement(LoginScreen.routeName);
        _persistentStorageManager.remove(STORAGE_REFRESH_TOKEN);
        return false;
      }
      _restManager.token = _authenticationData.accessToken;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logOut() async {
    try {
      Map<String, dynamic> params = Map();
      _restManager.token = null;
      _persistentStorageManager.setString('token', null);
      params["client_id"] = CLIENT_ID;
      params["client_secret"] = CLIENT_SECRET;
      params["refresh_token"] = _authenticationData.refreshToken;
      await _restManager.makePostRequest(
          ADDRESS_AUTHENTICATION_SERVER, REQUEST_LOGOUT, params,
          type: TypeHeader.urlencoded, httpsEnabled: false);
      _persistentStorageManager.remove(STORAGE_REFRESH_TOKEN);
      _persistentStorageManager.remove(STORAGE_EMAIL);
      currentUser = null;
      return true;
    } catch (e) {
      return false;
    }
  }

  // SEARCH
  Future<List<Restaurant>> searchRestaurantByCity(String city, int page) async {
    Map<String, dynamic> params = Map();
    params["city"] = city;
    params["pageNumber"] = page.toString();
    params["pageSize"] = REQUEST_DEFAULT_PAGE_SIZE.toString();
    try {
      Response response = await _restManager.makeGetRequest(
          ADDRESS_STORE_SERVER, REQUEST_SEARCH_RESTAURANTS_BY_CITY, params);
      if (response.statusCode == HttpStatus.noContent)
        return List.generate(0, (index) => null);
      else if (response.statusCode == HttpStatus.ok)
        return List<Restaurant>.from(json
            .decode(response.body)
            .map((i) => Restaurant.fromJson(i))
            .toList());
      else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Restaurant>> searchRestaurantByNameAndCity(
      String name, String city, int page) async {
    Map<String, dynamic> params = Map();
    params["name"] = name;
    params["city"] = city;
    params["pageNumber"] = page.toString();
    params["pageSize"] = REQUEST_DEFAULT_PAGE_SIZE.toString();
    try {
      Response response = await _restManager.makeGetRequest(
          ADDRESS_STORE_SERVER,
          REQUEST_SEARCH_RESTAURANTS_BY_NAME_AND_CITY,
          params);
      if (response.statusCode == HttpStatus.noContent)
        return List.generate(0, (index) => null);
      else if (response.statusCode == HttpStatus.ok)
        return List<Restaurant>.from(json
            .decode(response.body)
            .map((i) => Restaurant.fromJson(i))
            .toList());
      else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Restaurant>> searchRestaurantByNameAndCityAndCategories(
      String name, String city, List<String> categories, int page) async {
    Map<String, dynamic> params = Map();
    params["name"] = name;
    params["city"] = city;
    params["categories"] = categories;
    params["pageNumber"] = page.toString();
    params["pageSize"] = REQUEST_DEFAULT_PAGE_SIZE.toString();
    try {
      Response response = await _restManager.makeGetRequest(
          ADDRESS_STORE_SERVER,
          REQUEST_SEARCH_RESTAURANTS_BY_NAME_AND_CITY_AND_CATEGORIES,
          params);
      if (response.statusCode == HttpStatus.noContent)
        return List.generate(0, (index) => null);
      else if (response.statusCode == HttpStatus.ok)
        return List<Restaurant>.from(json
            .decode(response.body)
            .map((i) => Restaurant.fromJson(i))
            .toList());
      else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Restaurant>> searchRestaurantByCityAndCategories(
      String city, List<String> categories, int page) async {
    Map<String, dynamic> params = Map();
    params["city"] = city;
    params["categories"] = categories;
    params["pageNumber"] = page.toString();
    params["pageSize"] = REQUEST_DEFAULT_PAGE_SIZE.toString();
    try {
      Response response = await _restManager.makeGetRequest(
          ADDRESS_STORE_SERVER,
          REQUEST_SEARCH_RESTAURANTS_BY_CITY_AND_CATEGORIES,
          params);
      if (response.statusCode == HttpStatus.noContent)
        return List.generate(0, (index) => null);
      else if (response.statusCode == HttpStatus.ok)
        return List<Restaurant>.from(json
            .decode(response.body)
            .map((i) => Restaurant.fromJson(i))
            .toList());
      else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Review>> searchReviewByRestaurant(int id) async {
    try {
      Response response = await _restManager.makeGetRequest(
          ADDRESS_STORE_SERVER, REQUEST_SEARCH_REVIEW_BY_RESTAURANT + "/$id");
      if (response.statusCode == HttpStatus.noContent)
        return List.generate(0, (index) => null);
      else if (response.statusCode == HttpStatus.ok)
        return List<Review>.from(
            json.decode(response.body).map((i) => Review.fromJson(i)).toList());
      else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // SUPPORT
  Future<void> loadRestaurantReviews(Restaurant restaurant) async {
    List<Review> reviews =
        await Model.sharedInstance.searchReviewByRestaurant(restaurant.id);
    restaurant.setRatings(reviews);
  }

  Future<void> loadRestaurantsReviews(List<Restaurant> restaurants) async {
    for (Restaurant restaurant in restaurants) {
      await loadRestaurantReviews(restaurant);
    }
  }

  // RESERVATION
  Future<BookingResponse> newReservation(Reservation reservation) async {
    try {
      Response response = await _restManager.makePostRequest(
          ADDRESS_STORE_SERVER, REQUEST_NEW_RESERVATION, reservation);
      if (response.statusCode == HttpStatus.created) {
        Reservation created = Reservation.fromJson(json.decode(response.body));
        return new BookingResponse(BOOKING_RESPONSE_STATE.CREATED,
            reservation: created);
      } else if (response.statusCode == HttpStatus.conflict) {
        if (response.body == ERROR_RESERVATION_ALREADY_EXIST)
          return new BookingResponse(
              BOOKING_RESPONSE_STATE.ERROR_RESERVATION_ALREADY_EXIST);
        else if (response.body == ERROR_SEATS_UNAVAILABLE)
          return new BookingResponse(
              BOOKING_RESPONSE_STATE.ERROR_SEATS_UNAVAILABLE);
      } else
        return new BookingResponse(BOOKING_RESPONSE_STATE.ERROR_UNKNOWN);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteReservation(Reservation reservation) async {
    try {
      int id = reservation.id;
      await _restManager.makeDeleteRequest(
          ADDRESS_STORE_SERVER, REQUEST_DELETE_RESERVATION + "/$id");
    } catch (e) {
      return null;
    }
  }

  Future<List<TableService>> getTableServicesByDate(
      Restaurant restaurant, String formattedDate) async {
    Map<String, String> params = Map();
    params["restaurant_id"] = restaurant.id.toString();
    params["date"] = formattedDate;
    try {
      Response response = await _restManager.makeGetRequest(
          ADDRESS_STORE_SERVER, REQUEST_GET_SERVICES_BY_DATE, params);
      if (response.statusCode == HttpStatus.noContent)
        return List.generate(0, (index) => null);
      else if (response.statusCode == HttpStatus.ok)
        return List<TableService>.from(json
            .decode(response.body)
            .map((i) => TableService.fromJson(i))
            .toList());
      else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int> getSeatsAvailable(
      TableService service, String formattedDate, String formattedTime) async {
    Map<String, String> params = Map();
    params["service_id"] = service.id.toString();
    params["date"] = formattedDate;
    params["time"] = formattedTime;
    try {
      Response response = await _restManager.makeGetRequest(
          ADDRESS_STORE_SERVER, REQUEST_GET_AVAILABILITY, params);
      if (response.statusCode == HttpStatus.ok)
        return int.parse(response.body);
      else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // USER
  Future<User> newUser(User user, String pwd) async {
    Map<String, String> params = Map();
    params["pwd"] = pwd;
    try {
      Response response = await _restManager.makePostRequest(
          ADDRESS_STORE_SERVER, REQUEST_NEW_USER, user,
          value: params);
      if (response.statusCode == HttpStatus.created) {
        return User.fromJson(json.decode(response.body));
      } else
        return null;
    } catch (e) {
      return null;
    }
  }

  Future<User> searchUserByEmail(String email) async {
    Map<String, dynamic> params = Map();
    params["email"] = email;
    try {
      Response response = await _restManager.makeGetRequest(
          ADDRESS_STORE_SERVER, REQUEST_SEARCH_USER_BY_EMAIL, params);
      if (response.statusCode == HttpStatus.notFound) return null;
      return User.fromJson(jsonDecode(response.body));
    } catch (e) {
      print("searchUserByEmail exception: " + e);
      return null;
    }
  }

  Future<List<Reservation>> getReservations(User user) async {
    try {
      int id = user.id;
      Response response = await _restManager.makeGetRequest(
          ADDRESS_STORE_SERVER, REQUEST_GET_RESERVATIONS + "/$id");
      if (response.statusCode == HttpStatus.noContent)
        return List.generate(0, (index) => null);
      else if (response.statusCode == HttpStatus.ok)
        return List<Reservation>.from(json
            .decode(response.body)
            .map((i) => Reservation.fromJson(i))
            .toList());
      else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ReviewResponse> newReview(Review review) async {
    try {
      // reservation attribute of Review object is ignored by server
      int reservationId = review.reservation.id;
      Response response = await _restManager.makePostRequest(
          ADDRESS_STORE_SERVER,
          REQUEST_POST_REVIEW + "/$reservationId",
          review);
      if (response.statusCode == HttpStatus.created) {
        Review created = Review.fromJson(json.decode(response.body));
        return new ReviewResponse(REVIEW_RESPONSE_STATE.CREATED,
            review: created);
      } else if (response.statusCode == HttpStatus.conflict) {
        if (response.body == ERROR_REVIEW_ALREADY_EXISTS)
          return new ReviewResponse(
              REVIEW_RESPONSE_STATE.ERROR_REVIEW_ALREADY_EXIST);
      } else
        return new ReviewResponse(REVIEW_RESPONSE_STATE.ERROR_UNKNOWN);
    } catch (e) {
      return null;
    }
  }
}
