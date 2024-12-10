import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pim/utills/app_navigator.dart';
import 'package:pim/view/mobile_view/auth/sign_in_page.dart';

import '../../../../res/app_colors.dart';
import '../../../../utills/custom_theme.dart';
import '../../../widgets/app_custom_text.dart';
import '../../../widgets/form_button.dart';

class Congrats extends StatefulWidget {
  const Congrats({super.key});

  @override
  State<Congrats> createState() => _CongratsState();
}

class _CongratsState extends State<Congrats> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                   CustomText(
                    text: "Congratulation",
                    weight: FontWeight.bold,
                    color: theme.isDark
                        ? AppColors.white
                        : AppColors.darkCardBackgroundColor,
                    size: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   CustomText(
                    text: "You have now changed your password proceed to login to your dashboard",
                    weight: FontWeight.w400,
                    color: theme.isDark
                        ? AppColors.white
                        : AppColors.darkCardBackgroundColor,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    size: 14,
                  ),
                  FormButton(
                    onPressed: () async {
                      AppNavigator.pushAndRemovePreviousPages(context, page: SignInPage());
                        //Navigator.pop(context);


                    },
                    text: 'Login',
                    borderColor: AppColors.mainAppColor,
                    bgColor: AppColors.mainAppColor,
                    textColor: AppColors.white,
                    borderRadius: 10,
                    height: 50,
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

}
