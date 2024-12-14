import 'package:flutter/material.dart';

import '../view/important_pages/not_found_page.dart';
import '../view/important_pages/notification_page.dart';
import '../view/mobile_view/auth/sign_in_page.dart';
import '../view/mobile_view/landing_page.dart';
import '../view/mobile_view/splash_screen.dart';

class AppRouter {
  ///All route name

  /// ONBOARDING SCREEEN
  static const String splashScreen = '/';

  //static const String onBoardingScreen = "/on-boarding-screen";

  /// AUTH SCREENS
  static const String signInPage = "/sign-in-page";
  static const String exixtingSignInPage = "/existing-sign-in-page";

  //static const String otpPage = "/otp-page";
  static const String signUpPageGetStarted = "/sign-up-page-get-started";

  ///IMPORTANT SCREENS
  static const String noInternetScreen = "/no-internet";

  ///LANDING PAGE LandingPage
  static const String landingPage = "/landing-page";

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      // case onBoardingScreen:
      //   return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case signInPage:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case landingPage:
        return MaterialPageRoute(
            builder: (_) => LandingPage(
                  selectedIndex: 0,
                ));
      default:
        return MaterialPageRoute(builder: (_) => const AppLoadingPage('Loading'));
    }
  }
}
