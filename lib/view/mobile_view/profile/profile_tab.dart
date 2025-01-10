import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pim/utills/app_utils.dart';
import 'package:pim/view/mobile_view/auth/sign_in_page.dart';
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
import 'package:http/http.dart' as http;

class ProfileTab extends StatefulWidget {
  final UserModel userModel;

  ProfileTab({super.key, required this.userModel});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
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
      print(url);
      print(response.statusCode);
      print(response.body);
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
                            page: ProfilePage(
                              userModel: widget.userModel,
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
                    onTap: (){
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
              width: AppUtils.deviceScreenSize(context).width/2,
            ),
            FormButton(
              onPressed: () async {
                String accessToken =
                    await SharedPref.getString('access-token');
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
              width: AppUtils.deviceScreenSize(context).width/2,

            ),
          ],
        ),
      ),
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
}
