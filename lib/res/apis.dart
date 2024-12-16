class AppApis {
  static String appBaseUrl = "https://property.appleadng.net";
  ///static String imageBaseUrl = "https://nau-slc.s3.eu-west-2.amazonaws.com";

  ///Authentication Endpoints
  static String registerApi = "$appBaseUrl/api/register/";
  static String verifyOTP = "$appBaseUrl/api/verify_email/";

  static String requestPasswordResetOtp =
      "$appBaseUrl/u-auth/request-password-reset/";
  static String resetPassword = "$appBaseUrl/u-auth/reset-password/";
  static String loginApi = "$appBaseUrl/api/login/";




}
