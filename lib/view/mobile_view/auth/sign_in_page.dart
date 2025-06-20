import 'dart:async';
import 'dart:io';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pim/view/mobile_view/auth/set_up_profile.dart';
import 'package:pim/view/mobile_view/auth/sign_up_screen.dart';
import 'package:pim/view/widgets/drop_down.dart';
import 'package:provider/provider.dart';
import 'package:pim/repository/auth_repository.dart';
import 'package:pim/view/mobile_view/auth/verify_user.dart';
import 'package:pim/view/mobile_view/landing_page.dart';
import 'package:pim/view/widgets/no_internet.dart';

import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_validator.dart';
import '../../../utills/custom_theme.dart';
import '../../important_pages/dialog_box.dart';
import '../../important_pages/not_found_page.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';
import '../../widgets/form_input.dart';
import '../../widgets/update.dart';
import '../tenant_landing_page.dart';
import 'forgot_password/password_reset_request.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();

  final _passwordController = TextEditingController();
  final AuthBloc authBloc = AuthBloc();
  AuthRepository authRepository = AuthRepository();

  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';
  String LatestVersion = '';
  String LatestBuildNumber = '';
  bool isAppUpdated = true;
  String appUrl = '';
  bool _connected = true;

  Fetch_App_Details() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
      debugPrint(version);
      debugPrint(buildNumber);
    });
  }

  StreamSubscription<ConnectivityStatus>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    authBloc.add(InitialEvent());
    _checkConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_handleConnectivity);
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _handleConnectivity(connectivityResult);
  }

  void _handleConnectivity(ConnectivityStatus result) {
    if (result == ConnectivityStatus.none) {
      debugPrint("No network");
      setState(() {
        _connected = false;
      });
    } else {
      debugPrint("Network connected");
      Fetch_App_Details();
      setState(() {
        _connected = true;
      });
    }
  }

  String selectedUser = 'Landlord';

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Provider.of<CustomThemeState>(context);
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
    //if (isAppUpdated) {

    return _connected
        ? (isAppUpdated
            ? Scaffold(
                backgroundColor: AppColors.white,
                body: BlocConsumer<AuthBloc, AuthState>(
                    bloc: authBloc,
                    listenWhen: (previous, current) => current is! AuthInitial,
                    buildWhen: (previous, current) => current is! AuthInitial,
                    listener: (context, state) {
                      if (state is SuccessState) {
                        MSG.snackBar(context, state.msg);

                        AppNavigator.pushAndRemovePreviousPages(context,
                            page: state.isTenant?TenantLandingPage( selectedIndex: 0,
                          userModel: state.userModel!,):LandingPage(
                              selectedIndex: 0,
                              userModel: state.userModel!, currentPlan: state.currentPlan!,
                            ));
                      } else if (state is ErrorState) {
                        MSG.warningSnackBar(context, state.error);
                      } else if (state is ProfileSetUpState) {
                        AppNavigator.pushAndStackPage(context,
                            page: SetUpProfile(
                              userName: _userNameController.text, currentPlan: null,
                            ));
                      }
                    },
                    builder: (context, state) {
                      switch (state.runtimeType) {
                        // case PostsFetchingState:
                        //   return const Center(
                        //     child: CircularProgressIndicator(),
                        //   );
                        case AuthInitial || ErrorState:
                          return SafeArea(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      //mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        CustomText(
                                          text: "Login",
                                          weight: FontWeight.bold,
                                          color: theme.isDark
                                              ? AppColors.white
                                              : AppColors
                                                  .darkCardBackgroundColor,
                                          size: 25,
                                        ),
                                        CustomText(
                                          text: "Login to your account",
                                          weight: FontWeight.w400,
                                          color: theme.isDark
                                              ? AppColors.white
                                              : Colors.black54,
                                          size: 16,
                                        ),
                                        // CircleAvatar(
                                        //   radius: 50,
                                        //   backgroundColor: theme.isDark
                                        //       ? AppColors
                                        //           .darkCardBackgroundColor
                                        //       : AppColors.white,
                                        //   child: Image.asset(
                                        //     AppImages.logo,
                                        //     height: 100,
                                        //     width: 100,
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Form(
                                            key: _formKey,
                                            child: Column(
                                              children: [
                                                DropDown(
                                                  selectedValue: selectedUser,
                                                  initialValue: selectedUser,
                                                  items: const [
                                                    'Landlord',
                                                    'Agent',
                                                    'Tenant'
                                                  ],
                                                  onChanged: (val){
                                                    setState(() {
                                                      selectedUser=val;
                                                    });
                                                  },
                                                  label: "Select User",
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                CustomTextFormField(
                                                  hint:
                                                      'Enter your email/username${selectedUser.toLowerCase()=='tenant'?"/phone number":""}',
                                                  label: 'Username/Email${selectedUser.toLowerCase()=='tenant'?"/phone number":""}',
                                                  borderColor: Colors.black54,
                                                  controller:
                                                      _userNameController,
                                                  backgroundColor: theme.isDark
                                                      ? AppColors
                                                          .darkCardBackgroundColor
                                                      : AppColors.white,
                                                  hintColor: !theme.isDark
                                                      ? AppColors
                                                          .darkCardBackgroundColor
                                                      : AppColors.grey,
                                                  validator: AppValidator
                                                      .validateTextfield,
                                                  icon: Icons.person_2_outlined,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                CustomTextFormField(
                                                  label: 'Password',
                                                  isPasswordField: true,
                                                  borderColor: Colors.black54,
                                                  backgroundColor: theme.isDark
                                                      ? AppColors
                                                          .darkCardBackgroundColor
                                                      : AppColors.white,
                                                  hintColor: !theme.isDark
                                                      ? AppColors
                                                          .darkCardBackgroundColor
                                                      : AppColors.grey,
                                                  validator: AppValidator
                                                      .validateTextfield,
                                                  controller:
                                                      _passwordController,
                                                  hint: 'Enter your password',
                                                  icon: Icons.lock_outline,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        // if (_formKey.currentState!.validate()) {
                                                        //   authBloc.add(SignInEventClick(
                                                        //       _userNameController.text,
                                                        //       _passwordController.text));
                                                        // }

                                                        AppNavigator
                                                            .pushAndStackPage(
                                                                context,
                                                                page:
                                                                    const PasswordResetRequest());
                                                      },
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: CustomText(
                                                          text:
                                                              "Forgot password ?",
                                                          color: !theme.isDark
                                                              ? AppColors.blue
                                                              : AppColors.white,
                                                          size: 16,
                                                          weight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                FormButton(
                                                  onPressed: () async {
                                                    // AppNavigator
                                                    //     .pushAndRemovePreviousPages(
                                                    //         context,
                                                    //         page: LandingPage(
                                                    //           selectedIndex: 0,
                                                    //         ));
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      authBloc.add(
                                                          SignInEventClick(
                                                              //'Bisect','Qwerty123@'
                                                              _userNameController
                                                                  .text,
                                                              _passwordController
                                                                  .text,selectedUser));
                                                    }
                                                  },
                                                  text: 'Login',
                                                  borderColor:
                                                      AppColors.mainAppColor,
                                                  bgColor:
                                                      AppColors.mainAppColor,
                                                  textColor: AppColors.white,
                                                  borderRadius: 10,
                                                  height: 50,
                                                )
                                              ],
                                            )),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CustomText(
                                        text: "Don't have an account yet? ",
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          AppNavigator.pushAndStackPage(context,
                                              page: const SignUpPage());
                                        },
                                        child: const CustomText(
                                          text: "Create Account",
                                          color: AppColors.blue,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      children: [
                                        CustomText(
                                            text: 'Powered by',
                                            size: 14,
                                            color: theme.isDark
                                                ? AppColors.white
                                                : AppColors.black),
                                        Image.asset(
                                          AppImages.companyLogo,
                                          height: 40,
                                          width: 150,
                                          //color: AppColors.darkModeBlack,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );

                        case LoadingState:
                          return const Center(
                            child: AppLoadingPage("Signing user in..."),
                          );
                        default:
                          return const Center(
                            child: AppLoadingPage("Signing user in..."),
                          );
                      }
                    }),
              )
            : UpdateApp(
                appUrl: appUrl,
              ))
        : No_internet_Page(onRetry: _checkConnectivity);
  }
}
