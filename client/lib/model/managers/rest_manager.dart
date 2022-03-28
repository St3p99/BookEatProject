import 'dart:convert';
import 'dart:io';

import 'package:client/model/support/Constants.dart';
import 'package:client/model/support/error_listener.dart';
import 'package:http/http.dart';

enum TypeHeader { json, urlencoded }

class RestManager {
  ErrorListener delegate;
  String token;

  Future<Response> _makeRequest(
      String serverAddress, String servicePath, String method, TypeHeader type,
      {Map<String, dynamic> value,
      dynamic body,
      bool httpsEnabled = false}) async {
    Uri uri;
    if (httpsEnabled)
      uri = Uri.https(serverAddress, servicePath, value);
    else
      uri = Uri.http(serverAddress, servicePath, value);
    bool errorOccurred = false;
    while (true) {
      print(uri.toString());
      try {
        Response response;
        // setting content type
        String contentType;
        dynamic formattedBody;
        if (type == TypeHeader.json) {
          contentType = "application/json;charset=utf-8";
          formattedBody = json.encode(body);
        } else if (type == TypeHeader.urlencoded) {
          contentType = "application/x-www-form-urlencoded";
          formattedBody = body.keys.map((key) => "$key=${body[key]}").join("&");
        }

        // setting headers
        Map<String, String> headers = Map();

        headers[HttpHeaders.contentTypeHeader] = contentType;
        if (token != null) {
          headers[HttpHeaders.authorizationHeader] = 'bearer $token';
        }
        // making request
        switch (method) {
          case "post":
            response = await post(
              uri,
              headers: headers,
              body: formattedBody,
            );
            break;
          case "get":
            response = await get(
              uri,
              headers: headers,
            );
            break;
          case "put":
            response = await put(
              uri,
              headers: headers,
            );
            break;
          case "delete":
            response = await delete(
              uri,
              headers: headers,
            );
            break;
        }
        if (delegate != null && errorOccurred) {
          print("NETWORK GONE");
          delegate.errorNetworkGone();
          errorOccurred = false;
        }
        print(response.statusCode);
        return response;
      } catch (err) {
        print('RestManager: makeRequest exception: ' + err);
        if (delegate != null && !errorOccurred) {
          delegate.errorNetworkOccurred(MESSAGE_CONNECTION_ERROR);
          errorOccurred = true;
        }
        await Future.delayed(
            const Duration(seconds: 5), () => null); // not the best solution
      }
    }
  }

  Future<Response> makePostRequest(
      String serverAddress, String servicePath, dynamic body,
      {Map<String, dynamic> value,
      TypeHeader type = TypeHeader.json,
      bool httpsEnabled = false}) async {
    return _makeRequest(serverAddress, servicePath, "post", type,
        body: body, value: value, httpsEnabled: httpsEnabled);
  }

  Future<Response> makeGetRequest(String serverAddress, String servicePath,
      [Map<String, dynamic> value, TypeHeader type]) async {
    return _makeRequest(serverAddress, servicePath, "get", type, value: value);
  }

  Future<Response> makePutRequest(String serverAddress, String servicePath,
      [Map<String, dynamic> value, TypeHeader type]) async {
    return _makeRequest(serverAddress, servicePath, "put", type, value: value);
  }

  Future<Response> makeDeleteRequest(String serverAddress, String servicePath,
      [Map<String, dynamic> value, TypeHeader type]) async {
    return _makeRequest(serverAddress, servicePath, "delete", type,
        value: value);
  }
}
