import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pim/utills/shared_preferences.dart';
import 'package:pim/view/mobile_view/auth/forgot_password/password_reset_request.dart';

import '../res/app_colors.dart';
import '../res/app_router.dart';
import '../view/important_pages/dialog_box.dart';
import '../view/important_pages/no_internet.dart';
import '../view/mobile_view/auth/sign_in_page.dart';
import '../view/widgets/app_custom_text.dart';
import 'app_navigator.dart';

class AppUtils {
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static Future<bool> biometrics(String localizedReason) async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool didAuthenticate = await auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(biometricOnly: true));

    return didAuthenticate;
  }

  static getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  openApp(context) async {
    // bool isFirstOpen = (await SharedPref.getBool('isFirstOpen')) ?? true;
    // String userData = await SharedPref.getString('userData');
    // String savedUserpassword = await SharedPref.getString('password');
    // AppUtils().debuglog(savedUserpassword);
    //  AppUtils().debuglog(userData);
    // AppUtils().debuglog(password);AppUtils().debuglog(8);

    // if (!isFirstOpen) {
    //   if (userData.isEmpty || savedUserpassword.isEmpty) {
    Future.delayed(const Duration(seconds: 3), () {
      AppNavigator.pushAndReplaceName(context, name: AppRouter.signInPage);
    });
    // } else {
    //   Future.delayed(const Duration(seconds: 3), () {
    //     AppNavigator.pushAndReplacePage(context,
    //         page: const ExistingSignIn());
    //   });
    // }
    // } else {
    //   AppUtils().debuglog(15);
    //
    //   await SharedPref.putBool('isFirstOpen', false);
    //   if (Platform.isAndroid) {
    //     Future.delayed(const Duration(seconds: 3), () {
    //       AppNavigator.pushAndReplacePage(context,
    //           page: const PasswordResetRequest());
    //     });
    //   } else {
    //     Future.delayed(const Duration(seconds: 3), () {
    //       AppNavigator.pushAndReplacePage(context,
    //           page: const PasswordResetRequest());
    //     });
    //   }
    // }
  }

  static Size deviceScreenSize(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return queryData.size;
  }

  static String convertPrice(dynamic price, {bool showCurrency = false}) {
    double amount = price is String ? double.parse(price) : price;
    final formatCurrency = NumberFormat("#,##0.00", "en_US");
    return '${showCurrency ? 'NGN' : ''} ${formatCurrency.format(amount)}';
  }

  static DateTime timeToDateTime(TimeOfDay time, [DateTime? date]) {
    final newDate = date ?? DateTime.now();
    return DateTime(
        newDate.year, newDate.month, newDate.day, time.hour, time.minute);
  }

  static String formatComplexDate({required String dateTime}) {
    if (dateTime != '') {
      DateTime parseDate = DateFormat("yyyy-MM-dd").parse(dateTime);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('d MMM y');
      var outputDate = outputFormat.format(inputDate);

      return outputDate;
    } else {
      return '';
    }
  }

  static String formatDate({required String parsedDateTime}) {
    if (parsedDateTime != '') {
      DateTime dateTime = DateTime.parse(parsedDateTime);

      // Define the desired date format
      DateFormat formatter = DateFormat('MMMM d, yyyy, H:mm aa');

      // Format the DateTime object
      String formattedDate = formatter.format(dateTime);

      // AppUtils().debuglog the formatted date
      //AppUtils().debuglog(formattedDate);

      return formattedDate;
    } else {
      return '';
    }
  }
  static String getAllErrorMessages(Map<String, dynamic> errorResponse) {
    List<String> messages = [];

    errorResponse.forEach((_, value) {
      if (value is List) {
        messages.addAll(value.map((e) => e.toString()));
      } else if (value is String) {
        messages.add(value);
      }
    });

    return messages.isNotEmpty ? messages.join(" ") : "No error messages found.";
  }
  static String convertString(dynamic data) {
    if (data is String) {
      return data;
    } else if (data is List && data.isNotEmpty) {
      return data[0];
    } else {
      return data[0];
    }
  }

  void debuglog(object) {
    if (kDebugMode) {
      print(object.toString());
      // debugPrint(object.toString());
    }
  }

  void copyToClipboard(textToCopy, context) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: CustomText(
      text: "copied to clipboard",
      color: Colors.white,
    )));
    //MSG.snackBar(context, "$textToCopy copied");
    // You can also show a snackbar or any other feedback to the user.
    AppUtils().debuglog('Text copied to clipboard: $textToCopy');
  }

  static String formateSimpleDate({String? dateTime}) {
    var inputDate = DateTime.parse(dateTime!);

    var outputFormat = DateFormat('MMM d, hh:mm a');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  // static bool isPhoneNumber(String s) {
  //   if (s.length > 16 || s.length < 11) return false;
  //   return hasMatch(s, r'^(?:[+0][1-9])?[0-9]{10,12}$');
  // }

  static final dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');
  static final dateFormat = DateFormat('dd MMM, yyyy');
  static final timeFormat = DateFormat('hh:mm a');
  static final apiDateFormat = DateFormat('yyyy-MM-dd');
  static final utcTimeFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
  static final dayOfWeekFormat = DateFormat('EEEEE', 'en_US');
}
