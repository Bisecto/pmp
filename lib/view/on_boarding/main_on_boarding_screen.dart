// import 'package:flutter/material.dart';
// import 'package:flutter_carousel_slider/carousel_slider.dart';
//
// import '../../res/app_colors.dart';
// import '../../res/app_images.dart';
// import '../../res/app_router.dart';
// import '../../res/app_strings.dart';
// import '../../utills/app_navigator.dart';
// import '../../utills/app_utils.dart';
// import '../widgets/app_custom_text.dart';
// import '../widgets/form_button.dart';
//
// class OnBoardingScreen extends StatefulWidget {
//   const OnBoardingScreen({super.key});
//
//   @override
//   State<OnBoardingScreen> createState() => _OnBoardingScreenState();
// }
//
// class _OnBoardingScreenState extends State<OnBoardingScreen> {
//   final List<String> onboardingImages = [
//     AppImages.onBoardingScreen1,
//     // AppImages.onBoardingScreen2,
//     // AppImages.onBoardingScreen3,
//   ];
//   final List<String> onBoardingText = [
//     AppStrings.onBoardingScreen1MainText,
//     // AppStrings.onBoardingScreen2MainText,
//     // AppStrings.onBoardingScreen3MainText,
//   ];
//   final List<String> onBoardingSubText = [
//     AppStrings.onBoardingScreen1SubText,
//     // AppStrings.onBoardingScreen2SubText,
//     // AppStrings.onBoardingScreen3SubText,
//   ];
//   // bool _isPlaying = false;
//   final GlobalKey _sliderKey = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: ListView(
//           children: <Widget>[
//             SizedBox(
//               height: AppUtils.deviceScreenSize(context).height * 0.7,
//               child: CarouselSlider.builder(
//                   key: _sliderKey,
//                   unlimitedMode: true,
//                   slideBuilder: (index) {
//                     return Center(
//                       child: SizedBox(
//                         width: AppUtils.deviceScreenSize(context).width,
//                         // Set the desired width of the container
//                         height: AppUtils.deviceScreenSize(context).height * 0.7,
//                         // Set the desired height of the container
//                         // decoration: BoxDecoration(
//                         //   borderRadius: BorderRadius.circular(32),
//                         //   image: DecorationImage(
//                         //     image: AssetImage(onboardingImages[index]),
//                         //     // Replace with your actual image file path
//                         //     fit: BoxFit
//                         //         .cover, // You can adjust the fit property to cover, contain, or others
//                         //   ),
//                         // ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Stack(
//                             children: [
//                               Positioned(
//                                 right: 0,
//                                 left: 0,
//                                 top: 0,
//                                 bottom: 0,
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Padding(
//                                     padding:
//                                         const EdgeInsets.only(bottom: 16.0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 16.0),
//                                           child: Container(
//                                             width: AppUtils.deviceScreenSize(
//                                                     context)
//                                                 .width,
//                                             // Set the desired width of the container
//                                             height: AppUtils.deviceScreenSize(
//                                                         context)
//                                                     .height *
//                                                 0.5,
//                                             // Set the desired height of the container
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(32),
//                                               image: DecorationImage(
//                                                 image: AssetImage(
//                                                     onboardingImages[index]),
//                                                 // Replace with your actual image file path
//                                                 fit: BoxFit
//                                                     .cover, // You can adjust the fit property to cover, contain, or others
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         CustomText(
//                                           text: onBoardingText[index],
//                                           color: AppColors.textColor,
//                                           size: 24,
//                                           weight: FontWeight.bold,
//                                         ),
//                                         CustomText(
//                                           text: onBoardingSubText[index],
//                                           color: AppColors.textColor,
//                                           size: 16,
//                                           maxLines: 4,
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                   slideTransform: const DefaultTransform(),
//                   slideIndicator: CircularSlideIndicator(
//                     indicatorBackgroundColor: AppColors.lightPrimaryGreen,
//                     currentIndicatorColor: AppColors.green,
//                     padding: const EdgeInsets.only(bottom: 0),
//                   ),
//                   itemCount: onboardingImages.length),
//             ),
//             FormButton(
//               onPressed: () {
//                 AppNavigator.pushAndStackNamed(context, name: AppRouter.signUpPageGetStarted);
//               },
//               text: 'Create an account',
//               borderRadius: 20,
//               borderColor: AppColors.green,
//             ),
//             FormButton(
//               onPressed: () {
//                 AppNavigator.pushAndStackNamed(context, name: AppRouter.signInPage);
//
//               },
//               text: 'Sign in to existing account',
//               borderColor: AppColors.green,
//               bgColor: AppColors.white,
//               textColor: AppColors.green,
//               borderRadius: 20,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
