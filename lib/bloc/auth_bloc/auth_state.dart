part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class OnClickedState extends AuthState {}

class LoadingState extends AuthState {}

class AccessTokenExpireState extends AuthState {}

class ErrorState extends AuthState {
  final String error;

  ErrorState(this.error);
}

class SuccessState extends AuthState {
  final String msg;
  final UserModel? userModel;
  final CurrentPlan? currentPlan;
  final bool isTenant;
  SuccessState(
    this.msg, this.userModel, this.isTenant, this.currentPlan,
  );
}
class ProfileSetUpState extends AuthState {
  final String msg;

  ProfileSetUpState(
      this.msg,
      );
}
class ResetPasswordSuccessState extends AuthState {
  final String msg;

  ResetPasswordSuccessState(this.msg);
}

class OtpRequestSuccessState extends AuthState {
  final String msg;
  final String userData;

  OtpRequestSuccessState(this.msg, this.userData);
}

class OtpVerificationSuccessState extends AuthState {
  final String msg;
  final bool isNewAccount;

  //final String userData;

  OtpVerificationSuccessState(this.msg, this.isNewAccount);
}
