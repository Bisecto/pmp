import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../../../res/app_colors.dart';
import '../../res/app_svg_images.dart';
import 'app_custom_text.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

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
                  child: TextStyles.textHeadings(textValue: 'PMP'),
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
