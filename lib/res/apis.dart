class AppApis {
  static String appBaseUrl = "https://api.campusedge.net";
  static String imageBaseUrl = "https://nau-slc.s3.eu-west-2.amazonaws.com";

  // static String appBaseUrl = "https://portal.cbtq.app";
  // static String imageBaseUrl = "https://portal.cbtq.app";

  // static String imageBaseUrl = "http://192.168.0.155:8002";
  // static String appBaseUrl = "http://192.168.0.155:8002";

  ///Authentication Endpoints
  static String loginCreateToken = "$appBaseUrl/auth/jwt/create/";
  static String refreshTokenApi = "$appBaseUrl/auth/jwt/refresh/";
  static String verifyTokenApi = "$appBaseUrl/auth/jwt/refresh/";

  static String requestPasswordResetOtp =
      "$appBaseUrl/u-auth/request-password-reset/";
  static String verifyOtp = "$appBaseUrl/u-auth/verify-otp/";
  static String resetPassword = "$appBaseUrl/u-auth/reset-password/";
  static String loginStudent = "$appBaseUrl/u-auth/login-student/";




}
