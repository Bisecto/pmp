// import 'package:cross_connectivity/cross_connectivity.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../res/app_colors.dart';
// import '../../utills/custom_theme.dart';
// import '../widgets/form_button.dart';
// import 'dialog_box.dart';
//
// class NoInternet extends StatelessWidget {
//   const NoInternet({Key? key, required this.callBack, this.reInitApp = false})
//       : super(key: key);
//   final Function() callBack;
//   final bool reInitApp;
//
//   @override
//   Widget build(BuildContext context) {
//     final themeContext = Provider.of<CustomThemeState>(context);
//     final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
//
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
//             child: Icon(Icons.wifi_off, size: 48, color: AppColors.green),
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
//             child: Text(
//               'No Internet Connection',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
//             child: Text(
//               'An internet connection error occurred, please try again',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
//             child: FormButton(
//               onPressed: () {
//                 Connectivity().checkConnection().then((connected) async {
//                   if (connected) {
//                     callBack();
//                   } else {
//                     MSG.errorSnackBar(context, 'No Internet Connection');
//                   }
//                 });
//               },
//               text: 'TRY AGAIN',
//               textColor: AppColors.white,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
