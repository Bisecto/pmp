// import 'dart:io';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';
// import 'package:school_portal/model/feeActicity.dart';
// import 'package:school_portal/model/student_profile.dart';
// import 'package:school_portal/res/app_colors.dart';
// import 'package:school_portal/res/app_images.dart';
// import 'package:school_portal/res/app_svg_images.dart';
// import 'package:school_portal/utills/app_navigator.dart';
// import 'package:school_portal/utills/app_utils.dart';
// import 'package:school_portal/view/mobile_view/fees/fees.dart';
// import 'package:school_portal/view/mobile_view/profile/profile.dart';
// import 'package:school_portal/view/mobile_view/result/result_page.dart';
// import 'package:school_portal/view/mobile_view/setting/setting.dart';
// import 'package:school_portal/view/widgets/app_custom_text.dart';
// import 'package:side_navigation/side_navigation.dart';
//
// import '../../main.dart';
// import '../../model/current_session.dart';
// import '../../model/fee.dart';
// import '../../utills/custom_theme.dart';
// import 'auth/sign_in_page.dart';
// import 'course_registration/course_registration.dart';
// import 'dashboard/dashboard.dart';
// import 'more/more_page.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalSheet;
//
// class CandidateLandingPage extends StatefulWidget {
//   int selectedIndex;
//   StudentProfile studentProfile;
//   FeesActivity feesActivity;
//   CurrentSession currentSession;
//
//   CandidateLandingPage(
//       {super.key,
//         required this.selectedIndex,
//         required this.studentProfile,
//         required this.feesActivity,
//         required this.currentSession});
//
//   @override
//   State<CandidateLandingPage> createState() => _CandidateLandingPageState();
// }
//
// class _CandidateLandingPageState extends State<CandidateLandingPage> {
//   List<Widget> views = const [];
//
//   int selectedIndex = 0;
//
//   //int selectedIndex = 0;
//   bool isNotification = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     selectedIndex = widget.selectedIndex;
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null) {
//         // OrderNotification orderNotification =
//         //  OrderNotification.fromJson(message.data);
//         setState(() {
//           isNotification = true;
//         });
//
//         modalSheet.showMaterialModalBottomSheet(
//           context: context,
//           enableDrag: true,
//           isDismissible: true,
//           expand: false,
//           builder: (context) => SingleChildScrollView(
//             controller: modalSheet.ModalScrollController.of(context),
//             child: Padding(
//               padding: const EdgeInsets.all(0.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                     width: AppUtils.deviceScreenSize(context).width,
//                     height: 100,
//                     color: AppColors.blue,
//
//                   ),
//
//                 ],
//               ),
//             ),
//           ),
//         );
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//                 android: AndroidNotificationDetails(
//                   channel.id,
//                   channel.name,
//                   //channel.description,
//                   color: Colors.blueAccent,
//                   playSound: true,
//                   icon: 'asset/images/logo.png',
//                 )));
//       }
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       AppUtils().debuglog('A new MessageOpenedApp event was published');
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null) {
//         // OrderNotification orderNotification =
//         // OrderNotification.fromJson(message.data);
//         setState(() {
//           isNotification = true;
//           // cat_Slug = message.data['categorySlug'];
//           // news_Id = message.data['news_id'];
//         });
//
//         //AppUtils().debuglog(orderNotification);
//         setState(() {
//           isNotification = true;
//         });
//
//         modalSheet.showMaterialModalBottomSheet(
//           context: context,
//           enableDrag: true,
//           isDismissible: true,
//           expand: false,
//           builder: (context) => SingleChildScrollView(
//             controller: modalSheet.ModalScrollController.of(context),
//             child: Padding(
//               padding: const EdgeInsets.all(0.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                     width: AppUtils.deviceScreenSize(context).width,
//                     height: 130,
//                     color: AppColors.blue,
//                     child:  Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Padding(
//                         padding: const EdgeInsets.all(0),
//                       ),
//                     ),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.all(15.0),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.home,
//                           color: AppColors.green,
//                         ),
//                         CustomText(
//                           text: "Home Delivery",
//                           weight: FontWeight.bold,
//                         )
//                       ],
//                     ),
//                   ),
//
//                 ],
//               ),
//             ),
//           ),
//         );
//       }});
//     views = [
//       Dashboard(
//         studentProfile: widget.studentProfile,
//         currentSession: widget.currentSession,
//       ),
//       Fees(
//         studentProfile: widget.studentProfile, currentSession: widget.currentSession,
//       ),
//
//       ResultPage(
//         user: widget.studentProfile, currentSession: widget.currentSession,
//       ),
//       CourseRegistration(
//         studentProfile: widget.studentProfile, currentSession: widget.currentSession,
//       ),
//       MorePage(
//         studentProfile: widget.studentProfile, currentSession: widget.currentSession,
//       ),
//       // ProfileScreen(
//       //   studentProfile: widget.studentProfile,
//       // ),
//       // SettingPage(),
//       // Center(
//       //   child: Text('Settings'),
//       // ),
//     ];
//     super.initState();
//   }
//
//   var _androidAppRetain = MethodChannel("android_app_retain");
//
//   @override
//   Widget build(BuildContext context) {
//     final themeContext = Provider.of<CustomThemeState>(context);
//     final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
//
//     // _buildSwitchToggle() {
//     //   return CupertinoSwitch(
//     //       value: themeContext.adaptiveThemeMode.isDark,
//     //       activeColor: theme.isDark
//     //           ? AppColors.mainAppColor
//     //           : Colors.grey.withOpacity(0.3),
//     //       thumbColor: theme.isDark ? Colors.white : Colors.white,
//     //       onChanged: (value) {
//     //         themeContext.changeTheme(context);
//     //       });
//     // }
//
//     return WillPopScope(
//       onWillPop: () async {
//         if (Platform.isAndroid) {
//           if (Navigator.of(context).canPop()) {
//             return Future.value(true);
//           } else {
//             _androidAppRetain.invokeMethod("sendToBackground");
//             return Future.value(false);
//           }
//         } else {
//           return Future.value(true);
//         }
//       },
//       child: Scaffold(
//         // appBar: AppBar(
//         //   backgroundColor: theme.isDark
//         //       ? AppColors.darkBackgroundColor
//         //       : AppColors.lightPrimary,
//         //   title: const Text(""),
//         //   iconTheme: IconThemeData(
//         //       color:
//         //           theme.isDark ? AppColors.white : AppColors.darkBackgroundColor),
//         //   elevation: 0,
//         //   actions: [
//         //     CircleAvatar(
//         //       backgroundColor: AppColors.mainAppColor,
//         //       backgroundImage: AssetImage(AppImages.person),
//         //     ),
//         //     SizedBox(
//         //       width: 15,
//         //     ),
//         //     Column(
//         //       crossAxisAlignment: CrossAxisAlignment.start,
//         //       mainAxisAlignment: MainAxisAlignment.center,
//         //       children: [
//         //         CustomText(
//         //           text: "${widget.studentProfile.firstName} ",
//         //           weight: FontWeight.bold,
//         //           color: theme.isDark ? AppColors.darkModeWhite : AppColors.black,
//         //           size: 14,
//         //         ),
//         //         CustomText(
//         //           text: widget.studentProfile.registrationNumber,
//         //           weight: FontWeight.w400,
//         //           color: Colors.grey,
//         //           size: 10,
//         //         ),
//         //       ],
//         //     ),
//         //     SizedBox(
//         //       width: 15,
//         //     ),
//         //   ],
//         // ),
//         // drawer: Drawer(
//         //   backgroundColor: AppColors.mainAppColor,
//         //   child: ListView(
//         //     padding: const EdgeInsets.all(0.0),
//         //     children: <Widget>[
//         //       const SizedBox(height: 50),
//         //       // CircleAvatar(
//         //       //   radius: 50,
//         //       //   //backgroundColor:AppColors.lightBackground,
//         //       //   child: Image.asset(
//         //       //     AppImages.logo,
//         //       //     height: 100,
//         //       //     width: 100,
//         //       //   ),
//         //       // ),
//         //       Center(
//         //         child: Column(
//         //           children: [
//         //             Image.asset(
//         //               AppImages.logo,
//         //               height: 100,
//         //               width: 100,
//         //             ),
//         //           ],
//         //         ),
//         //       ),
//         //       const SizedBox(height: 30),
//         //       ListTile(
//         //         leading: Icon(Icons.dashboard,
//         //             color: selectedIndex == 0
//         //                 ? (theme.isDark ? AppColors.black : AppColors.white)
//         //                 : (theme.isDark ? AppColors.darkModeBlack :AppColors.grey)),
//         //         title: CustomText(
//         //             text: 'Dashboard',
//         //             weight:
//         //                 selectedIndex == 0 ? FontWeight.w800 : FontWeight.w400,
//         //             color: selectedIndex == 0
//         //                 ? (theme.isDark ? AppColors.black : AppColors.white)
//         //                 : (theme.isDark ? AppColors.darkModeBlack :AppColors.grey)),
//         //         selectedColor: AppColors.white,
//         //         iconColor: theme.isDark ? AppColors.black : AppColors.grey,
//         //         onTap: () {
//         //           Navigator.pop(context);
//         //           setState(() {
//         //             selectedIndex = 0;
//         //           });
//         //         },
//         //       ),
//         //       ListTile(
//         //         leading: Icon(Icons.payments,
//         //             color: selectedIndex == 1
//         //                 ? (theme.isDark ? AppColors.black : AppColors.white)
//         //                 : (theme.isDark ? AppColors.darkModeBlack :AppColors.grey)),
//         //         title: CustomText(
//         //             text: 'Fees',
//         //             weight:
//         //                 selectedIndex == 1 ? FontWeight.w800 : FontWeight.w400,
//         //             color: selectedIndex == 1
//         //                 ? (theme.isDark ? AppColors.black : AppColors.white)
//         //                 : (theme.isDark ? AppColors.darkModeBlack :AppColors.grey)),
//         //         selectedColor: AppColors.white,
//         //         iconColor: theme.isDark ? AppColors.black : AppColors.grey,
//         //         onTap: () {
//         //           Navigator.pop(context);
//         //           setState(() {
//         //             selectedIndex = 1;
//         //           });
//         //         },
//         //       ),
//         //       ListTile(
//         //         leading: Icon(Icons.edit,
//         //             color: selectedIndex == 2
//         //                 ? (theme.isDark ? AppColors.black : AppColors.white)
//         //                 : (theme.isDark ? AppColors.darkModeBlack :AppColors.grey)),
//         //         title: CustomText(
//         //             text: 'Courses Registration',
//         //             weight:
//         //                 selectedIndex == 2 ? FontWeight.w800 : FontWeight.w400,
//         //             color: selectedIndex == 2
//         //                 ? (theme.isDark ? AppColors.black : AppColors.white)
//         //                 : (theme.isDark ? AppColors.darkModeBlack :AppColors.grey)),
//         //         selectedColor: AppColors.white,
//         //         iconColor: theme.isDark ? AppColors.black : AppColors.grey,
//         //         onTap: () {
//         //           Navigator.pop(context);
//         //
//         //           setState(() {
//         //             selectedIndex = 2;
//         //           });
//         //         },
//         //       ),
//         //       ListTile(
//         //         leading: Icon(Icons.book,
//         //             color: selectedIndex == 3
//         //                 ? (theme.isDark ? AppColors.black : AppColors.white)
//         //                 : (theme.isDark ? AppColors.darkModeBlack :AppColors.grey)),
//         //         title: CustomText(
//         //             text: 'Result',
//         //             weight:
//         //                 selectedIndex == 3 ? FontWeight.w800 : FontWeight.w400,
//         //             color: selectedIndex == 3
//         //                 ? (theme.isDark ? AppColors.black : AppColors.white)
//         //                 : (theme.isDark ? AppColors.darkModeBlack :AppColors.grey)),
//         //         selectedColor: AppColors.white,
//         //         iconColor: theme.isDark ? AppColors.black : AppColors.grey,
//         //         onTap: () {
//         //           Navigator.pop(context);
//         //
//         //           setState(() {
//         //             selectedIndex = 3;
//         //           });
//         //         },
//         //       ),
//         //       ListTile(
//         //         leading: Icon(Icons.person_2_rounded,
//         //             color: selectedIndex == 4
//         //                 ? (theme.isDark ? AppColors.black : AppColors.white)
//         //                 : (theme.isDark ? AppColors.darkModeBlack :AppColors.grey)),
//         //         title: CustomText(
//         //             text: 'Profile',
//         //             weight:
//         //                 selectedIndex == 4 ? FontWeight.w800 : FontWeight.w400,
//         //             color: selectedIndex == 4
//         //                 ? (theme.isDark ? AppColors.black : AppColors.white)
//         //                 : (theme.isDark ? AppColors.darkModeBlack :AppColors.grey)),
//         //         selectedColor: AppColors.white,
//         //         iconColor: theme.isDark ? AppColors.black : AppColors.black,
//         //         onTap: () {
//         //           Navigator.pop(context);
//         //
//         //           setState(() {
//         //             selectedIndex = 4;
//         //           });
//         //         },
//         //       ),
//         //       ListTile(
//         //         leading: Icon(Icons.settings,
//         //             color: selectedIndex == 5
//         //                 ? (theme.isDark ? AppColors.black : AppColors.white)
//         //                 : (theme.isDark ? AppColors.darkModeBlack :AppColors.grey)),
//         //         title: CustomText(
//         //             text: 'Settings',
//         //             weight:
//         //                 selectedIndex == 5 ? FontWeight.w800 : FontWeight.w400,
//         //             color: selectedIndex == 5
//         //                 ? (theme.isDark ? AppColors.black : AppColors.white)
//         //                 : (theme.isDark ? AppColors.darkModeBlack :AppColors.grey)),
//         //         selectedColor: AppColors.white,
//         //         iconColor: theme.isDark ? AppColors.black : AppColors.grey,
//         //         onTap: () {
//         //           Navigator.pop(context);
//         //
//         //           setState(() {
//         //             selectedIndex = 5;
//         //           });
//         //         },
//         //       ),
//         //       // Padding(
//         //       //   padding: const EdgeInsets.all(10.0),
//         //       //   child: BuildListTile(
//         //       //     icon: AppSvgImages.darkMode,
//         //       //     title: "Enable Dark Mode",
//         //       //     onPressed: null,
//         //       //     trailingWidget: _buildSwitchToggle(),
//         //       //   ),
//         //       // ),
//         //       const SizedBox(
//         //         height: 50,
//         //       ),
//         //       ListTile(
//         //         title:  CustomText(text: 'Logout', color: theme.isDark ? AppColors.black : AppColors.white),
//         //         leading: const Icon(Icons.logout),
//         //         selectedColor: AppColors.white,
//         //         iconColor: theme.isDark ? AppColors.black : AppColors.white,
//         //         onTap: (){
//         //           AppNavigator.pushAndRemovePreviousPages(context, page: SignInPage());
//         //         },
//         //       ),
//         //       Align(
//         //         alignment: Alignment.bottomCenter,
//         //         child: Column(
//         //           children: [
//         //             const CustomText(text: 'Powered by',size: 14, color: AppColors.black),
//         //             Image.asset(
//         //               AppImages.companyLogo,
//         //               height: 40,
//         //               width: 150,
//         //               color: AppColors.darkModeBlack,
//         //             ),
//         //           ],
//         //         ),
//         //       )
//         //
//         //     ],
//         //   ),
//         // ),
//         body: IndexedStack(
//           index: selectedIndex,
//           children: views,
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           backgroundColor: AppColors.white,
//           showUnselectedLabels: true,
//           currentIndex: selectedIndex,
//           selectedItemColor: AppColors.mainAppColor,
//           unselectedItemColor:
//           theme.isDark ? AppColors.lightPrimary : AppColors.lightDivider,
//           onTap: (index) {
//             setState(() {
//               selectedIndex = index;
//             });
//           },
//           items: [
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.dashboard,
//                 color: selectedIndex == 0
//                     ? AppColors.mainAppColor
//                     : theme.isDark
//                     ? AppColors.lightPrimary
//                     : AppColors.lightDivider,
//               ),
//               label: 'Dashboard',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.payments,
//                 color: selectedIndex == 1
//                     ? AppColors.mainAppColor
//                     : theme.isDark
//                     ? AppColors.lightPrimary
//                     : AppColors.lightDivider,
//               ),
//               label: 'Fees',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.list_alt,
//                 color: selectedIndex == 2
//                     ? AppColors.mainAppColor
//                     : theme.isDark
//                     ? AppColors.lightPrimary
//                     : AppColors.lightDivider,
//               ), //Icon(Icons.home),
//               label: 'Result',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.edit,
//                 color: selectedIndex == 3
//                     ? AppColors.mainAppColor
//                     : theme.isDark
//                     ? AppColors.lightPrimary
//                     : AppColors.lightDivider,
//               ), //Icon(Icons.home),
//               label: 'Course',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.more_horiz,
//                 color: selectedIndex == 4
//                     ? AppColors.mainAppColor
//                     : theme.isDark
//                     ? AppColors.lightPrimary
//                     : AppColors.lightDivider,
//               ), //Icon(Icons.home),
//               label: 'More',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
