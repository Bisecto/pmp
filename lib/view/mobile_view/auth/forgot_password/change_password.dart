import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pim/bloc/auth_bloc/auth_bloc.dart';
import 'package:pim/view/mobile_view/auth/forgot_password/congratulation_page.dart';

import '../../../../res/app_colors.dart';
import '../../../../res/app_images.dart';
import '../../../../utills/app_navigator.dart';
import '../../../../utills/app_validator.dart';
import '../../../../utills/custom_theme.dart';
import '../../../important_pages/dialog_box.dart';
import '../../../important_pages/not_found_page.dart';
import '../../../widgets/app_custom_text.dart';
import '../../../widgets/form_button.dart';
import '../../../widgets/form_input.dart';
import '../sign_in_page.dart';

class ChangePassword extends StatefulWidget {
  String email;
  String token;

  ChangePassword({super.key, required this.email,required this.token});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    authBloc.add(InitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
            bloc: authBloc,
            listenWhen: (previous, current) => current is! AuthInitial,
            buildWhen: (previous, current) => current is! AuthInitial,
            listener: (context, state) {
              if (state is ResetPasswordSuccessState) {
                MSG.snackBar(context, state.msg);
                AppNavigator.pushAndReplacePage(context, page: Congrats());
                //AppNavigator.pushAndReplacePage(context, page: VerifyOtp());
              } else if (state is AccessTokenExpireState) {
                AppNavigator.pushAndRemovePreviousPages(context,
                    page: SignInPage());
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
                case AuthInitial || ErrorState:
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
                              text: "Reset your password",
                              weight: FontWeight.bold,
                              color: theme.isDark
                                  ? AppColors.white
                                  : AppColors.darkCardBackgroundColor,
                              size: 20,
                            ),
                            CustomText(
                              text:
                                  "You can now proceed to create a new password",
                              weight: FontWeight.w400,
                              color: theme.isDark
                                  ? AppColors.white
                                  : AppColors.darkCardBackgroundColor,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              size: 14,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Image.asset(
                              AppImages.passwordRecovery,
                              height: 150,
                              width: 150,
                            ),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    CustomTextFormField(
                                      label: 'New Password',
                                      isPasswordField: true,
                                      borderColor: AppColors.mainAppColor,
                                      backgroundColor: theme.isDark
                                          ? AppColors.darkCardBackgroundColor
                                          : AppColors.white,
                                      hintColor: !theme.isDark
                                          ? AppColors.darkCardBackgroundColor
                                          : AppColors.grey,
                                      validator: AppValidator.validatePassword,
                                      controller: _passwordController,
                                      hint: 'Enter new password',
                                      icon: Icons.lock_outline,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFormField(
                                      label: 'Confirm New Password',
                                      isPasswordField: true,
                                      borderColor: AppColors.mainAppColor,
                                      backgroundColor: theme.isDark
                                          ? AppColors.darkCardBackgroundColor
                                          : AppColors.white,
                                      hintColor: !theme.isDark
                                          ? AppColors.darkCardBackgroundColor
                                          : AppColors.grey,
                                      validator: (val) => val! !=
                                              _passwordController.text
                                          ? "Confirm password does not match"
                                          : null,
                                      controller: _confirmPasswordController,
                                      hint: 'Confirm password',
                                      icon: Icons.lock_outline,
                                    ),
                                    FormButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          authBloc.add(ResetPasswordEventClick(
                                              widget.email,
                                              _passwordController.text,
                                              _confirmPasswordController.text,widget.token));
                                          // // String? notificationToken =
                                          // //     await FirebaseMessaging.instance.getToken();
                                          //
                                          // authBloc.add(SignInUserEvent(
                                          //   _emailController.value.text,
                                          //   _passwordController.value.text,
                                          // ));
                                        }
                                      },
                                      text: 'Reset Password',
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
                          ],
                        ),
                      ),
                    ),
                  );

                case LoadingState:
                  return Center(child: AppLoadingPage("Changing password..."));
                default:
                  return Center(
                    child: AppLoadingPage("Changing password..."),
                  );
              }
            }));
  }
}
