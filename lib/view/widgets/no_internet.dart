import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';

import '../../res/app_colors.dart';
import 'form_button.dart';



class No_internet_Page extends StatelessWidget {
  const No_internet_Page({Key? key, required this.onRetry, }) : super(key: key);
  final Function() onRetry;
  //final bool reInitApp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
            child: Icon(Icons.wifi_off, size: 48, color: AppColors.mainAppColor),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
            child: Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Text(
              'An internet connection error occurred, please try again',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
            child: FormButton(
              onPressed: () {
               onRetry();
              },
              text: 'TRY AGAIN',
              bgColor: AppColors.mainAppColor,
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}