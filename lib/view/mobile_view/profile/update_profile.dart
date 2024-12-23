import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pim/model/user_model.dart';
import 'package:pim/view/widgets/loading_animation.dart';
import 'package:provider/provider.dart';
import 'package:pim/repository/auth_repository.dart';
import 'package:pim/view/mobile_view/landing_page.dart';

import '../../../bloc/auth_bloc/auth_bloc.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_validator.dart';
import '../../../utills/custom_theme.dart';
import '../../important_pages/dialog_box.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';
import '../../widgets/form_input.dart';

class UpdateProfile extends StatefulWidget {
  final UserModel userModel;

  const UpdateProfile({super.key, required this.userModel});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final _phoneNumberController = TextEditingController();
  final AuthBloc authBloc = AuthBloc();
  AuthRepository authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    download();
    _userNameController.text = widget.userModel.username;
    _emailController.text = widget.userModel.email;
    _firstNameController.text = widget.userModel.firstName;
    _phoneNumberController.text = widget.userModel.mobilePhone;
    _lastNameController.text = widget.userModel.lastName;

    authBloc.add(InitialEvent());
  }

  download() async {
    try {
      File imageFile = await downloadImage(widget.userModel!.profilePic);
      setState(() {
        imageFileList!.add(XFile(imageFile.path));
      });
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  Future<File> downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/${imageUrl.split('/').last}';
      final file = File(filePath);
      return file.writeAsBytes(response.bodyBytes);
    } else {
      throw Exception('Failed to download image');
    }
  }

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectSingleImage() async {
    final XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      if (selectedImage.path.toLowerCase().contains('.jpg') ||
          selectedImage.path.toLowerCase().contains('.png')) {
        imageFileList = [
          selectedImage
        ]; // Replace the list with the newly selected image
        print("Selected Image Path: ${selectedImage.name}");
      } else {
        MSG.warningSnackBar(context, 'Selected image not supported');
      }

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
      appBar: AppBar(
        backgroundColor: AppColors.mainAppColor,
        title: CustomText(
          text: "Update Profile",
          weight: FontWeight.bold,
          color: !theme.isDark
              ? AppColors.white
              : AppColors.darkCardBackgroundColor,
          size: 16,
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
          bloc: authBloc,
          listenWhen: (previous, current) => current is! AuthInitial,
          buildWhen: (previous, current) => current is! AuthInitial,
          listener: (context, state) {
            if (state is SuccessState) {
              MSG.snackBar(context, state.msg);

              AppNavigator.pushAndRemovePreviousPages(context,
                  page: LandingPage(
                    selectedIndex: 0,
                    userModel: state.userModel!,
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
                                height: 10,
                              ),

                              // CustomText(
                              //   text:
                              //       "Please create an account  to manage your property",
                              //   weight: FontWeight.w400,
                              //   color: theme.isDark
                              //       ? AppColors.white
                              //       : Colors.black54,
                              //   size: 16,
                              // ),
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
                                      // CustomTextFormField(
                                      //   hint: 'Enter your email',
                                      //   label: 'Email',
                                      //   //readOnly: true,
                                      //   borderColor: Colors.black54,
                                      //   controller: _emailController,
                                      //   backgroundColor: theme.isDark
                                      //       ? AppColors.darkCardBackgroundColor
                                      //       : AppColors.white,
                                      //   hintColor: !theme.isDark
                                      //       ? AppColors.darkCardBackgroundColor
                                      //       : AppColors.grey,
                                      //   validator:
                                      //       AppValidator.validateTextfield,
                                      //   icon: Icons.person_2_outlined,
                                      // ),
                                      const SizedBox(
                                        height: 10,
                                      ),
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
                                      const SizedBox(
                                        height: 10,
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
                                            if (imageFileList!.isNotEmpty) {
                                              authBloc.add(
                                                  UpdateProfileEventClick(
                                                      _firstNameController.text
                                                          .toLowerCase()
                                                          .trim(),
                                                      _lastNameController.text,
                                                      _phoneNumberController
                                                          .text,
                                                      imageFileList![0],
                                                      _userNameController.text,
                                                      _emailController.text));
                                            } else {
                                              MSG.infoSnackBar(context,
                                                  'Please select a profile image');
                                            }
                                          }
                                        },
                                        text: 'Update',
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
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                );

              case LoadingState:
                return const LoadingDialog('');

              default:
                return const LoadingDialog('');
            }
          }),
    );
  }
}
