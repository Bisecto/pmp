// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
// import 'package:pim/utills/app_navigator.dart';
// import 'package:pim/utills/app_utils.dart';
// import 'package:pim/view/mobile_view/auth/forgot_password/verify_otp.dart';
// import 'package:pim/view/widgets/app_custom_text.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../../bloc/auth_bloc/auth_bloc.dart';
// import '../../../../res/app_colors.dart';
// import '../../../../res/app_images.dart';
// import '../../../../res/app_router.dart';
// import '../../../../utills/app_validator.dart';
// import '../../../../utills/custom_theme.dart';
//
// import '../../../res/apis.dart';
// import '../../important_pages/dialog_box.dart';
// import '../../important_pages/not_found_page.dart';
// import '../../widgets/form_button.dart';
// import '../../widgets/form_input.dart';
//
// class FindMyEmail extends StatefulWidget {
//   const FindMyEmail({super.key});
//
//   @override
//   State<FindMyEmail> createState() => _FindMyEmailState();
// }
//
// class _FindMyEmailState extends State<FindMyEmail> {
//   final _formKey = GlobalKey<FormState>();
//   final _numController = TextEditingController();
//   final AuthBloc authBloc = AuthBloc();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     //authBloc.add(InitialEvent());
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeContext = Provider.of<CustomThemeState>(context);
//     final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.mainAppColor,
//         centerTitle: true,
//         title: const CustomText(
//           text: 'Find Email',
//           color: AppColors.white,
//         ),
//         iconTheme: const IconThemeData(color: AppColors.white),
//       ),
//       body: Column(
//         children: [
//           Form(
//               key: _formKey,
//               child: Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Column(
//                   children: [
//                     CustomTextFormField(
//                       hint: 'Enter your registration number',
//                       label: 'Registration number',
//                       borderColor: AppColors.mainAppColor,
//                       controller: _numController,
//                       backgroundColor: theme.isDark
//                           ? AppColors.darkCardBackgroundColor
//                           : AppColors.white,
//                       hintColor: !theme.isDark
//                           ? AppColors.darkCardBackgroundColor.withOpacity(0.5)
//                           : AppColors.grey,
//                       validator: (String? text) {
//                         if (text == null || text.length < 10) {
//                           return 'Required.';
//                         }
//                         return null;
//                       },
//                       icon: Icons.person_2_outlined,
//                       maxLength: 10,
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     BlocConsumer<AuthBloc, AuthState>(
//                         bloc: authBloc,
//                         listenWhen: (previous, current) =>
//                             current is! AuthInitial,
//                         buildWhen: (previous, current) =>
//                             current is! AuthInitial,
//                         listener: (context, state) {
//                           if (state is ErrorState) {
//                             MSG.warningSnackBar(context, state.error);
//                           }
//                         },
//                         builder: (context, state) {
//                           AppUtils().debuglog(state);
//
//                               return SafeArea(
//                                   child: SingleChildScrollView(
//                                 child: Padding(
//                                   padding: EdgeInsets.all(0.0),
//                                   child: Column(
//                                     //mainAxisAlignment: MainAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(0.0),
//                                         child: Material(
//                                           elevation: 2,
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           child: ListTile(
//                                             title: Text(
//                                               findEmailSuccessPage
//                                                   .findUserModel.fullName,
//                                               //size: 15,
//                                             ),
//                                             trailing: GestureDetector(
//                                                 onTap: () {
//                                                   AppUtils().copyToClipboard(
//                                                       findEmailSuccessPage
//                                                           .findUserModel.email,
//                                                       context);
//                                                 },
//                                                 child: Icon(Icons.copy)),
//                                             subtitle: Text(
//                                               findEmailSuccessPage
//                                                   .findUserModel.email,
//                                             ),
//                                             leading: SizedBox(
//                                               height: 50,
//                                               width: 50,
//                                               child: Row(
//                                                 children: [
//                                                   const CircleAvatar(
//                                                     radius: 20,
//                                                     backgroundColor:
//                                                         Colors.orange,
//                                                     //child: ,
//                                                     backgroundImage: AssetImage(
//                                                         AppImages.person),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       // SizedBox(
//                                       //   height: 20,
//                                       // ),
//                                     ],
//                                   ),
//                                 ),
//                               ));
//
//                            else if (state is ErrorState) {
//                             return const CustomText(
//                                 text:
//                                     "There was a problem fetching Your email.");
//                           } else if (state is LoadingState) {
//                             return const Center(
//                               child: AppLoadingPage('Loading...'),
//                             );
//                           } else {
//                             return const Center(
//                               child: SizedBox(),
//                             );
//                           }
//                         }),
//                     Padding(
//                       padding: const EdgeInsets.all(0.0),
//                       child: FormButton(
//                         onPressed: () {
//                           // if
//                           if (_formKey.currentState!.validate()) {
//                             if (_numController.text.toString().length == 10) {
//                               authBloc.add(FindMyEmailEventClick(
//                                   _numController.text.toLowerCase(), context));
//                             }
//                           }
//                         },
//                         bgColor: AppColors.mainAppColor,
//                         borderRadius: 10,
//                         text: 'Find',
//                       ),
//                     )
//                   ],
//                 ),
//               )),
//         ],
//       ),
//       // floatingActionButton: FloatingActionButton.extended(
//       //   //mini: true,
//       //
//       //   onPressed: () async {
//       //     if (Platform.isAndroid) {
//       //       if (await canLaunchUrl(Uri.parse('https://support.unizik.edu.ng/open.php'))) {
//       //         await launchUrl(Uri.parse('https://support.unizik.edu.ng/open.php'));
//       //       } else {
//       //         throw 'Could not launch https://support.unizik.edu.ng/open.php';
//       //       }
//       //
//       //       //launch("https://play.google.com/store/apps/details?id=com.jithvar.gambhir_mudda");
//       //     } else if (Platform.isIOS) {
//       //       // iOS-specific code
//       //       if (await canLaunchUrl(Uri.parse('https://support.unizik.edu.ng/open.php'))) {
//       //         await launchUrl(Uri.parse('https://support.unizik.edu.ng/open.php'));
//       //       } else {
//       //         throw 'Could not launch https://support.unizik.edu.ng/open.php';
//       //       }
//       //     }
//       //   },
//       //   icon: Icon(
//       //     Icons.chat,
//       //     color: AppColors.white,
//       //   ),
//       //   label: CustomText(
//       //     text: "Support",
//       //     color: AppColors.white,
//       //   ),
//       //   backgroundColor: AppColors.mainAppColor,
//       // ),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
// }
