import 'package:flutter/material.dart';
import 'package:pim/utills/app_navigator.dart';
import 'package:pim/view/mobile_view/profile/update_profile.dart';
import 'package:pim/view/widgets/app_bar.dart';

import '../../../model/user_model.dart';
import '../../../res/app_colors.dart';
import '../../../utills/app_utils.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userModel;

  const ProfilePage({super.key, required this.userModel});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            FormButton(
              onPressed: () {
                AppNavigator.pushAndStackPage(context,
                    page: UpdateProfile(userModel: widget.userModel));
              },
              text: "Edit Profile",
              bgColor: AppColors.mainAppColor.withOpacity(0.9),
              textColor: AppColors.white,
            ),
          ],
        ),
      )),
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
                      image: NetworkImage(
                        user.profilePic,
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
