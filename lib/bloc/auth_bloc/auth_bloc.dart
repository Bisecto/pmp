import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import 'package:http/http.dart' as http;

import '../../model/user_model.dart';
import '../../repository/auth_repository.dart';
import '../../repository/fcm_topics.dart';
import '../../repository/repository.dart';
import '../../res/apis.dart';
import '../../utills/app_utils.dart';
import '../../utills/shared_preferences.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignInEventClick>(signInEventClick);
    on<SetUpProfileEventClick>(setUpProfileEventClick);
    on<SignUpEventClick>(signUpEventClick);
    on<InitialEvent>(initialEvent);
    on<RequestResetPasswordEventClick>(requestResetPasswordEventClick);
    on<RequestResendOTPEventClick>(requestResendOTPEventClick);
    on<OnVerifyOtpEvent>(onVerifyOtpEvent);
    on<ResetPasswordEventClick>(resetPasswordEventClick);
    on<UpdateProfileEventClick>(updateProfileEventClick);
    // on<AuthEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  Future<FutureOr<void>> signInEventClick(
      SignInEventClick event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    AppRepository appRepository = AppRepository();
    AuthRepository authRepository = AuthRepository();
    Map<String, String> formData = {
      'username_or_email': event.userData,
      'password': event.password,
    };
    AppUtils().debuglog(formData);

    try {
      final loginResponse =
          await authRepository.authPostRequest(formData, AppApis.loginApi);

      AppUtils().debuglog('Response status: ${loginResponse.statusCode}');
      AppUtils().debuglog('Response body: ${loginResponse.body}');
      AppUtils().debuglog(loginResponse.statusCode);

      AppUtils().debuglog(loginResponse.body);
      if (loginResponse.statusCode == 200 || loginResponse.statusCode == 201) {
        await SharedPref.putString(
            "refresh-token", json.decode(loginResponse.body)['refresh']);

        await SharedPref.putString(
            "access-token", json.decode(loginResponse.body)['access']);
        final profileResponse = await appRepository.getRequestWithToken(
            json.decode(loginResponse.body)['access'], AppApis.profile);
        AppUtils().debuglog('Response body: ${profileResponse.body}');
        if (profileResponse.statusCode == 200 ||
            profileResponse.statusCode == 201) {
          UserModel userModel =
              UserModel.fromJson(json.decode(profileResponse.body));
          emit(SuccessState("Login Successful", userModel));
        } else if (profileResponse.statusCode == 404) {
          emit(ProfileSetUpState("Complete Profile Set up"));
        } else {
          emit(ErrorState("There was a problem fetching your profile"));
          emit(AuthInitial());
        }
      } else if (loginResponse.statusCode == 500 ||
          loginResponse.statusCode == 501) {
        emit(ErrorState(
            "There was a problem logging user in please try again later."));
        emit(AuthInitial());
      } else {
        emit(ErrorState(json
            .decode(loginResponse.body)['non_field_errors'][0]
            .toString()
            .replaceAll('{', '')
            .replaceAll('}', '')
            .replaceAll('\'', '')));
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
      AppUtils().debuglog(AppApis.requestPasswordResetOtp);
      var resetResponse = await http.post(
        Uri.parse(AppApis.requestPasswordResetOtp),
        body: {'email': event.userData},
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
        emit(ErrorState(json.decode(resetResponse.body)['error'] ??
            json.decode(resetResponse.body)['email'][0]));
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
      AppUtils().debuglog(
          event.isNewAccount ? AppApis.verifyOTP : AppApis.validateOTP);
      AppUtils().debuglog(event.isNewAccount
          ? {
              'username': event.userData,
              'verification_code': event.otp.toString()
            }
          : {'email': event.userData, 'reset_token': event.otp.toString()});
      var verifyResponse = await http.post(
        Uri.parse(event.isNewAccount ? AppApis.verifyOTP : AppApis.validateOTP),
        body: event.isNewAccount
            ? {
                'username': event.userData,
                'verification_code': event.otp.toString()
              }
            : {'email': event.userData, 'reset_token': event.otp.toString()},
      );
      AppUtils().debuglog('Response status: ${verifyResponse.statusCode}');
      AppUtils().debuglog('Response body: ${verifyResponse.body}');
      AppUtils().debuglog(verifyResponse.statusCode);

      AppUtils().debuglog(verifyResponse.body);

      if (verifyResponse.statusCode == 200) {
        emit(OtpVerificationSuccessState(
            json.decode(verifyResponse.body)['message'], event.isNewAccount));
      } else if (verifyResponse.statusCode == 500 ||
          verifyResponse.statusCode == 501) {
        emit(ErrorState(
            "There was a problem verifying otp please try again later."));
        emit(AuthInitial());
      } else {
        emit(ErrorState(json.decode(verifyResponse.body)['error'] ??
            json.decode(verifyResponse.body)['username'][0] ??
            json.decode(verifyResponse.body)['verification_code'][0] ??
            json.decode(verifyResponse.body)['reset_token'][0] ??
            json.decode(verifyResponse.body)['email'][0]));
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
      var resetPasswordResponse = await http.post(
        Uri.parse(
            '${AppApis.confirmPasswordResend}?email=${event.userData}&reset_token=${event.token}&new_password=${event.password}&confirm_password=${event.confirmPassword}'),
        // headers: {
        //   'Authorization': 'JWT $jwtToken',
        // },
        body: {
          'new_password': event.password,
          "email": event.userData,
          'reset_token': event.token,
          'confirm_password': event.confirmPassword
        },
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
            json.decode(resetPasswordResponse.body)['message']));
      } else if (resetPasswordResponse.statusCode == 500 ||
          resetPasswordResponse.statusCode == 501) {
        emit(ErrorState(
            "There was a problem resting password please try again later."));
        emit(AuthInitial());
      } else {
        emit(ErrorState(json.decode(resetPasswordResponse.body)['detail'] ??
            json.decode(resetPasswordResponse.body)['new_password'][0] ??
            json.decode(resetPasswordResponse.body)['email'][0] ??
            json.decode(resetPasswordResponse.body)['reset_token'][0] ??
            json.decode(resetPasswordResponse.body)['confirm_password'][0]));
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

  FutureOr<void> signUpEventClick(
      SignUpEventClick event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    AuthRepository authRepository = AuthRepository();
    Map<String, String> formData = {
      "email": event.email,
      "username": event.userName,
      "role": event.selectedRole.toLowerCase(),
      "password": event.password,
      "confirm_password": event.confirmPassword
    };

    AppUtils().debuglog(formData);

    try {
      final registerResponse =
          await authRepository.authPostRequest(formData, AppApis.registerApi);
      final responseBody = json.decode(registerResponse.body);

      if (registerResponse.statusCode == 200 ||
          registerResponse.statusCode == 201) {
        emit(SuccessState("Sign up Successful", null));
      } else if (registerResponse.statusCode == 500 ||
          registerResponse.statusCode == 501) {
        emit(ErrorState(
            "There was a problem signing the user in. Please try again later."));
        emit(AuthInitial());
      } else {
        // Handle specific field errors with null safety
        final errorMessage = responseBody['email']?[0] ??
            responseBody['username']?[0] ??
            responseBody['confirm_password']?[0] ??
            responseBody['password']?[0] ??
            "An unknown error occurred. Please try again.";

        emit(ErrorState(errorMessage));
        emit(AuthInitial());
      }
    } catch (e) {
      AppUtils().debuglog(e);
      emit(ErrorState("There was a problem logging you in. Please try again."));
      emit(AuthInitial());
      AppUtils().debuglog("Error details: $e");
    }
  }

  FutureOr<void> requestResendOTPEventClick(
      RequestResendOTPEventClick event, Emitter<AuthState> emit) async {
    emit(LoadingState());

    AppUtils().debuglog(event.userData);
    String deviceId = await AppUtils.getId();

    try {
      // final response = await authRepository.authPostRequest(
      //     formData, AppApis.requestPasswordResetOtp)
      AppUtils().debuglog(event.isNewAccount
          ? AppApis.emailVerification
          : AppApis.requestPasswordResendOtp);
      var resetResponse = await http.post(
        Uri.parse(event.isNewAccount
            ? AppApis.emailVerification
            : AppApis.requestPasswordResendOtp),
        body: {'email': event.userData},
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

  FutureOr<void> setUpProfileEventClick(
      SetUpProfileEventClick event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    AppRepository appRepository = AppRepository();
    Map<String, String> formData = {
      'mobile_phone': event.phoneNumber,
      'first_name': event.firstname,
      'last_name': event.lastname,
      'username': event.userName
    };
    AppUtils().debuglog(formData);
    String accessToken = await SharedPref.getString('access-token');
    try {
      final profileResponse =
          await appRepository.appPostRequestWithSingleImages(
              formData, AppApis.profile, event.profileImage, accessToken);

      AppUtils().debuglog('Response status: ${profileResponse.statusCode}');
      AppUtils().debuglog('Response body: ${profileResponse.body}');
      AppUtils().debuglog(profileResponse.statusCode);

      if (profileResponse.statusCode == 200 ||
          profileResponse.statusCode == 201) {
        UserModel userModel =
            UserModel.fromJson(json.decode(profileResponse.body));
        emit(SuccessState("Profile Updated Successful", userModel));
      } else if (profileResponse.statusCode == 500 ||
          profileResponse.statusCode == 501) {
        emit(ErrorState("There was a problem completing profile set up."));
        emit(AuthInitial());
      } else {
        emit(ErrorState(json.decode(profileResponse.body)['mobile_phone'][0] ??
            json.decode(profileResponse.body)['first_name'][0] ??
            json.decode(profileResponse.body)['username'][0] ??
            json.decode(profileResponse.body)['last_name'][0] ??
            json.decode(profileResponse.body)['profile_pic'][0]));
        //AppUtils().debuglog(event.password);
        AppUtils().debuglog(json.decode(profileResponse.body));
        emit(AuthInitial());
      }
    } catch (e) {
      AppUtils().debuglog(e);
      emit(ErrorState("There was a problem completing profile set up."));

      AppUtils().debuglog(e);
      emit(AuthInitial());
      AppUtils().debuglog(12345678);
    }
  }

  FutureOr<void> updateProfileEventClick(
      UpdateProfileEventClick event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    AppRepository appRepository = AppRepository();
    Map<String, String> formData = {
      'mobile_phone': event.phoneNumber,
      'first_name': event.firstname,
      'last_name': event.lastname,
      'username': event.userName,
      'email': event.email
    };
    AppUtils().debuglog(formData);
    String accessToken = await SharedPref.getString('access-token');
    try {
      final profileResponse =
          await appRepository.appPatchRequestWithSingleImages(formData,
              "${AppApis.profile}update/", event.profileImage, accessToken);

      AppUtils().debuglog('Response status: ${profileResponse.statusCode}');
      AppUtils().debuglog('Response body: ${profileResponse.body}');
      AppUtils().debuglog(profileResponse.statusCode);

      if (profileResponse.statusCode == 200 ||
          profileResponse.statusCode == 201) {
        UserModel userModel =
            UserModel.fromJson(json.decode(profileResponse.body));
        emit(SuccessState("Profile Updated Successful", userModel));
      } else if (profileResponse.statusCode == 500 ||
          profileResponse.statusCode == 501) {
        emit(ErrorState("There was a problem completing profile set up."));
        emit(AuthInitial());
      } else {
        emit(ErrorState(json.decode(profileResponse.body)['mobile_phone'][0] ??
            json.decode(profileResponse.body)['first_name'][0] ??
            json.decode(profileResponse.body)['username'][0] ??
            json.decode(profileResponse.body)['last_name'][0] ??
            json.decode(profileResponse.body)['profile_pic'][0]));
        //AppUtils().debuglog(event.password);
        AppUtils().debuglog(json.decode(profileResponse.body));
        emit(AuthInitial());
      }
    } catch (e) {
      AppUtils().debuglog(e);
      emit(ErrorState("There was a problem completing profile set up."));

      AppUtils().debuglog(e);
      emit(AuthInitial());
      AppUtils().debuglog(12345678);
    }
  }
}
