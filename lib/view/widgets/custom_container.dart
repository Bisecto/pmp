import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/app_colors.dart';
import '../../utills/custom_theme.dart';
import 'app_custom_text.dart';
import 'app_spacer.dart';

class CustomScaffoldWidget extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavBar;

  const CustomScaffoldWidget(
      {Key? key, this.appBar, this.bottomNavBar, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
    return Scaffold(
      backgroundColor:
          theme.isDark ? AppColors.darkBackgroundColor : AppColors.white,
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavBar,
    );
  }
}

class CustomContainerFirTitleDesc extends StatelessWidget {
  final String title;
  final String description;

  const CustomContainerFirTitleDesc(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.grey)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    weight: FontWeight.bold,
                  ),
                  CustomText(
                    text: description,
                  )
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomContainerForToggle extends StatelessWidget {
  final String title;

  //final String description;
  final bool isSwitched;
  final Function(bool) toggleSwitch;

  const CustomContainerForToggle(
      {super.key,
      required this.title,
      //required this.description,
      required this.isSwitched,
      required this.toggleSwitch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.lightPrimary,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.grey)),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: title,
                weight: FontWeight.bold,
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     CustomText(
              //       text: title,
              //       weight: FontWeight.bold,
              //     ),
              //     // CustomText(
              //     //   text: description,
              //     //   maxLines: 3,
              //     //   size: 14,
              //     // ),
              //   ],
              // ),
              Switch(
                value: isSwitched,
                onChanged: toggleSwitch,
                activeTrackColor: AppColors.grey,
                activeColor: AppColors.green,
                inactiveTrackColor: Colors.grey,

                //inactiveThumbColor: AppColors.red,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomContainerWithIcon extends StatelessWidget {
  final String title;
  final Widget iconData;

  const CustomContainerWithIcon({
    super.key,
    required this.title,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.lightPrimary,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.grey)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconData,
              const AppSpacer(
                width: 15,
              ),
              CustomText(
                text: title,
                weight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
