import 'dart:async';
import 'dart:io';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pim/view/mobile_view/auth/sign_up_screen.dart';
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
import 'forgot_password/password_reset_request.dart';

class SetUpProfile extends StatefulWidget {
  const SetUpProfile({super.key});

  @override
  State<SetUpProfile> createState() => _SetUpProfileState();
}

class _SetUpProfileState extends State<SetUpProfile> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final _phoneNumberController = TextEditingController();
  final AuthBloc authBloc = AuthBloc();
  AuthRepository authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    authBloc.add(InitialEvent());
  }

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectSingleImage() async {
    final XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      imageFileList = [
        selectedImage
      ]; // Replace the list with the newly selected image
      print("Selected Image Path: ${selectedImage.path}");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Provider.of<CustomThemeState>(context);
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
    //if (isAppUpdated) {

    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
          bloc: authBloc,
          listenWhen: (previous, current) => current is! AuthInitial,
          buildWhen: (previous, current) => current is! AuthInitial,
          listener: (context, state) {
            if (state is SuccessState) {
              MSG.snackBar(context, state.msg);

              AppNavigator.pushAndRemovePreviousPages(context,

                  page: LandingPage(
                    selectedIndex: 0, userModel: state.userModel!,
                  ));
            } else if (state is ErrorState) {
              MSG.warningSnackBar(context, state.error);
            } else if (state is ProfileSetUpState) {}
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                text: "Create Profile",
                                weight: FontWeight.bold,
                                color: theme.isDark
                                    ? AppColors.white
                                    : AppColors.darkCardBackgroundColor,
                                size: 25,
                              ),
                              CustomText(
                                text:
                                    "Please create an account  to manage your property",
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
                              // GestureDetector(
                              //   onTap: selectSingleImage,
                              //   child: Container(
                              //     height: 250,
                              //     decoration: BoxDecoration(
                              //       color: Colors.grey.withOpacity(0.2),
                              //       borderRadius: BorderRadius.circular(10),
                              //     ),
                              //     child: Column(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         const Icon(Icons.save_alt_rounded),
                              //         const SizedBox(height: 10),
                              //         Center(
                              //           child: TextStyles.richTexts(
                              //             text1: 'Click to upload',
                              //             text2: ' or drag and drop',
                              //             color: Colors.purple,
                              //             color2: AppColors.black,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(height: 16),
                              // Add spacing
                              //if (imageFileList!.isNotEmpty)
                              GestureDetector(
                                onTap: selectSingleImage,

                                child: CircleAvatar(
                                  backgroundColor: AppColors.mainAppColor,
                                  radius: 50,
                                  backgroundImage: imageFileList!.isNotEmpty
                                      ? FileImage(File(imageFileList![0].path))
                                      : const AssetImage(AppImages.addProfile),
                                ),
                              ),
                              // SizedBox(
                              //   height: 250, // Fixed height for image display
                              //   child: imageFileList?.isEmpty ?? true
                              //       ? const Center(child: Text("No Image Selected"))
                              //       : Image.file(
                              //     File(imageFileList![0].path),
                              //     fit: BoxFit.cover,
                              //   ),
                              // ),
                              const SizedBox(height: 16),
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      CustomTextFormField(
                                        hint: 'Enter your First name',
                                        label: 'First Name',
                                        borderColor: Colors.black54,
                                        controller: _firstNameController,
                                        backgroundColor: theme.isDark
                                            ? AppColors.darkCardBackgroundColor
                                            : AppColors.white,
                                        hintColor: !theme.isDark
                                            ? AppColors.darkCardBackgroundColor
                                            : AppColors.grey,
                                        validator:
                                            AppValidator.validateTextfield,
                                        icon: Icons.person_2_outlined,
                                      ),
                                      CustomTextFormField(
                                        hint: 'Enter your Last name',
                                        label: 'Last Name',
                                        borderColor: Colors.black54,
                                        controller: _lastNameController,
                                        backgroundColor: theme.isDark
                                            ? AppColors.darkCardBackgroundColor
                                            : AppColors.white,
                                        hintColor: !theme.isDark
                                            ? AppColors.darkCardBackgroundColor
                                            : AppColors.grey,
                                        validator:
                                            AppValidator.validateTextfield,
                                        icon: Icons.person_2_outlined,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(
                                        hint: 'Enter your Phone number',
                                        label: 'Phone Number',
                                        borderColor: Colors.black54,
                                        controller: _phoneNumberController,
                                        backgroundColor: theme.isDark
                                            ? AppColors.darkCardBackgroundColor
                                            : AppColors.white,
                                        hintColor: !theme.isDark
                                            ? AppColors.darkCardBackgroundColor
                                            : AppColors.grey,
                                        validator:
                                            AppValidator.validateTextfield,
                                        icon: Icons.person_2_outlined,
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
                                              //       _emailController.text,
                                              //       _passwordController.text));
                                              // }

                                              AppNavigator.pushAndStackPage(
                                                  context,
                                                  page:
                                                      const PasswordResetRequest());
                                            },
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: CustomText(
                                                text: "Forgot password ?",
                                                color: !theme.isDark
                                                    ? AppColors.blue
                                                    : AppColors.white,
                                                size: 16,
                                                weight: FontWeight.w600,
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
                                            if(imageFileList!.isNotEmpty){
                                              authBloc.add(SetUpProfileEventClick(
                                                  _firstNameController.text
                                                      .toLowerCase()
                                                      .trim(),
                                                  _lastNameController.text,
                                                  _phoneNumberController.text,
                                                  imageFileList![0]));
                                            }else{
                                              MSG.infoSnackBar(context, 'Please select a profile image');
                                            }

                                          }
                                        },
                                        text: 'Complete',
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     CustomText(
                        //       text: "Don't have an account yet? ",
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {
                        //         AppNavigator.pushAndStackPage(context,
                        //             page: const SignUpPage());
                        //       },
                        //       child: CustomText(
                        //         text: "Create Account",
                        //         color: AppColors.blue,
                        //       ),
                        //     )
                        //   ],
                        // ),
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
    );
  }
}
