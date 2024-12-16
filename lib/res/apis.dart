class AppApis {
  static String appBaseUrl = "https://property.appleadng.net";
  ///static String imageBaseUrl = "https://nau-slc.s3.eu-west-2.amazonaws.com";

  ///Authentication Endpoints
  static String registerApi = "$appBaseUrl/api/register/";
  static String profile = "$appBaseUrl/api/profile/";
  static String verifyOTP = "$appBaseUrl/api/verify_email/";
  static String validateOTP = "$appBaseUrl/api/password-reset/validate/";
  static String resendOTP = "$appBaseUrl/api/password-reset/resend-request/";
  static String confirmPasswordResend = "$appBaseUrl/api/password-reset/confirm/";

  static String requestPasswordResetOtp =
      "$appBaseUrl/api/password-reset/request/";
  static String resetPassword = "$appBaseUrl/u-auth/reset-password/";
  static String loginApi = "$appBaseUrl/api/login/";




}
