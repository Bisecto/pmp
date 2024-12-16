part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class InitialEvent extends AuthEvent {}

class SignInEventClick extends AuthEvent {
  final String userData;
  final String password;

  // final String loginOption;
  // final String accessPin;

  SignInEventClick(this.userData, this.password);
}

class SignUpEventClick extends AuthEvent {
  final String email;
  final String userName;
  final String password;
  final String confirmPassword;

  // final String loginOption;
  // final String accessPin;

  SignUpEventClick(
      this.email, this.password, this.userName, this.confirmPassword);
}

class RequestResetPasswordEventClick extends AuthEvent {
  final String userData;
  final bool isDeviceChange;

  RequestResetPasswordEventClick(this.userData, this.isDeviceChange);
}

class FindMyEmailEventClick extends AuthEvent {
  final String regNo;
  final BuildContext context;

  FindMyEmailEventClick(this.regNo, this.context);
}

class OnVerifyOtpEvent extends AuthEvent {
  final String otp;
  final String userData;

  // final String loginOption;
  // final String accessPin;

  OnVerifyOtpEvent(this.otp, this.userData);
}

class OnVerifyDeviceEvent extends AuthEvent {
  final String otp;
  final String userData;
  final String password;

  // final String loginOption;
  // final String accessPin;

  OnVerifyDeviceEvent(this.otp, this.userData, this.password);
}

class ResetPasswordEventClick extends AuthEvent {
  final String userData;
  final String password;

  // final String loginOption;
  // final String accessPin;

  ResetPasswordEventClick(this.userData, this.password);
}
