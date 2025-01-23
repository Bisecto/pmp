import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pim/res/app_images.dart';
import 'package:pim/view/widgets/app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utills/app_utils.dart';
import '../../widgets/app_custom_text.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppAppBar(
              title: 'Contact Us',
            ),
            // const Center(
            //   child: CircleAvatar(
            //     radius: 50,
            //     backgroundImage:
            //         AssetImage(AppImages.logo), // Replace with your logo
            //   ),
            // ),
            const SizedBox(height: 20),
            // const Center(
            //   child: CustomText(
            //     text: 'Get in Touch',
            //     textAlign: TextAlign.center,
            //     size: 24,
            //     weight: FontWeight.bold,
            //   ),
            // ),
            const SizedBox(height: 10),
            const CustomText(
              text:
                  'We are here to assist you. Feel free to reach out to us via any of the platforms below:',
              maxLines: 3,
              textAlign: TextAlign.center,
              size: 16,
            ),
            const SizedBox(height: 20),

            ContactInfoRow(
              icon: Icons.phone,
              text: '+234 705 602 0452',
              onTap: () => _launchPhone('+2347056020452'),
            ),
            ContactInfoRow(
              icon: FontAwesomeIcons.whatsapp,
              text: '+234 705 602 0452',
              onTap: () => _launchWhatsApp('+2347056020452'),
            ),
            ContactInfoRow(
              icon: FontAwesomeIcons.globe,
              text: 'https://property.appleadng.net',
              onTap: () =>
                  _launchWhatsApp('https://property.appleadng.net/contact/'),
            ),
            ContactInfoRow(
              icon: FontAwesomeIcons.instagram,
              text: '@appleadproperty',
              onTap: () => _launchUrl('https://instagram.com/appleadproperty'),
            ),
            ContactInfoRow(
              icon: FontAwesomeIcons.twitter,
              text: '@appleadproperty',
              onTap: () => _launchUrl('https://twitter.com/appleadproperty'),
            ),
            ContactInfoRow(
              icon: Icons.email,
              text: 'property@appleadng.net',
              onTap: () => _launchUrl('mailto:property@appleadng.net'),
            ),
          ],
        ),
      ),
    );
  }

  void _launchPhone(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppUtils().debuglog('Could not launch $uri');
    }
  }

  void _launchWhatsApp(String phoneNumber) async {
    final Uri uri = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppUtils().debuglog('Could not launch $uri');
    }
  }

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      bool launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        // Handle the case where the URL couldn't be launched
        // You might want to display an error message to the user
        AppUtils().debuglog('Could not launch $uri');
        // Or try opening in a browser:
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        } else {
          AppUtils().debuglog('Could not launch $uri in a browser either');
        }
      }
    } catch (e) {
      // Handle any potential errors during launch
      AppUtils().debuglog('Error launching URL: $e');
    }
  }
}

class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ContactInfoRow({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, size: 25, color: Colors.blueAccent),
            const SizedBox(width: 16),
            Expanded(
              child: CustomText(
                text: text,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
