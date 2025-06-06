import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:url_launcher/url_launcher.dart';

import '../../res/app_colors.dart';
import '../../res/app_images.dart';

class UpdateApp extends StatefulWidget {
  String appUrl;

  UpdateApp({Key? key, required this.appUrl}) : super(key: key);

  @override
  State<UpdateApp> createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.logo,
                height: 200,
                width: 200,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Time To Update',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: AppColors.mainAppColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'We added lots of new features and fixed some bugs to make your experience as smooth as possible',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: AppColors.black),
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () async {
                  if (Platform.isAndroid) {
                    if (await canLaunchUrl(Uri.parse(widget.appUrl))) {
                      await launchUrl(Uri.parse(widget.appUrl));
                    } else {
                      throw 'Could not launch ${widget.appUrl}';
                    }

                    //launch("https://play.google.com/store/apps/details?id=com.jithvar.gambhir_mudda");
                  } else if (Platform.isIOS) {
                    // iOS-specific code
                    if (await canLaunchUrl(Uri.parse(widget.appUrl))) {
                      await launchUrl(Uri.parse(widget.appUrl));
                    } else {
                      throw 'Could not launch ${widget.appUrl}';
                    }
                  }
                },
                child: Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                      color: AppColors.mainAppColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Text(
                      "Update",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
