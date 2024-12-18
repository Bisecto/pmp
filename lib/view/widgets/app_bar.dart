import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../res/app_colors.dart';
import '../../model/user_model.dart';
import '../../res/app_svg_images.dart';
import 'app_custom_text.dart';

class CustomAppBar extends StatefulWidget {
  UserModel userModel;

  CustomAppBar({super.key, required this.userModel});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.lightPurple,
                  backgroundImage: NetworkImage(widget.userModel.profilePic),
                  //child: TextStyles.textHeadings(textValue: widget.),
                ),
              ],
            ),
            SvgPicture.asset(
              AppSvgImages.notification,
              height: 20,
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class AppAppBar extends StatefulWidget {
  final String title;

  const AppAppBar({super.key, required this.title});

  @override
  State<AppAppBar> createState() => _AppAppBarState();
}

class _AppAppBarState extends State<AppAppBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios)),
          TextStyles.textHeadings(textValue: widget.title),
          const SizedBox(),
        ],
      ),
    );
  }
}
