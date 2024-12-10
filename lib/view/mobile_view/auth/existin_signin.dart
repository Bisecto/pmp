// import 'dart:async';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cross_connectivity/cross_connectivity.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:provider/provider.dart';
// import 'package:pim/repository/auth_repository.dart';
// import 'package:pim/view/mobile_view/auth/sign_in_page.dart';
// import 'package:pim/view/mobile_view/auth/verify_user.dart';
// import 'package:pim/view/mobile_view/landing_page.dart';
// import 'package:pim/view/widgets/no_internet.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../bloc/auth_bloc/auth_bloc.dart';
// import '../../../res/app_colors.dart';
// import '../../../res/app_images.dart';
// import '../../../res/app_router.dart';
// import '../../../utills/app_navigator.dart';
// import '../../../utills/app_utils.dart';
// import '../../../utills/app_validator.dart';
// import '../../../utills/custom_theme.dart';
// import '../../../utills/shared_preferences.dart';
// import '../../important_pages/dialog_box.dart';
// import '../../important_pages/not_found_page.dart';
// import '../../widgets/app_custom_text.dart';
// import '../../widgets/custom_container.dart';
// import '../../widgets/form_button.dart';
// import '../../widgets/form_input.dart';
// import '../../widgets/update.dart';
// import 'forgot_password/password_reset_request.dart';
//
// class ExistingSignIn extends StatefulWidget {
//   const ExistingSignIn({super.key});
//
//   @override
//   State<ExistingSignIn> createState() => _ExistingSignInState();
// }
//
// class _ExistingSignInState extends State<ExistingSignIn> {
//   final formKey = GlobalKey<FormState>();
//   bool canUseBiometrics = false;
//   final _passwordController = TextEditingController();
//   final AuthBloc authBloc = AuthBloc();
//   String firstname = '';
//   String userData = '';
//   String password = '';
//   List<String> localSavedTopics = [];
//   final LocalAuthentication auth = LocalAuthentication();
//
//   //String
//
//   getSavedUser() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     String savedUserFirstname = await SharedPref.getString('firstname');
//     String savedUserData = await SharedPref.getString('userData');
//     String savedPassword = await SharedPref.getString('password');
//     List<String> savedTopics = prefs.getStringList('SubscribedTopics') ?? [];
//
//     setState(() {
//       firstname = savedUserFirstname ??
//           ''; // Use ?? '' to provide a default value if null
//       userData = savedUserData ?? '';
//       password = savedPassword ?? '';
//
//       localSavedTopics = savedTopics;
//       AppUtils().debuglog(localSavedTopics);
//     });
//
//     AppUtils().debuglog(firstname);
//     AppUtils().debuglog(userData);
//   }
//
//   final _formKey = GlobalKey<FormState>();
//   AuthRepository authRepository = AuthRepository();
//
//   String appName = '';
//   String packageName = '';
//   String version = '';
//   String buildNumber = '';
//   String LatestVersion = '';
//   String LatestBuildNumber = '';
//   bool isAppUpdated = true;
//   String appUrl = '';
//   bool _connected = true;
//
//   Fetch_App_Details() async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     setState(() {
//       appName = packageInfo.appName;
//       packageName = packageInfo.packageName;
//       version = packageInfo.version;
//       buildNumber = packageInfo.buildNumber;
//       debugPrint(version);
//       debugPrint(buildNumber);
//     });
//   }
//
//   CheckUpdate() async {
//     ///'Hello1');
//     if (Platform.isAndroid) {
//       ///'Hello2');
//       FirebaseFirestore.instance
//           .collection('AppInfo')
//           .where('dataKey', isEqualTo: 'android') //.doc(userId)
//           .get()
//           .then((QuerySnapshot querySnapshot) {
//         for (var data in querySnapshot.docs) {
//           debugPrint(data.toString());
//           setState(() {
//             LatestVersion = data['version'];
//             LatestBuildNumber = data['buildNumber'];
//             appUrl = data['androidUrl'];
//
//             ///LatestVersion);
//           });
//           if (LatestVersion == version) {
//             isAppUpdated = true;
//           } else if (LatestVersion != version) {
//             if (data['isUpdate']) {
//               isAppUpdated = false;
//             } else {
//               isAppUpdated = true;
//             }
//           } else if (LatestVersion.isEmpty) {
//             isAppUpdated = true;
//           } else if (LatestVersion.toString() == 'null') {
//             isAppUpdated = true;
//           } else {
//             isAppUpdated = true;
//           }
//         }
//       });
//     } else if (Platform.isIOS) {
//       await FirebaseFirestore.instance
//           .collection('AppInfo')
//           .doc('iOS-version-IOS')
//           .get()
//           .then((DocumentSnapshot documentSnapshot) {
//         if (documentSnapshot.exists) {
//           Map<String, dynamic> data =
//               documentSnapshot.data()! as Map<String, dynamic>;
//
//           setState(() {
//             LatestVersion = data['version'];
//             LatestBuildNumber = data['buildNumber'];
//             appUrl = data['iosUrl'];
//             debugPrint(LatestVersion);
//             debugPrint(LatestBuildNumber);
//           });
//           if (LatestVersion == version) {
//             isAppUpdated = true;
//           } else if (LatestVersion != version) {
//             if (data['isUpdate']) {
//               isAppUpdated = false;
//             } else {
//               isAppUpdated = true;
//             }
//           } else if (LatestVersion.isEmpty) {
//             isAppUpdated = true;
//           } else if (LatestVersion.toString() == 'null') {
//             isAppUpdated = true;
//           } else {
//             isAppUpdated = true;
//           }
//         } else {
//           isAppUpdated = true;
//         }
//       });
//     }
//   }
//
//   StreamSubscription<ConnectivityStatus>? _connectivitySubscription;
//   bool canUseBiometrics2 = false;
//
//   @override
//   void initState() {
//     super.initState();
//     getCanUseBiometrics();
//     getCanUseBiometrics2();
//
//     getSavedUser();
//     authBloc.add(InitialEvent());
//     _checkConnectivity();
//     _connectivitySubscription =
//         Connectivity().onConnectivityChanged.listen(_handleConnectivity);
//   }
//
//   getCanUseBiometrics() async {
//     bool isBiometricsEnabled = await SharedPref.getBool('biometric') ?? false;
//     var availableBiometrics = await auth.getAvailableBiometrics();
//     canUseBiometrics = await auth.canCheckBiometrics &&
//         await auth.isDeviceSupported() &&
//         availableBiometrics.isNotEmpty &&
//         isBiometricsEnabled;
//   }
//
//   Future<void> getCanUseBiometrics2() async {
//     var availableBiometrics = await auth.getAvailableBiometrics();
//     bool canCheckBiometrics = await auth.canCheckBiometrics;
//     bool isDeviceSupported = await auth.isDeviceSupported();
//     setState(() {
//       // Ensure each condition evaluates to a boolean
//       canUseBiometrics2 = canCheckBiometrics && // Note the function call
//           isDeviceSupported &&
//           availableBiometrics.isNotEmpty;
//     });
//   }
//
//   Future<void> _checkConnectivity() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     _handleConnectivity(connectivityResult);
//   }
//
//   void _handleConnectivity(ConnectivityStatus result) {
//     if (result == ConnectivityStatus.none) {
//       debugPrint("No network");
//       setState(() {
//         _connected = false;
//       });
//     } else {
//       debugPrint("Network connected");
//       Fetch_App_Details();
//       CheckUpdate();
//       setState(() {
//         _connected = true;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _connectivitySubscription?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeContext = Provider.of<CustomThemeState>(context);
//     final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
//     //if (isAppUpdated) {
//
//     return _connected
//         ? (isAppUpdated
//             ? Scaffold(
//                 body: BlocConsumer<AuthBloc, AuthState>(
//                     bloc: authBloc,
//                     listenWhen: (previous, current) => current is! AuthInitial,
//                     buildWhen: (previous, current) => current is! AuthInitial,
//                     listener: (context, state) {
//                       if (state is SuccessState) {
//                         MSG.snackBar(context, state.msg);
//
//                         AppNavigator.pushAndRemovePreviousPages(context,
//                             page: LandingPage(
//                               selectedIndex: 0,
//                             ));
//                       }  else if (state is AccessTokenExpireState) {
//                         AppNavigator.pushAndRemovePreviousPages(context,
//                             page: const ExistingSignIn());
//                       } else if (state is ErrorState) {
//                         MSG.warningSnackBar(context, state.error);
//                       }
//                     },
//                     builder: (context, state) {
//                       switch (state.runtimeType) {
//                         // case PostsFetchingState:
//                         //   return const Center(
//                         //     child: CircularProgressIndicator(),
//                         //   );
//                         case AuthInitial || ErrorState:
//                           return SafeArea(
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(20.0),
//                                     child: Column(
//                                       //mainAxisAlignment: MainAxisAlignment.start,
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         // const SizedBox(
//                                         //   height: 20,
//                                         // ),
//                                         // CustomText(
//                                         //   text: "Login to your account",
//                                         //   weight: FontWeight.bold,
//                                         //   color: theme.isDark
//                                         //       ? AppColors.white
//                                         //       : AppColors
//                                         //           .darkCardBackgroundColor,
//                                         //   size: 20,
//                                         // ),
//                                         const SizedBox(
//                                           height: 20,
//                                         ),
//                                         CircleAvatar(
//                                           radius: 50,
//                                           backgroundColor: theme.isDark
//                                               ? AppColors
//                                                   .darkCardBackgroundColor
//                                               : AppColors.white,
//                                           child: Image.asset(
//                                             AppImages.logo,
//                                             height: 100,
//                                             width: 100,
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           height: 20,
//                                         ),
//                                         SizedBox(
//                                           // height: 20,
//                                           child: Text(
//                                             "Welcome Back, $firstname",
//                                             textAlign: TextAlign.center,
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.w700,
//                                               fontSize: 20,
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           //width: deviceSize.width / 2,
//                                           child: Text(
//                                             'We missed you.',
//                                             textAlign: TextAlign.center,
//                                             style:
//                                                 TextStyle(color: Colors.grey),
//                                           ),
//                                         ),
//                                         Form(
//                                             key: _formKey,
//                                             child: Column(
//                                               children: [
//                                                 CustomTextFormField(
//                                                   label: 'Password',
//                                                   isPasswordField: true,
//                                                   borderColor:
//                                                       AppColors.mainAppColor,
//                                                   backgroundColor: theme.isDark
//                                                       ? AppColors
//                                                           .darkCardBackgroundColor
//                                                       : AppColors.white,
//                                                   hintColor: !theme.isDark
//                                                       ? AppColors
//                                                           .darkCardBackgroundColor
//                                                       : AppColors.grey,
//                                                   validator: AppValidator
//                                                       .validateTextfield,
//                                                   controller:
//                                                       _passwordController,
//                                                   hint: 'Enter your password',
//                                                   icon: Icons.lock_outline,
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 10,
//                                                 ),
//                                                 FormButton(
//                                                   onPressed: () async {
//                                                     if (_formKey.currentState!
//                                                         .validate()) {
//                                                       authBloc.add(
//                                                           SignInEventClick(
//                                                               userData
//                                                                   .toLowerCase(),
//                                                               _passwordController
//                                                                   .text));
//                                                     }
//                                                   },
//                                                   text: 'Login',
//                                                   borderColor:
//                                                       AppColors.mainAppColor,
//                                                   bgColor:
//                                                       AppColors.mainAppColor,
//                                                   textColor: AppColors.white,
//                                                   borderRadius: 10,
//                                                   height: 50,
//                                                 ),
//                                                 if (canUseBiometrics2)
//                                                   SizedBox(
//                                                     height: 5,
//                                                   ),
//                                                 if (canUseBiometrics2)
//                                                   CustomText(
//                                                     text: !canUseBiometrics
//                                                         ? "For subsequent login, you can make use of biometrics login by toggling it on from the settings page."
//                                                         : '',
//                                                     maxLines: 3,
//                                                     size: 12,
//                                                   )
//                                               ],
//                                             )),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 20.0),
//                                     child: Align(
//                                       alignment: Alignment.topLeft,
//                                       child: InkWell(
//                                         onTap: () async {
//                                           //AppUtils().clearSharedPrefrence();
//
//                                           SharedPref.remove('userData');
//                                           SharedPref.remove('firstname');
//                                           SharedPref.remove('password');
//                                           String? apnsToken =
//                                               await firebaseMessaging
//                                                   .getAPNSToken();
//                                           print('APNS Token: $apnsToken');
//                                           print(localSavedTopics);
//                                           AppNavigator.pushAndReplaceName(
//                                               context,
//                                               name: AppRouter.signInPage);
//                                           for (int i = 0;
//                                               i < localSavedTopics.length;
//                                               i++) {
//                                             print(localSavedTopics[i]);
//                                             await firebaseMessaging
//                                                 .unsubscribeFromTopic(
//                                                     localSavedTopics[i]);
//                                             print(localSavedTopics[i]);
//
//                                             //print(it)
//                                           }
//                                         },
//                                         child: RichText(
//                                           text: TextSpan(
//                                             text: "Not $firstname? ",
//                                             style: const TextStyle(
//                                                 color: Colors.grey,
//                                                 fontFamily: "CeraPro"),
//                                             children: [
//                                               const TextSpan(
//                                                 text: 'Switch Account',
//                                                 style: TextStyle(
//                                                     color:
//                                                         AppColors.mainAppColor,
//                                                     fontWeight: FontWeight.bold,
//                                                     fontFamily: "CeraPro"),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 20,
//                                   ),
//                                   canUseBiometrics
//                                       ? Column(
//                                           children: [
//                                             const Center(
//                                               child: Text("Or"),
//                                             ),
//                                             const SizedBox(
//                                               height: 20,
//                                             ),
//                                             _buildFingerPrint(authBloc),
//                                           ],
//                                         )
//                                       : const SizedBox(),
//                                   const SizedBox(
//                                     height: 40,
//                                   ),
//                                   Align(
//                                     alignment: Alignment.bottomCenter,
//                                     child: Column(
//                                       children: [
//                                         CustomText(
//                                             text: 'Powered by',
//                                             size: 14,
//                                             color: theme.isDark
//                                                 ? AppColors.white
//                                                 : AppColors.black),
//                                         Image.asset(
//                                           AppImages.companyLogo,
//                                           height: 40,
//                                           width: 150,
//                                           //color: AppColors.darkModeBlack,
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           );
//
//                         case LoadingState:
//                           return const Center(
//                             child: AppLoadingPage("Signing user in..."),
//                           );
//                         default:
//                           return const Center(
//                             child: AppLoadingPage("Signing user in..."),
//                           );
//                       }
//                     }),
//                 floatingActionButton: FloatingActionButton.extended(
//                   //mini: true,
//
//                   onPressed: () async {
//                     if (Platform.isAndroid) {
//                       if (await canLaunchUrl(Uri.parse(
//                           'https://support.unizik.edu.ng/open.php'))) {
//                         await launchUrl(Uri.parse(
//                             'https://support.unizik.edu.ng/open.php'));
//                       } else {
//                         throw 'Could not launch https://support.unizik.edu.ng/open.php';
//                       }
//
//                       //launch("https://play.google.com/store/apps/details?id=com.jithvar.gambhir_mudda");
//                     } else if (Platform.isIOS) {
//                       // iOS-specific code
//                       if (await canLaunchUrl(Uri.parse(
//                           'https://support.unizik.edu.ng/open.php'))) {
//                         await launchUrl(Uri.parse(
//                             'https://support.unizik.edu.ng/open.php'));
//                       } else {
//                         throw 'Could not launch https://support.unizik.edu.ng/open.php';
//                       }
//                     }
//                   },
//                   icon: const Icon(
//                     Icons.chat,
//                     color: AppColors.white,
//                   ),
//                   label: const CustomText(
//                     text: "Support",
//                     color: AppColors.white,
//                   ),
//                   backgroundColor: AppColors.mainAppColor,
//                 ),
//                 floatingActionButtonLocation:
//                     FloatingActionButtonLocation.endFloat,
//               )
//             : UpdateApp(
//                 appUrl: appUrl,
//               ))
//         : No_internet_Page(onRetry: _checkConnectivity);
//   }
//
// // BlocConsumer<AuthBloc, AuthState>(
// //     bloc: authBloc,
// //     listenWhen: (previous, current) => current is! AuthInitial,
// //     buildWhen: (previous, current) => current is! AuthInitial,
// //     listener: (context, state) {
// //       if (state is SuccessState) {
// //         AppNavigator.pushNamedAndRemoveUntil(context,
// //             name: AppRouter.landingPage);
// //         showToast(
// //             context: context,
// //             title: 'Successful',
// //             subtitle: state.msg,
// //             type: ToastMessageType.success);
// //       } else if (state is ErrorState) {
// //         showToast(
// //             context: context,
// //             title: 'Error',
// //             subtitle: state.error,
// //             type: ToastMessageType.error);
// //       } else if (state is AuthOtpRequestState) {
// //         AppNavigator.pushAndStackPage(context,
// //             page: VerifyOtp(
// //               userData: state.userData,
// //               isDeviceChanged: state.isDeviceChanged,
// //             ));
// //         showToast(
// //             context: context,
// //             title: "Info",
// //             subtitle: state.msg,
// //             type: ToastMessageType.info);
// //       }
// //       // else if (state is VerificationContinueState) {
// //       //   AppNavigator.pushAndStackNamed(context,
// //       //       name: AppRouter.otpVerification);
// //       // }
// //     },
// //     builder: (context, state) {
// //       switch (state.runtimeType) {
// //       // case PostsFetchingState:
// //       //   return const Center(
// //       //     child: CircularProgressIndicator(),
// //       //   );
// //         case AuthInitial || ErrorState:
// //           return Padding(
// //             padding: const EdgeInsets.all(20.0),
// //             child: SingleChildScrollView(
// //               child: Form(
// //                 key: formKey,
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     SizedBox(
// //                       height: 70,
// //                     ),
// //                     CircleAvatar(
// //                       radius: 60,
// //                       //backgroundColor: AppColors.mainAppColor,
// //                       backgroundImage: AssetImage(
// //                         AppPngImages.loggedIn,
// //
// //                       ),
// //                     ),
// //                     SizedBox(
// //                       height: 30,
// //                     ),
// //                     SizedBox(
// //                       // height: 20,
// //                       child: Text(
// //                         "Welcome Back, $firstname",
// //                         textAlign: TextAlign.center,
// //                         style: const TextStyle(
// //                           fontWeight: FontWeight.w700,
// //                           fontSize: 20,
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(
// //                       height: 2,
// //                     ),
// //                     SizedBox(
// //                       //width: deviceSize.width / 2,
// //                       child: Text(
// //                         'We missed you.',
// //                         textAlign: TextAlign.center,
// //                         style: TextStyle(color: Colors.grey),
// //                       ),
// //                     ),
// //                     const SizedBox(
// //                       height: 15,
// //                     ),
// //                     CustomTextFormField(
// //                       label: 'Password',
// //                       isPasswordField: true,
// //                       validator: AppValidator.validatePassword,
// //                       controller: _passwordController,
// //                       hint: '**********',
// //                       icon: Icons.password,
// //                       borderColor: _passwordController.text.isNotEmpty
// //                           ? AppColors.mainAppColor
// //                           : AppColors.grey,
// //                     ),
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: Container(
// //                             width: double.infinity,
// //                             alignment: Alignment.centerRight,
// //                             child: CustomText(
// //                               text: "Forgot Password?",
// //                               color: AppColors.mainAppColor,
// //                               size: 14,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //
// //
// //                     const SizedBox(height: 20),
// //                     InkWell(
// //                       onTap: () {
// //                         AppUtils().clearSharedPrefrence();
// //                         Navigator.pushReplacement(
// //                             context,
// //                             MaterialPageRoute(
// //                                 builder: (context) =>
// //                                 const SignInScreen()));
// //                       },
// //                       child: RichText(
// //                         text: TextSpan(
// //                           text: "Not $firstname? ",
// //                           style: TextStyle(
// //                               color: Colors.grey, fontFamily: "CeraPro"),
// //                           children: [
// //                             TextSpan(
// //                               text: 'Switch Account',
// //                               style: TextStyle(
// //                                   color: AppColors.mainAppColor,
// //                                   fontWeight: FontWeight.bold,
// //                                   fontFamily: "CeraPro"),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           );
// //
// //       // case AuthOtpRequestState:
// //       //   final otpData = state as AuthOtpRequestState;
// //       //
// //       // return OTPPage(
// //       // email: otpData.email,
// //       // otpReason: 'account_verification',
// //       // );
// //       // case UpdateUserProfileState:
// //       // final profileState = state as UpdateUserProfileState;
// //       //
// //       // return UserProfilePage(
// //       // email: profileState.userEmail,
// //       // );
// //       // case LoadingState:
// //       //   return const Center(
// //       //     child: CircularProgressIndicator(),
// //       //   );
// //         default:
// //           return const Center(
// //             child: NotFoundPage(),
// //           );
// //       }
// //     }),
//   _buildFingerPrint(AuthBloc authBloc) {
//     return InkWell(
//       onTap: () async {
//         bool didAuthenticate =
//             await AppUtils.biometrics("Please authenticate to sign in");
//         if (didAuthenticate) {
//           authBloc.add(SignInEventClick(userData.toLowerCase(), password));
//           // model.signIn(context, withBiometrics: true);
//         }
//       },
//       child: Container(
//         width: 100,
//         alignment: Alignment.center,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.grey, width: 1.5)),
//         child: const InkWell(
//           child: Icon(
//             Icons.fingerprint_outlined,
//             size: 50,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }
