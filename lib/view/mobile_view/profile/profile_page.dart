import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pim/utills/app_navigator.dart';
import 'package:pim/view/mobile_view/profile/update_profile.dart';
import 'package:pim/view/widgets/app_bar.dart';

import '../../../model/current_plan_model.dart';
import '../../../model/user_model.dart';
import '../../../res/apis.dart';
import '../../../res/app_colors.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/shared_preferences.dart';
import '../../important_pages/dialog_box.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final UserModel userModel;
  final CurrentPlan currentPlan;

  const ProfilePage({super.key, required this.userModel, required this.currentPlan});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> deleteProfile({
    required String accessToken,
    required String apiUrl,
    required VoidCallback onSuccess,
    required Function(String error) onError,
  }) async {
    final String url = apiUrl;

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        onSuccess(); // Notify that the delete is complete
      } else {
        final errorDetail =
            json.decode(response.body)['detail'] ?? 'Unknown error';
        onError(errorDetail); // Notify about the error
      }
    } catch (e) {
      onError('An error occurred while deleting the occupant: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const AppAppBar(title: 'Profile'),
            profileContainer(widget.userModel, context: context),
            if(widget.userModel.profilePic.isNotEmpty)
            FormButton(
              onPressed: () {
                AppNavigator.pushAndStackPage(context,
                    page: UpdateProfile(userModel: widget.userModel, currentPlan: widget.currentPlan,));
              },
              text: "Edit Profile",
              bgColor: AppColors.green.withOpacity(0.9),
              textColor: AppColors.white,
            ),
            const SizedBox(height: 30),
            if(widget.userModel.profilePic.isNotEmpty)
            FormButton(
              onPressed: () async {
                String accessToken = await SharedPref.getString('access-token');
                showDeleteConfirmationModal(context, () {
                  deleteProfile(
                    accessToken: accessToken,
                    apiUrl: AppApis.deleteProfile,
                    onSuccess: () {
                      MSG.snackBar(context, 'Occupant deleted successfully!');

                      Navigator.pop(context, true);
                    },
                    onError: (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $error')),
                      );
                    },
                  );
                });
              },
              text: "Delete Account",
              bgColor: AppColors.red,
              textColor: AppColors.white,
              width: AppUtils.deviceScreenSize(context).width / 2,
            ),
          ],
        ),
      )),
    );
  }

  void showDeleteConfirmationModal(
      BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Profile'),
          content: const Text(
              'Are you sure you want to delete your profile? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the modal
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the modal
                onConfirm(); // Trigger the confirm action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const CustomText(
                text: 'Delete',
                color: AppColors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget profileContainer(UserModel user, {required context}) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 380,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 250,
                width: AppUtils.deviceScreenSize(context).width,
                decoration: BoxDecoration(
                  //color: AppColors.red,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.15),
                  //     spreadRadius: 0,
                  //     blurRadius: 10,
                  //     offset: const Offset(0, 4),
                  //   ),
                  // ],
                  image: DecorationImage(
                      image: NetworkImage(widget.userModel.profilePic.isNotEmpty
                              ? widget.userModel.profilePic
                              : widget.userModel.occupiedSpaces[0]
                                  .profilePic //user.profilePic,
                          ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CustomText(
                        text: "Username:",
                        color: AppColors.black,
                        size: 13,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: ' ${user.username}  ',
                        size: 13,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CustomText(
                        text: "Full Name:",
                        color: AppColors.black,
                        size: 13,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: ' ${user.firstName} ${user.lastName}  ',
                        size: 13,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CustomText(
                        text: "Email:",
                        color: AppColors.black,
                        size: 13,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: ' ${user.email}  ',
                        size: 13,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const CustomText(
                    text: "Mobile number:",
                    color: AppColors.black,
                    size: 13,
                    weight: FontWeight.bold,
                  ),
                  CustomText(
                    text: '  ${user.mobilePhone}',
                    size: 13,
                    maxLines: 3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
