import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../res/app_colors.dart';
import '../../utills/custom_theme.dart';
import '../widgets/app_custom_text.dart';

class AppLoadingPage extends StatelessWidget {
  final String title;

  const AppLoadingPage(this.title,{super.key,});

  @override
  Widget build(BuildContext context) {
    final themeContext = Provider.of<CustomThemeState>(context);
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Center(
        child: Container(
          // The background color
          color: !theme.isDark
              ? Colors.transparent
              : AppColors.darkBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // The loading indicator
                Container(
                  color: !theme.isDark
                      ? Colors.transparent
                      : AppColors.darkBackgroundColor,
                  height: 70,
                  child: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColors.mainAppColor,
                        size: 100,
                      )),
                ),
                const SizedBox(height: 10),

                DefaultTextStyle(
                  style: const TextStyle(
                      color: AppColors.mainAppColor,
                      fontFamily: 'Roboto',
                      backgroundColor: Colors.transparent,
                      fontSize: 15),
                  child: Text(
                    'Loading...',//title,
                    softWrap: true,

                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
