import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

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
    AppUtils().debuglog(apiUrl + response.statusCode.toString());

    return response;
  }


  Future<http.Response> appPostRequestWithMultipleImages(
      Map<String, dynamic> data,
      String apiUrl,
      List<XFile> images, // Accept a list of images
      String token,
      ) async {
    // Initialize headers
    var headers = {
      'Authorization': 'Bearer $token',
    };

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll(headers);

    // Add form data fields to the request
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add multiple images to the request
    for (var i = 0; i < images.length; i++) {
      final image = images[i];
      // Detect MIME type of each image
      String? mimeType = lookupMimeType(image.path);

      if (mimeType == null) {
        print("Unable to detect MIME type for ${image.path}.");
        return http.Response('Unable to detect MIME type', 400);
      }

      // Split MIME type into type and subtype
      var mimeTypeData = mimeType.split('/');

      // Add image file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'images[$i]', // Use array syntax for multiple files
          image.path,
          // contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ),
      );
    }

    // Send the request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    // Log response details
    AppUtils().debuglog('Response Status Code: ${response.statusCode}');
    AppUtils().debuglog('Response Body: ${response.body}');

    return response;
  }

  Future<http.Response> appPutRequestWithMultipleImages(
    Map<String, dynamic> data,
    String apiUrl,
    List<XFile> images, // Accept a list of images
    String token,
  ) async {
    // Initialize headers
    var headers = {
      'Authorization': 'Bearer $token',
    };

    // Create a multipart request
    var request = http.MultipartRequest('PUT', Uri.parse(apiUrl));
    request.headers.addAll(headers);

    // Add form data fields to the request
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add multiple images to the request
    for (var i = 0; i < images.length; i++) {
      final image = images[i];
      // Detect MIME type of each image
      String? mimeType = lookupMimeType(image.path);

      if (mimeType == null) {
        print("Unable to detect MIME type for ${image.path}.");
        return http.Response('Unable to detect MIME type', 400);
      }

      // Split MIME type into type and subtype
      var mimeTypeData = mimeType.split('/');

      // Add image file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'images[$i]', // Use array syntax for multiple files
          image.path,
          // contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ),
      );
    }

    // Send the request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    // Log response details
    AppUtils().debuglog('Response Status Code: ${response.statusCode}');
    AppUtils().debuglog('Response Body: ${response.body}');

    return response;
  }

  Future<http.Response> appPostRequestWithSingleImages(
      Map<String, dynamic> data,
      String apiUrl,
      XFile? image,
      String token) async {
    // Initialize headers
    var headers = {
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll(headers);

    // Add data fields to the request
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // If an image is provided, add it to the request
    if (image != null) {
      // Detect MIME type of the image
      String? mimeType = lookupMimeType(image.path);

      if (mimeType == null) {
        print("Unable to detect MIME type.");
        return http.Response('Unable to detect MIME type', 400);
      }

      // Split MIME type into its type and subtype
      var mimeTypeData = mimeType.split('/');

      // Attach the image file with its detected content type
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_pic',
          image.path,
         // contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ),
      );
    }

    // Send the request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    // Log response details
    AppUtils().debuglog('Response Status Code: ${response.statusCode}');
    AppUtils().debuglog('Response Body: ${response.body}');

    return response;
  }

  Future<http.Response> appPutRequestWithSingleImages(
      Map<String, dynamic> data,
      String apiUrl,
      XFile? image,
      String token) async {
    // Initialize headers
    var headers = {
      'Authorization': 'Bearer $token',
    };
    print(apiUrl);

    var request = http.MultipartRequest('PUT', Uri.parse(apiUrl));
    request.headers.addAll(headers);

    // Add data fields to the request
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // If an image is provided, add it to the request
    if (image != null) {
      // Detect MIME type of the image
      String? mimeType = lookupMimeType(image.path);

      if (mimeType == null) {
        print("Unable to detect MIME type.");
        return http.Response('Unable to detect MIME type', 400);
      }

      // Split MIME type into its type and subtype
      var mimeTypeData = mimeType.split('/');

      // Attach the image file with its detected content type
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_pic',
          image.path,
          // contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ),
      );
    }

    // Send the request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    // Log response details
    AppUtils().debuglog('Response Status Code: ${response.statusCode}');
    AppUtils().debuglog('Response Body: ${response.body}');

    return response;
  }
  Future<http.Response> appPatchRequestWithSingleImages(
      Map<String, dynamic> data,
      String apiUrl,
      XFile? image,
      String token) async {
    // Initialize headers
    var headers = {
      'Authorization': 'Bearer $token',
    };
    print(apiUrl);

    var request = http.MultipartRequest('PATCH', Uri.parse(apiUrl));
    request.headers.addAll(headers);

    // Add data fields to the request
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // If an image is provided, add it to the request
    if (image != null) {
      // Detect MIME type of the image
      String? mimeType = lookupMimeType(image.path);

      if (mimeType == null) {
        print("Unable to detect MIME type.");
        return http.Response('Unable to detect MIME type', 400);
      }

      // Split MIME type into its type and subtype
      var mimeTypeData = mimeType.split('/');

      // Attach the image file with its detected content type
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_pic',
          image.path,
          // contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ),
      );
    }

    // Send the request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    // Log response details
    AppUtils().debuglog('Response Status Code: ${response.statusCode}');
    AppUtils().debuglog('Response Body: ${response.body}');

    return response;
  }
  Future<http.Response> postRequestWithToken(
      String token, Map<String, dynamic> data, String apiUrl) async {
    var headers = {
      'Authorization': 'Bearer $token',
      //'Content-Type': 'application/json'
    };
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: data,
    );
    AppUtils().debuglog(apiUrl + response.statusCode.toString());
    AppUtils().debuglog(1);
    AppUtils().debuglog(response.body);
    return response;
  }

  Future<http.Response> getRequest(String apiUrl) async {
    AppUtils().debuglog(apiUrl);

    final response = await http.get(
      Uri.parse(apiUrl),
    );
    AppUtils().debuglog(apiUrl + response.statusCode.toString());

    return response;
  }

  Future<http.Response> getRequestWithToken(String token, String apiUrl) async {
    AppUtils().debuglog(apiUrl);
    var headers = {
      'Authorization': 'Bearer $token',
      // 'Content-Type': 'application/json'
    };
    AppUtils().debuglog(headers);
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
      // body: jsonEncode(user),
    );
    AppUtils().debuglog(apiUrl + response.statusCode.toString());
    AppUtils().debuglog(response.statusCode);
    AppUtils().debuglog(response.statusCode);
    AppUtils().debuglog(response.body);
    return response;
  }
  Future<http.Response> deleteRequestWithToken(String token, String apiUrl) async {
    AppUtils().debuglog(apiUrl);
    print(apiUrl);
    var headers = {
      'Authorization': 'Bearer $token',
      // 'Content-Type': 'application/json'
    };
    AppUtils().debuglog(headers);
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: headers,
      // body: jsonEncode(user),
    );
    AppUtils().debuglog(apiUrl + response.statusCode.toString());
    AppUtils().debuglog(response.statusCode);
    AppUtils().debuglog(response.statusCode);
    AppUtils().debuglog(response.body);
    return response;
  }
}
