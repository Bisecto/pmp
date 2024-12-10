import 'dart:convert';

import '../res/apis.dart';
import '../res/app_strings.dart';
import 'package:http/http.dart' as http;

import '../utills/app_utils.dart';

class AppRepository {
  Future<http.Response> postRequest(
      Map<String, String> data, String apiUrl) async {
    var response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );
    AppUtils().debuglog(apiUrl+response.statusCode.toString());

    return response;
  }
  Future<http.Response> postRequestWithToken(String token,
      Map<String, dynamic> data, String apiUrl) async {
    var headers = {
      'Authorization': 'JWT $token',
      //'Content-Type': 'application/json'
    };
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: data,
    );
    AppUtils().debuglog(apiUrl+response.statusCode.toString());
    AppUtils().debuglog(1);
    AppUtils().debuglog(response.body);
    return response;
  }



  Future<http.Response> getRequest( String apiUrl) async {
    AppUtils().debuglog(apiUrl);

    final response = await http.get(
      Uri.parse(apiUrl),
    );
    AppUtils().debuglog(apiUrl+response.statusCode.toString());

    return response;
  }
  Future<http.Response> getRequestWithToken(String token, String apiUrl) async {
    AppUtils().debuglog(apiUrl);
    var headers = {
      'Authorization': 'JWT $token',
     'Content-Type': 'application/json'
    };
    AppUtils().debuglog(headers);
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
      // body: jsonEncode(user),
    );
    AppUtils().debuglog(apiUrl+response.statusCode.toString());
    AppUtils().debuglog(response.statusCode);
    AppUtils().debuglog(response.statusCode);
    AppUtils().debuglog(response.body);
    return response;
  }
}
