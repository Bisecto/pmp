class AppApis {
  static String appBaseUrl = "https://property.appleadng.net";

  ///static String imageBaseUrl = "https://nau-slc.s3.eu-west-2.amazonaws.com";

  ///Authentication Endpoints
  static String registerApi = "$appBaseUrl/api/register/";
  static String profile = "$appBaseUrl/api/profile/";
  static String currentPlan = "$appBaseUrl/api/subscription/subscriptions/current/";
  static String tenantProfile = "$appBaseUrl/api/occupant/profile/";
  static String verifyOTP = "$appBaseUrl/api/verify-email/";
  static String validateOTP = "$appBaseUrl/api/password-reset/validate/";
  static String resendOTP = "$appBaseUrl/api/password-reset/resend-request/";
  static String confirmPasswordResend =
      "$appBaseUrl/api/password-reset/confirm/";

  static String requestPasswordResendOtp =
      "$appBaseUrl/api/password-reset/resend-request/";
  static String requestPasswordResetOtp =
      "$appBaseUrl/api/password-reset/request/";
  static String emailVerification =
      "$appBaseUrl/api/resend-verification-token/";
  static String resetPassword = "$appBaseUrl/u-auth/reset-password/";
  static String loginApi = "$appBaseUrl/api/login/";
  static String occupantLoginApi = "$appBaseUrl/api/occupant/login/";

  static String planListApi = "$appBaseUrl/api/subscription/plans/";
  static String initializePlan = "$appBaseUrl/api/subscription/payment/initialize/";


  static String propertiesListApi = "$appBaseUrl/api/list-of-properties/";
  static String singlePropertyApi = "$appBaseUrl/api/property/detail/";
  static String singleSpaceApi = "$appBaseUrl/api/properties/";
  static String addPropertyApi = "$appBaseUrl/api/add-property/";
  static String updatePropertyApi = "$appBaseUrl/api/property/detail/";
  static String addOccupantApi = "$appBaseUrl/api/add-occupant/";
  static String updateOccupantApi = "$appBaseUrl/api/occupant/";
  static String singleOccupantApi = "$appBaseUrl/api/occupant/";
  static String deleteProfile = "$appBaseUrl/api/profile/delete";


}
