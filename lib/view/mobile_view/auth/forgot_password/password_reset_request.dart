import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pim/utills/app_navigator.dart';
import 'package:pim/view/mobile_view/auth/forgot_password/verify_otp.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_images.dart';
import '../../../../res/app_router.dart';
import '../../../../utills/app_validator.dart';
import '../../../../utills/custom_theme.dart';
import '../../../important_pages/dialog_box.dart';
import '../../../important_pages/not_found_page.dart';
import '../../../widgets/app_custom_text.dart';
import '../../../widgets/form_button.dart';
import '../../../widgets/form_input.dart';
import '../sign_in_page.dart';

class PasswordResetRequest extends StatefulWidget {
  const PasswordResetRequest({super.key});

  @override
  State<PasswordResetRequest> createState() => _PasswordResetRequestState();
}

class _PasswordResetRequestState extends State<PasswordResetRequest> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    // TODO: implement initState
    authBloc.add(InitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Provider.of<CustomThemeState>(context);
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
          bloc: authBloc,
          listenWhen: (previous, current) => current is! AuthInitial,
          buildWhen: (previous, current) => current is! AuthInitial,
          listener: (context, state) {
            if (state is OtpRequestSuccessState) {
              MSG.snackBar(context, state.msg);
              AppNavigator.pushAndReplacePage(context,
                  page: VerifyOtp(
                    email: _emailController.text,
                    isNewAccount: false, userName: _emailController.text,
                  ));
            } else if (state is AccessTokenExpireState) {
              AppNavigator.pushAndRemovePreviousPages(context,
                  page: const SignInPage());
            } else if (state is ErrorState) {
              MSG.warningSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              // case PostsFetchingState:
              //   return const Center(
              //     child: CircularProgressIndicator(),
              //   );
              case const (AuthInitial) || const (ErrorState):
                return SafeArea(
                    child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        CustomText(
                          text: "Reset Password",
                          weight: FontWeight.bold,
                          color: theme.isDark
                              ? AppColors.white
                              : AppColors.darkCardBackgroundColor,
                          size: 25,
                        ),
                        CustomText(
                          text:
                              "Forgotten your password? Enter your email address below, and we'll email you a code for setting a new one.",
                          weight: FontWeight.w400,
                          color: theme.isDark
                              ? AppColors.grey
                              : AppColors.darkCardBackgroundColor,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          size: 14,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  hint: 'Please enter your email address',
                                  label: 'Email Address',
                                  borderColor: Colors.black54,
                                  controller: _emailController,
                                  backgroundColor: theme.isDark
                                      ? AppColors.darkCardBackgroundColor
                                      : AppColors.white,
                                  hintColor: !theme.isDark
                                      ? AppColors.darkCardBackgroundColor
                                      : AppColors.grey,
                                  validator: AppValidator.validateEmail,
                                  icon: Icons.person_2_outlined,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                FormButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      // AppNavigator.pushAndReplacePage(context,
                                      //     page: VerifyOtp(
                                      //       email: _emailController.text,
                                      //     ));

                                      authBloc.add(
                                          RequestResetPasswordEventClick(
                                              _emailController.text
                                                  .toLowerCase()
                                                  .trim(),
                                              false));
                                    }
                                  },
                                  text: 'Continue',
                                  borderColor: AppColors.mainAppColor,
                                  bgColor: AppColors.mainAppColor,
                                  textColor: AppColors.white,
                                  borderRadius: 10,
                                  height: 50,
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            AppNavigator.pushAndReplaceName(context,
                                name: AppRouter.signInPage);

                            // Navigator.pop(context);
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: TextStyles.richTexts(
                              text1: "Login ",
                              weight: FontWeight.w400,
                              text2: "Instead",
                              color: AppColors.blue,
                              color2: theme.isDark
                                  ? AppColors.grey
                                  : AppColors.darkCardBackgroundColor,
                              // onPress1: () {
                              //   //Navigator.pop(context);
                              // }
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));

              case const (LoadingState):
                return const Center(
                  child: AppLoadingPage("Requesting OTP..."),
                );
              default:
                return const Center(
                  child: AppLoadingPage("Requesting OTP..."),
                );
            }
          }),
    );
  }
}
