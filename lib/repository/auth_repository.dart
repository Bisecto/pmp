import 'dart:convert';

import '../res/apis.dart';
import '../res/app_strings.dart';
import 'package:http/http.dart' as http;

import '../utills/app_utils.dart';

class AuthRepository {
  Future<http.Response> authPostRequest(
      Map<String, String> data, String apiUrl) async {

    var response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );
    AppUtils().debuglog(apiUrl+response.statusCode.toString());
    AppUtils().debuglog(response.body);

    return response;
  }
  Future<http.Response> authPostRequestWithToken(String token,
      Map<String, String> data, String apiUrl) async {
    var headers = {
      'Authorization': 'Bearer $token'

    };
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: data,
    );
    // AppUtils().debuglog(apiUrl+response.statusCode.toString());
    // AppUtils().debuglog(response.body);
    return response;
  }



  Future<http.Response> authGetRequest(String token, String apiUrl) async {
    AppUtils().debuglog(apiUrl);
      var headers = {
      //  'x-access-token': accessToken,
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
     // body: jsonEncode(user),
    );
    AppUtils().debuglog(apiUrl+response.statusCode.toString());
    AppUtils().debuglog(response.body);
    return response;
  }

}
