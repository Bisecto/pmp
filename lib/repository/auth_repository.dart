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
      'Authorization': 'JWT $token'

    };
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: data,
    );
    AppUtils().debuglog(apiUrl+response.statusCode.toString());
    AppUtils().debuglog(response.body);
    return response;
  }

  // Future<http.Response> authPostRequest(
  //     Map<String, dynamic> data, String apiUrl,
  //     {String accessToken = '', String refreshToken = ''}) async {
  //   AppUtils().debuglog(apiUrl);
  //   // var headers = {
  //   //   'x-access-token': accessToken,
  //   //   'x-refresh-token': refreshToken,
  //   //   'Content-Type': 'application/x-www-form-urlencoded',
  //   // };
  //
  //   // Encode data into form-urlencoded format
  //   var formData = data.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  //
  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     //headers: headers,
  //     body: formData,
  //   );
  //   return response;
  // }
  // Future<http.Response> authPostRequest(
  //     Map<String, String> data, String apiUrl,
  //     {String accessToken = '', String refreshToken = ''}) async {
  //   AppUtils().debuglog(apiUrl);
  //   // var headers = {
  //   //   'x-access-token': accessToken,
  //   //   'x-refresh-token': refreshToken,
  //   //   'Content-Type': 'application/json'
  //   // };
  //   var formData = data.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  //   AppUtils().debuglog(data);
  //   //AppUtils().debuglog(headers);
  //   var body = jsonEncode(data);
  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //    // headers: headers,
  //     body: formData,
  //   );
  //   return response;
  // }

  Future<http.Response> authGetRequest(String token, String apiUrl) async {
    AppUtils().debuglog(apiUrl);
      var headers = {
      //  'x-access-token': accessToken,
        'Authorization': 'JWT $token',
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
  //Future<void>
  // Future<void> handlePasswordReset(String email, String otp, String newPassword) async {
  //   // Request password reset
  //   var resetResponse = await http.post(
  //     Uri.parse('https://uni-portal.onrender.com/u-auth/request-password-reset/'),
  //     body: {'email': email},
  //   );
  //
  //   if (resetResponse.statusCode != 200) {
  //     AppUtils().debuglog('Failed to request password reset. Status code: ${resetResponse.statusCode}');
  //     AppUtils().debuglog('Response: ${resetResponse.body}');
  //     return;
  //   }
  //
  //   var resetJson = jsonDecode(resetResponse.body);
  //   if (resetJson['message'] != null) {
  //     AppUtils().debuglog('Message from request-password-reset: ${resetJson['message']}');
  //   }
  //
  //   // Verify OTP
  //   var verifyResponse = await http.post(
  //     Uri.parse('https://uni-portal.onrender.com/u-auth/verify-otp/'),
  //     body: {'email': email, 'otp': otp},
  //   );
  //
  //   if (verifyResponse.statusCode != 200) {
  //     AppUtils().debuglog('Failed to verify OTP. Status code: ${verifyResponse.statusCode}');
  //     AppUtils().debuglog('Response: ${verifyResponse.body}');
  //     return;
  //   }
  //
  //   var verifyJson = jsonDecode(verifyResponse.body);
  //   if (verifyJson['access'] != null) {
  //     var jwtToken = verifyJson['access'];
  //     AppUtils().debuglog('JWT token obtained: $jwtToken');
  //
  //     // Reset password
  //     var resetPasswordResponse = await http.post(
  //       Uri.parse('https://uni-portal.onrender.com/u-auth/reset-password/'),
  //       headers: {
  //         'Authorization': 'JWT $jwtToken',
  //       },
  //       body: {'new_password': newPassword},
  //     );
  //
  //     if (resetPasswordResponse.statusCode != 200) {
  //       AppUtils().debuglog('Failed to reset password. Status code: ${resetPasswordResponse.statusCode}');
  //       AppUtils().debuglog('Response: ${resetPasswordResponse.body}');
  //       return;
  //     }
  //
  //     var resetPasswordJson = jsonDecode(resetPasswordResponse.body);
  //     if (resetPasswordJson['success'] != null) {
  //       AppUtils().debuglog('Message from reset-password: ${resetPasswordJson['success']}');
  //     }
  //   } else {
  //     AppUtils().debuglog('JWT token not found in the verify-otp response.');
  //   }
  // }
}
