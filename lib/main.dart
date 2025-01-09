import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:pim/res/app_router.dart';
import 'package:pim/utills/app_utils.dart';
import 'package:pim/utills/custom_theme.dart';
import 'package:pim/view/mobile_view/splash_screen.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

// Remove the redundant import of `firebase_core.dart` here
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}


void main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();

  // Remove the call to Firebase.initializeApp() from here

  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(
    MyApp(adaptiveThemeMode: savedThemeMode ?? AdaptiveThemeMode.light),
  );
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? adaptiveThemeMode;

  MyApp({Key? key, this.adaptiveThemeMode}) : super(key: key);

  final AppRouter _appRoutes = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CustomThemeState>(
          create: (_) => CustomThemeState(adaptiveThemeMode!),
        ),
      ],
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1)),
        child: AdaptiveTheme(
          light: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.purple,
            fontFamily: "CeraPro",
          ),
          dark: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.purple,
            fontFamily: "CeraPro",
          ),
          initial: adaptiveThemeMode!,
          builder: (theme, darkTheme) => MaterialApp(
            title: 'PMP',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: _appRoutes.onGenerateRoute,
            theme: theme,
            darkTheme: darkTheme,
            home: const SplashScreen(),
          ),
        ),
      ),
    );
  }
}
