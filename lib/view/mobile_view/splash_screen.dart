import 'package:flutter/material.dart';

import '../../res/app_colors.dart';
import '../../res/app_images.dart';
import '../../utills/app_utils.dart';
import '../widgets/app_custom_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppUtils appUtils = AppUtils();

  @override
  void initState() {
    appUtils.openApp(context);

    // TODO: implement initState
    // Future.delayed(const Duration(seconds: 3)).whenComplete(() async {
    //   String userData = await SharedPref.getString('userData');
    //   String savedUserFirstname = await SharedPref.getString('firstname');
    //   AppUtils().debuglog(userData);
    //   AppUtils().debuglog(savedUserFirstname);
    //   if(userData.isEmpty&&savedUserFirstname.isEmpty){
    //   AppNavigator.pushAndReplaceName(context, name: AppRouter.signInPage);}else{
    //     AppNavigator.pushAndReplaceName(context, name: AppRouter.exixtingSignInPage);
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: AppUtils.deviceScreenSize(context).height,
      width: AppUtils.deviceScreenSize(context).width,
      decoration: const BoxDecoration(color: AppColors.white
          // image: DecorationImage(
          //   image: AssetImage(AppImages.splashFrame,),fit: BoxFit.fill
          // ),

          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomText(text: ''),
          Center(
              child: Image.asset(
            AppImages.logo,
            height: 150,
            width: 150,
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                const CustomText(text: 'Powered by', color: AppColors.black),
                Image.asset(
                  AppImages.companyLogo,
                  height: 80,
                  width: 150,
                  //color: AppColors.darkModeBlack,
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
