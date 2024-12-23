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

class SetUpProfileEventClick extends AuthEvent {
  final String firstname;
  final String lastname;
  final String phoneNumber;
  final XFile? profileImage;
  final String userName;

  SetUpProfileEventClick(this.firstname, this.lastname, this.phoneNumber,
      this.profileImage, this.userName);
}

class UpdateProfileEventClick extends AuthEvent {
  final String firstname;
  final String lastname;
  final String phoneNumber;
  final XFile? profileImage;
  final String userName;
  final String email;

  UpdateProfileEventClick(this.firstname, this.lastname, this.phoneNumber,
      this.profileImage, this.userName, this.email);
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
  final bool isNewAccount;

  RequestResetPasswordEventClick(this.userData, this.isNewAccount);
}

class RequestResendOTPEventClick extends AuthEvent {
  final String userData;
  final bool isNewAccount;

  RequestResendOTPEventClick(this.userData, this.isNewAccount);
}

class FindMyEmailEventClick extends AuthEvent {
  final String regNo;
  final BuildContext context;

  FindMyEmailEventClick(this.regNo, this.context);
}

class OnVerifyOtpEvent extends AuthEvent {
  final String otp;
  final String userData;
  final bool isNewAccount;

  // final String loginOption;
  // final String accessPin;

  OnVerifyOtpEvent(this.otp, this.userData, this.isNewAccount);
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
  final String confirmPassword;
  final String token;

  // final String loginOption;
  // final String accessPin;

  ResetPasswordEventClick(
      this.userData, this.password, this.confirmPassword, this.token);
}
