import 'package:flutter/material.dart';

import '../../../res/app_colors.dart';
import '../../../utills/app_navigator.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
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
                        // AppNavigator.pushAndStackPage(context,
                        //     page: ProfilePage());
                      },
                      child: _buildSettingsOption('Change Password')),
                  _buildSettingsOption('Notification'),

                ],
              ),
            ),

            const SizedBox(height: 30),

            FormButton(
              onPressed: () {},
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
