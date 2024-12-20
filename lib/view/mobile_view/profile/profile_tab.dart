import 'package:flutter/material.dart';
import 'package:pim/view/mobile_view/auth/sign_in_page.dart';
import 'package:pim/view/mobile_view/profile/profile_page.dart';

import '../../../model/user_model.dart';
import '../../../res/app_colors.dart';
import '../../../utills/app_navigator.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';

class ProfileTab extends StatefulWidget {
  final UserModel userModel;

   ProfileTab({super.key, required this.userModel});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Personalization'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Settings options list
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  InkWell(
                      onTap: () {
                        AppNavigator.pushAndStackPage(context,
                            page:  ProfilePage(userModel: widget.userModel,));
                      },
                      child: _buildSettingsOption('Profile')),
                  _buildSettingsOption('Settings'),
                  _buildSettingsOption('Contact Us'),
                  _buildSettingsOption('About PMP'),
                  _buildSettingsOption('Support'),
                ],
              ),
            ),

            const SizedBox(height: 30),

            FormButton(
              onPressed: () {
                AppNavigator.pushAndRemovePreviousPages(context, page: const SignInPage());
              },
              text: "Logout",
              bgColor: AppColors.mainAppColor.withOpacity(0.9),
              textColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: CustomText(
          text: title,
          size: 18,
          weight: FontWeight.bold,
        ),
      ),
    );
  }
}
