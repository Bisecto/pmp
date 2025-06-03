import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pim/model/current_plan_model.dart';
import 'package:pim/utills/app_utils.dart';
import 'package:pim/view/mobile_view/auth/sign_in_page.dart';
import 'package:pim/view/mobile_view/profile/plan/plan_listing.dart';
import 'package:pim/view/mobile_view/profile/profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/user_model.dart';
import '../../../res/apis.dart';
import '../../../res/app_colors.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/shared_preferences.dart';
import '../../important_pages/dialog_box.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';
import 'contact_us_page.dart';

class ProfileTab extends StatefulWidget {
  final UserModel userModel;
  final CurrentPlan? currentPlan;

  ProfileTab({super.key, required this.userModel, required this.currentPlan});

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
            if(widget.userModel.occupiedSpaces.isEmpty)
            currentPlan(),
            const SizedBox(
              height: 20,
            ),
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
                            page: ProfilePage(
                              userModel: widget.userModel,
                              currentPlan: widget.currentPlan?? CurrentPlan(hasActiveSubscription: false, plan: null, subscription: null, usage: null, daysRemaining: 0, expiresAt: null),
                            ));
                      },
                      child: _buildSettingsOption('Profile')),
                  //_buildSettingsOption('Settings'),
                  InkWell(
                      onTap: () {
                        AppNavigator.pushAndStackPage(context,
                            page: ContactUsPage());
                      },
                      child: _buildSettingsOption('Contact Us')),
                  InkWell(
                      onTap: () {
                        _launchUrl('https://property.appleadng.net/about/');
                      },
                      child: _buildSettingsOption('About PMP')),
                  //_buildSettingsOption('Support'),
                ],
              ),
            ),

            const SizedBox(height: 30),

            FormButton(
              onPressed: () {
                AppNavigator.pushAndRemovePreviousPages(context,
                    page: const SignInPage());
              },
              text: "Logout",
              bgColor: AppColors.blue.withOpacity(0.9),
              textColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      bool launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        // Handle the case where the URL couldn't be launched
        // You might want to display an error message to the user
        print('Could not launch $uri');
        // Or try opening in a browser:
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        } else {
          print('Could not launch $uri in a browser either');
        }
      }
    } catch (e) {
      // Handle any potential errors during launch
      print('Error launching URL: $e');
    }
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

  Widget currentPlan() {
    return GestureDetector(
      onTap: () {
        AppNavigator.pushAndStackPage(context,
            page: PlanListing(
              currentPlan: widget.currentPlan!,
              userModel: widget.userModel,
            ));
      },
      child: Container(
        height: 80,
        width: AppUtils.deviceScreenSize(context).width,
        decoration: BoxDecoration(
            color: AppColors.mainAppColor,
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextStyles.textHeadings(
                      textValue: "PMP ${widget.currentPlan!.plan!.displayName}",
                      textColor: AppColors.white),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomText(
                      text: "${widget.currentPlan!.plan!.description}",
                      size: 13,
                      color: AppColors.white)
                ],
              ),
              const Icon(
                Icons.next_plan,
                color: AppColors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
