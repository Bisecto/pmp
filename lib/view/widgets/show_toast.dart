// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../res/app_colors.dart';
// import '../../utills/custom_theme.dart';
//
// import 'app_custom_text.dart';
//
// showToast(
//     {required BuildContext context,
//       required String title,
//       required String subtitle,
//       required ToastMessageType type}) {
//   if (type == ToastMessageType.success) {
//     alert(
//         context: context,
//         title: title,
//         subtitle: subtitle,
//         alertType: AlertType.success);
//   } else if (type == ToastMessageType.info) {
//     alert(
//         context: context,
//         title: title,
//         subtitle: subtitle,
//         alertType: AlertType.info);
//   } else if (type == ToastMessageType.error) {
//     //Vibrate.vibrate(); //vibrate device
//     alert(
//         context: context,
//         title: title,
//         subtitle: subtitle,
//         alertType: AlertType.error);
//   }
// }
//
// Future<bool?> alert({
//   required BuildContext context,
//   required String title,
//   required String subtitle,
//   required AlertType alertType,
// }) {
//   final theme =
//       Provider.of<CustomThemeState>(context, listen: false).adaptiveThemeMode;
//   return showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         backgroundColor: Colors.transparent,
//         content: Container(
//           width: double.infinity,
//           height: 400,
//           decoration: BoxDecoration(
//               color: theme.isDark
//                   ? AppColors.darkModeBackgroundContainerColor
//                   : AppColors.white,
//               borderRadius: BorderRadius.circular(20),
//               image:   DecorationImage(
//                   image: AssetImage(AppImages.modalBackground,),
//                   //colorFilter: ColorFilter.,
//                   opacity:theme.isDark
//                       ? 0.2:1,
//                   fit: BoxFit.cover)),
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Align(
//                     alignment: Alignment.topLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         decoration: BoxDecoration(
//                             color:
//                             theme.isDark ? AppColors.red : Colors.transparent,
//                             border: Border.all(
//                                 color: theme.isDark
//                                     ? AppColors.red
//                                     : AppColors.green),
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Center(
//                             child: Icon(
//                               Icons.arrow_back,
//                               color:
//                               theme.isDark ? AppColors.white : AppColors.black,
//                             )),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Column(
//                   children: [
//                     GestureDetector(onTap:(){                  Navigator.pop(context);
//                     },child: Lottie.asset(_getImage(alertType), height: 120, width: 120)),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     TextStyles.textHeadings(
//                       textValue: title,
//                       textColor: theme.isDark ? AppColors.white : AppColors.black,
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: CustomText(
//                           text: subtitle,
//                           color:
//                           theme.isDark ? AppColors.white : AppColors.black,
//                           size: 14,
//                           maxLines: 5,
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
//
// Color getColor(AlertType type) {
//   if (type == AlertType.success) {
//     return Colors.green;
//   }
//   if (type == AlertType.info) {
//     return AppColors.appBarMainColor;
//   }
//   return Colors.red;
// }
//
// String _getImage(AlertType type) {
//   if (type == AlertType.success) {
//     return 'assets/animations/success.json';
//   }
//   if (type == AlertType.info) {
//     return 'assets/animations/info.json';
//   }
//   return 'assets/animations/error.json';
// }
