import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:pim/utills/app_navigator.dart';
import 'package:pim/view/mobile_view/auth/sign_in_page.dart';
import 'package:pim/view/mobile_view/landing_page.dart';

import '../../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_images.dart';
import '../../../../utills/custom_theme.dart';

import '../../important_pages/dialog_box.dart';
import '../../important_pages/not_found_page.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';
import 'existin_signin.dart';


class VerifyStudent extends StatefulWidget {
  String email;
  String password;

  VerifyStudent({super.key, required this.email,required this.password});

  @override
  State<VerifyStudent> createState() => _VerifyStudentState();
}

class _VerifyStudentState extends State<VerifyStudent> {
  OtpFieldController otpFieldController = OtpFieldController();
  final AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    authBloc.add(InitialEvent());
    startTimer();
    super.initState();
  }

  bool isOtpInputted = false;
  String otp = '';
  bool isCompleted = false;
  String addedPin = '';

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
            bloc: authBloc,
            listenWhen: (previous, current) => current is! AuthInitial,
            buildWhen: (previous, current) => current is! AuthInitial,
            listener: (context, state) {
              if (state is OtpRequestSuccessState) {
                MSG.snackBar(context, state.msg);
                setState(() {
                  isCompleted = false;
                });
                //AppNavigator.pushAndReplacePage(context, page: VerifyOtp());
              } else if (state is SuccessState) {
                MSG.snackBar(context, state.msg);
                AppNavigator.pushAndRemovePreviousPages(context,
                    page: LandingPage(
                       selectedIndex: 0,
                    ));
              } else if (state is ErrorState) {
                setState(() {
                  isCompleted = false;
                });
                MSG.warningSnackBar(context, state.error);
              }
            },
            builder: (context, state) {
              switch (state.runtimeType) {
              // case PostsFetchingState:
              //   return const Center(
              //     child: CircularProgressIndicator(),
              //   );
                case (AuthInitial || ErrorState) || OtpRequestSuccessState:
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
                              text: "Please check your Email",
                              weight: FontWeight.bold,
                              color: theme.isDark
                                  ? AppColors.white
                                  : AppColors.darkCardBackgroundColor,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              size: 20,
                            ),
                            CustomText(
                              text:
                              "We sent an otp to your school mail please enter the pin to verify device login",
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
                            Image.asset(
                              AppImages.passwordRecovery,
                              height: 150,
                              width: 150,
                            ),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            OTPTextField(
                              length: 6,
                              //keyboardType: TextInputType.text,
                              width: MediaQuery.of(context).size.width,
                              fieldWidth: 50,
                              controller: otpFieldController,
                              style:  TextStyle(fontSize: 17,color: theme.isDark
                                  ? AppColors.white
                                  : AppColors.darkCardBackgroundColor,
                              ),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.box,
                              otpFieldStyle: OtpFieldStyle(
                                backgroundColor: !theme.isDark
                                    ? AppColors.white
                                    : AppColors.darkCardBackgroundColor,
                                focusBorderColor: AppColors.mainAppColor,
                                borderColor: AppColors.mainAppColor,
                              ),
                              onCompleted: (pin) async {
                                //authBloc.add(VerifyOTPEventCLick(addedPin));
                                setState(() {
                                  isCompleted = true;
                                  addedPin = pin;
                                });
                              },
                            ),

                            // DividerWithTextWidget(text: "or login with"),
                            const SizedBox(
                              height: 10,
                            ),
                            FormButton(
                              onPressed: () {
                                if (isCompleted) {
                                  authBloc.add(OnVerifyDeviceEvent(
                                      addedPin, widget.email.toLowerCase(),widget.password));
                                } else {
                                  MSG.warningSnackBar(
                                      context, "OTP field not complete");
                                }
                              },
                              text: 'Continue',
                              borderColor: AppColors.mainAppColor,
                              bgColor: AppColors.mainAppColor,
                              textColor: AppColors.white,
                              borderRadius: 10,
                              disableButton: !isCompleted,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            const SizedBox(
                              height: 30,
                            ),
                            TextStyles.richTexts(
                                onPress1: () {
                                  if (_start == 0) {
                                    authBloc.add(RequestResetPasswordEventClick(
                                        widget.email,true));

                                    setState(() {
                                      _start = 59;
                                      startTimer();
                                    });
                                  } else {
                                    MSG.warningSnackBar(
                                        context, 'Resend Code after 59s');
                                  }
                                },
                                onPress2: () {},
                                size: 14,
                                weight: FontWeight.w600,
                                //color: const Color.fromARGB(255, 19, 48, 63),
                                color2: AppColors.mainAppColor,
                                //text1: '',
                                decoration: TextDecoration.underline,
                                text2: 'Resend code after',
                                color: theme.isDark
                                    ? AppColors.white
                                    : AppColors.darkCardBackgroundColor,

                                text3: '  00:$_start s',
                                text4: '')
                          ],
                        ),
                      ),
                    ),
                  );

                case LoadingState:
                  return const Center(
                    child: AppLoadingPage("Verifying OTP..."),
                  );
                default:
                  return const Center(
                    child: AppLoadingPage("Verifying OTP..."),
                  );
              }
            }));
  }

  String smsOTP = '';
  late Timer _timer;
  int _start = 59;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          //_start = 59;
          _timer.cancel();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
