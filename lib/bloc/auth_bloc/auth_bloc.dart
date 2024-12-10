import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import 'package:http/http.dart' as http;

import '../../repository/auth_repository.dart';
import '../../repository/fcm_topics.dart';
import '../../res/apis.dart';
import '../../utills/app_utils.dart';
import '../../utills/shared_preferences.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignInEventClick>(signInEventClick);
    on<InitialEvent>(initialEvent);
    on<RequestResetPasswordEventClick>(requestResetPasswordEventClick);
    on<OnVerifyOtpEvent>(onVerifyOtpEvent);
    on<ResetPasswordEventClick>(resetPasswordEventClick);
    // on<AuthEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  Future<FutureOr<void>> signInEventClick(
      SignInEventClick event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    AuthRepository authRepository = AuthRepository();
    Map<String, String> formData = {
      'username': event.userData,
      'password': event.password,
    };
    AppUtils().debuglog(formData);

    // Map<String, String> data = {
    //   'email': 'bursar11@gmail.com',
    //   'password': 'bursar11',
    // };
    try {
      // var response =
      //     await authRepository.authPostRequest(data, AppApis.loginCreateToken);
      final loginResponse =
          await authRepository.authPostRequest(formData, AppApis.loginStudent);

      AppUtils().debuglog('Response status: ${loginResponse.statusCode}');
      AppUtils().debuglog('Response body: ${loginResponse.body}');
      AppUtils().debuglog(loginResponse.statusCode);

      AppUtils().debuglog(loginResponse.body);
      if (loginResponse.statusCode == 200 || loginResponse.statusCode == 201) {
        await SharedPref.putString(
            "refresh-token", json.decode(loginResponse.body)['refresh']);

        await SharedPref.putString(
            "access-token", json.decode(loginResponse.body)['access']);

        emit(SuccessState("Login Successful"));
      } else if (loginResponse.statusCode == 500 ||
          loginResponse.statusCode == 501) {
        emit(ErrorState(
            "There was a problem logging user in please try again later."));
        emit(AuthInitial());
      } else {
        emit(ErrorState(json.decode(loginResponse.body)['error']));
        //AppUtils().debuglog(event.password);
        AppUtils().debuglog(json.decode(loginResponse.body));
        emit(AuthInitial());
      }
    } catch (e) {
      AppUtils().debuglog(e);
      emit(ErrorState("There was a problem login you in please try again."));

      AppUtils().debuglog(e);
      emit(AuthInitial());
      AppUtils().debuglog(12345678);
    }
  }

  FutureOr<void> initialEvent(InitialEvent event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }

  Future<FutureOr<void>> requestResetPasswordEventClick(
      RequestResetPasswordEventClick event, Emitter<AuthState> emit) async {
    emit(LoadingState());


    AppUtils().debuglog(event.userData);
    String deviceId = await AppUtils.getId();

    try {
      // final response = await authRepository.authPostRequest(
      //     formData, AppApis.requestPasswordResetOtp)
      AppUtils().debuglog(event.isDeviceChange
          ? Uri.parse("${AppApis.appBaseUrl}/u-auth/resend-otp/")
          : Uri.parse('${AppApis.appBaseUrl}/u-auth/request-password-reset/'));
      AppUtils().debuglog(event.isDeviceChange
          ? {
              "usename": event.userData,
              'device_id':
                  event.userData.toLowerCase() == 'cprecious038@gmail.com' ||
                          event.userData == '2019514900'
                      ? '79477BA3-2FAC-4D76-B508-8D871AF7E62F'
                      : deviceId
            }
          : {'email': event.userData});
      var resetResponse = await http.post(
        event.isDeviceChange
            ? Uri.parse("${AppApis.appBaseUrl}/u-auth/resend-otp/")
            : Uri.parse('${AppApis.appBaseUrl}/u-auth/request-password-reset/'),
        body: event.isDeviceChange
            ? {
                "usename": event.userData,
                'device_id':
                    event.userData.toLowerCase() == 'cprecious038@gmail.com' ||
                            event.userData == '2019514900'
                        ? '79477BA3-2FAC-4D76-B508-8D871AF7E62F'
                        : deviceId
              }
            : {'email': event.userData},
      );

      AppUtils().debuglog('Response status: ${resetResponse.statusCode}');
      AppUtils().debuglog('Response body: ${resetResponse.body}');
      AppUtils().debuglog(resetResponse.statusCode);

      AppUtils().debuglog(resetResponse.body);
      if (resetResponse.statusCode == 200) {
        emit(OtpRequestSuccessState(
            json.decode(resetResponse.body)['message'], event.userData));
      } else if (resetResponse.statusCode == 500 ||
          resetResponse.statusCode == 501) {
        emit(ErrorState("Error Occurred please try again later."));
        emit(AuthInitial());
      } else {
        emit(ErrorState(json.decode(resetResponse.body)['error']));
        //AppUtils().debuglog(event.password);
        AppUtils().debuglog(json.decode(resetResponse.body));
        emit(AuthInitial());
      }
    } catch (e) {
      AppUtils().debuglog(e);
      emit(ErrorState("Error Requesting password reset"));

      emit(AuthInitial());
      AppUtils().debuglog(12345678);
    }
  }

  Future<FutureOr<void>> onVerifyOtpEvent(
      OnVerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());

    //AppUtils().debuglog(formData);

    try {
      var verifyResponse = await http.post(
        Uri.parse('${AppApis.appBaseUrl}/u-auth/verify-otp/'),
        body: {'email': event.userData, 'otp': event.otp.toString()},
      );
      AppUtils().debuglog('Response status: ${verifyResponse.statusCode}');
      AppUtils().debuglog('Response body: ${verifyResponse.body}');
      AppUtils().debuglog(verifyResponse.statusCode);

      AppUtils().debuglog(verifyResponse.body);

      if (verifyResponse.statusCode == 200) {
        AppUtils().debuglog(json.decode(verifyResponse.body)['access']);

        await SharedPref.putString("Reset-Password-Access-Token",
            json.decode(verifyResponse.body)['access']);
        AppUtils().debuglog(await SharedPref.getString('access-token'));

        emit(OtpVerificationSuccessState(
            json.decode(verifyResponse.body)['message']));
      } else if (verifyResponse.statusCode == 500 ||
          verifyResponse.statusCode == 501) {
        emit(ErrorState(
            "There was a problem verifying otp please try again later."));
        emit(AuthInitial());
      } else {
        emit(ErrorState(json.decode(verifyResponse.body)['error']));
        //AppUtils().debuglog(event.password);
        AppUtils().debuglog(json.decode(verifyResponse.body));
        emit(AuthInitial());
      }
    } catch (e) {
      AppUtils().debuglog(e);
      emit(ErrorState("Error Verifying otp"));

      emit(AuthInitial());
      AppUtils().debuglog(12345678);
    }
  }

  Future<FutureOr<void>> resetPasswordEventClick(
      ResetPasswordEventClick event, Emitter<AuthState> emit) async {
    emit(LoadingState());

    AppUtils().debuglog(event.password);

    // Map<String, String> data = {
    //   'email': 'bursar11@gmail.com',
    //   'password': 'bursar11',
    // };
    try {
      String jwtToken =
          await SharedPref.getString('Reset-Password-Access-Token');
      var resetPasswordResponse = await http.post(
        Uri.parse('${AppApis.appBaseUrl}/u-auth/reset-password/'),
        headers: {
          'Authorization': 'JWT $jwtToken',
        },
        body: {'new_password': event.password},
      );

      AppUtils()
          .debuglog('Response status: ${resetPasswordResponse.statusCode}');
      AppUtils().debuglog('Response body: ${resetPasswordResponse.body}');
      AppUtils().debuglog(resetPasswordResponse.statusCode);

      AppUtils().debuglog(resetPasswordResponse.body);

      if (resetPasswordResponse.statusCode == 200) {
        AppUtils().debuglog(resetPasswordResponse.body);
        // await SharedPref.putString(
        //     "refresh-token", json.decode(response.body)['refresh']);
        await SharedPref.putString("password", event.password);

        emit(ResetPasswordSuccessState(
            json.decode(resetPasswordResponse.body)['success']));
      } else if (resetPasswordResponse.statusCode == 401) {
        emit(AccessTokenExpireState());
      } else if (resetPasswordResponse.statusCode == 500 ||
          resetPasswordResponse.statusCode == 501) {
        emit(ErrorState(
            "There was a problem resting password please try again later."));
        emit(AuthInitial());
      } else {
        emit(ErrorState(json.decode(resetPasswordResponse.body)['detail']));
        //AppUtils().debuglog(event.password);
        AppUtils().debuglog(json.decode(resetPasswordResponse.body));
        emit(AuthInitial());
      }
    } catch (e) {
      AppUtils().debuglog(e);
      emit(ErrorState("Error Resetting password"));

      emit(AuthInitial());
      AppUtils().debuglog(12345678);
    }
  }
}
