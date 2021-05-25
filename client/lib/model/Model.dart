import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:client/model/managers/rest_manager.dart';
import 'package:client/model/objects/authentication_data.dart';
import 'package:client/model/objects/restaurant.dart';
import 'package:client/model/objects/user.dart';
import 'package:client/model/support/constants.dart';
import 'package:client/model/support/login_result.dart';
import 'package:http/http.dart';

import 'objects/review.dart';


class Model {
  static Model sharedInstance = Model();

  RestManager _restManager = RestManager();
  AuthenticationData _authenticationData;


  Future<LoginResult> logIn(String email, String password) async {
    try{
      Map<String, String> params = Map();
      params["grant_type"] = "password";
      params["client_id"] = CLIENT_ID;
      params["client_secret"] = CLIENT_SECRET;
      params["username"] = email;
      params["password"] = password;
      String result = (await _restManager.makePostRequest(ADDRESS_AUTHENTICATION_SERVER, REQUEST_LOGIN, params, type: TypeHeader.urlencoded)).body;
      print(result);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if ( _authenticationData.hasError() ) {
        if ( _authenticationData.error == "Invalid user credentials" ) {
          return LoginResult.error_wrong_credentials;
        }
        else if ( _authenticationData.error == "Account is not fully set up" ) {
          return LoginResult.error_not_fully_setupped;
        }
        else {
          return LoginResult.error_unknown;
        }
      }
      _restManager.token = _authenticationData.accessToken;
      Timer.periodic(Duration(seconds: (_authenticationData.expiresIn - 50)), (Timer t) {
        _refreshToken();
      });
      return LoginResult.logged;
    }
    catch (e) {
      print(e);
      return LoginResult.error_unknown;
    }
  }

  Future<bool> _refreshToken() async {
    try {
      Map<String, String> params = Map();
      params["grant_type"] = "refresh_token";
      params["client_id"] = CLIENT_ID;
      params["client_secret"] = CLIENT_SECRET;
      params["refresh_token"] = _authenticationData.refreshToken;
      String result = (await _restManager.makePostRequest(ADDRESS_AUTHENTICATION_SERVER, REQUEST_LOGIN, params, type: TypeHeader.urlencoded)).body;
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if ( _authenticationData.hasError() ) {
        return false;
      }
      _restManager.token = _authenticationData.accessToken;
      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<bool> logOut() async {
    try{
      Map<String, String> params = Map();
      _restManager.token = null;
      params["client_id"] = CLIENT_ID;
      params["client_secret"] = CLIENT_SECRET;
      params["refresh_token"] = _authenticationData.refreshToken;
      await _restManager.makePostRequest(ADDRESS_AUTHENTICATION_SERVER, REQUEST_LOGOUT, params, type: TypeHeader.urlencoded);
      return true;
    }
    catch (e) {
      return false;
    }
  }


  Future<List<Restaurant>> searchRestaurantByCity(String city) async {
    Map<String, String> params = Map();
    params["city"] = city;
    try{
      Response response = await _restManager.makeGetRequest(ADDRESS_STORE_SERVER, REQUEST_SEARCH_RESTAURANTS_BYCITY, params);
      if( response.statusCode == HttpStatus.noContent ) return List.generate(0, (index) => null);
      return List<Restaurant>.from(json.decode(response.body).map((i) => Restaurant.fromJson(i)).toList());
    }
    catch (e) {
      print(e);
      return List.generate(0, (index) => null);
    }
  }

  Future<List<Review>> searchReviewByRestaurant(int id) async {
    try{
      Response response = await _restManager.makeGetRequest(ADDRESS_STORE_SERVER, REQUEST_SEARCH_REVIEW_BYRESTAURANT+"/$id");
      if( response.statusCode == HttpStatus.noContent )
        return List.generate(0, (index) => null);
      return List<Review>.from(json.decode(response.body).map((i) => Review.fromJson(i)).toList());
    }
    catch (e) {
      print(e);
      return List.generate(0, (index) => null);
    }
  }

  Future<User> searchUserByEmail(String email) async {
    Map<String, String> params = Map();
    params["email"] = email;
    try{
      Response response = await _restManager.makeGetRequest(ADDRESS_STORE_SERVER, REQUEST_SEARCH_USER_BYEMAIL, params);
      if( response.statusCode == HttpStatus.notFound ) return null;
      return User.fromJson(jsonDecode(response.body));
    }
    catch (e) {
      print(e);
      return null;
    }
  }

  // Future<List<Product>> searchProduct(String name) async {
  //   Map<String, String> params = Map();
  //   params["name"] = name;
  //   try {
  //     return List<Product>.from(json.decode(await _restManager.makeGetRequest(ADDRESS_STORE_SERVER, REQUEST_SEARCH_PRODUCTS, params)).map((i) => Product.fromJson(i)).toList());
  //   }
  //   catch (e) {
  //     return null; // not the best solution
  //   }
  // }

  // Future<User> addUser(User user) async {
  //   try {
  //     String rawResult = await _restManager.makePostRequest(ADDRESS_STORE_SERVER, REQUEST_ADD_USER, user);
  //     if ( rawResult.contains(RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS) ) {
  //       return null; // not the best solution
  //     }
  //     else {
  //       return User.fromJson(jsonDecode(rawResult));
  //     }
  //   }
  //   catch (e) {
  //     return null; // not the best solution
  //   }
  // }


}
