// import 'dart:convert';
// import 'dart:io';
//
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:face_camera/face_camera.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:school_portal/view/widgets/app_custom_text.dart';
//
// import '../../../model/current_session.dart';
// import '../../../model/feeActicity.dart';
// import '../../../model/student_profile.dart';
// import '../../../res/apis.dart';
// import '../../../res/app_colors.dart';
// import '../../../utills/app_navigator.dart';
// import '../../../utills/shared_preferences.dart';
// import '../../important_pages/dialog_box.dart';
// import '../../important_pages/not_found_page.dart';
// import '../../widgets/form_button.dart';
// import '../landing_page.dart';
//
// class TakeImage extends StatefulWidget {
//   StudentProfile studentProfile;
//   FeesActivity feesActivity;
//   CurrentSession currentSession;
//
//   TakeImage(
//       {super.key,
//       required this.studentProfile,
//       required this.feesActivity,
//       required this.currentSession});
//
//   @override
//   State<TakeImage> createState() => _TakeImageState();
// }
//
// class _TakeImageState extends State<TakeImage> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     FaceCamera.initialize(); //Add this
//     showNotice();
//     super.initState();
//   }
//
//   File avatar = File('path');
//
//   //File _capturedImage = File('path');
//
//   // import 'dart:convert';
//   // import 'dart:io';
//
//   Future<void> uploadImage(File imageFile) async {
//     print(1);
//     // Create a multipart request
//     showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (_) {
//           return const AppLoadingPage('Processing...');
//         });
//     print(1);
//
//     try {
//       String accessToken = await SharedPref.getString('access-token');
//
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('${AppApis.appBaseUrl}/u-auth/upload-profile-photo/'),
//       );
//       request.headers.addAll({
//         'Authorization': 'JWT $accessToken',
//         'Content-Type': 'multipart/form-data',
//       });
//       // Add the image file to the request
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'image',
//           // This is the name of the field in your API to which you're uploading the image
//           imageFile.path,
//         ),
//       );
//
//       // Send the request
//       var response = await request.send();
//
//       // Check if the request was successful
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // If the request was successful, parse the response JSON
//         //StudentProfile studentProfile=
//         Navigator.pop(context);
//         StudentProfile studentProfile = widget.studentProfile;
//         studentProfile.studentImage =
//             '/media/student_images/${widget.studentProfile.registrationNumber}.png';
//         print(studentProfile);
//         var jsonResponse = json.decode(await response.stream.bytesToString());
//         AppNavigator.pushAndRemovePreviousPages(context,
//             page: LandingPage(
//                 selectedIndex: 0,
//                 studentProfile: studentProfile,
//                 feesActivity: widget.feesActivity,
//                 currentSession: widget.currentSession));
//         // Handle the response data here
//         print(jsonResponse);
//       } else {
//         Navigator.pop(context);
//         MSG.errorSnackBar(context, "Image Upload was not successful");
//         // If the request failed, print the error message
//         print('Request failed with status: ${response.statusCode}');
//       }
//     } catch (e) {
//       Navigator.pop(context);
//     }
//   }
// bool isCorrect=false;
//   void showNotice() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       AwesomeDialog(
//         context: context,
//         dialogType: DialogType.info,
//         dismissOnTouchOutside: true,
//         borderSide: const BorderSide(color: Colors.green, width: 2),
//         buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
//         headerAnimationLoop: false,
//         animType: AnimType.bottomSlide,
//         title: 'Profile Image Upload',
//         desc:
//         'You are about to take your university life image and this cannot be re-edited',
//         showCloseIcon: false,
//         btnCancel: FormButton(
//           onPressed: () async {
//             Navigator.pop(context);
//             Navigator.pop(context);
//
//           },
//           text: 'Cancel',
//           bgColor: AppColors.mainAppColor,
//         ),
//         btnOk: FormButton(
//           onPressed: () async {
//             Navigator.pop(context);
//
//           },
//           text: 'Continue',
//           bgColor: AppColors.mainAppColor,
//         ),
//         // btnCancelOnPress: () {
//         //   // Navigator.pop(context);
//         // },
//         btnOkOnPress: () {
//           //Navigator.pop(context);
//         },
//       ).show();
//     });
//   }
//     @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(body: Builder(builder: (context) {
//       return Scaffold(
//         appBar: AppBar(title: CustomText(text: "Image Upload",),),
//         body:  SmartFaceCamera(
//             autoCapture: false,
//             showFlashControl: false,
//             showCameraLensControl: false,
//             performanceMode: FaceDetectorMode.accurate,
//             //indicatorShape:IndicatorShape.circle,
//             captureControlIcon: Icon(Icons.camera_alt,size: 50,),
//             defaultCameraLens: CameraLens.front,
//             onCapture: (File? image) async {
//               if(isCorrect){
//                 print(image);
//                 print(image);
//                 print(image);
//                 print(image);
//                 print(image);
//                 print(image);
//                 setState(() {
//                   avatar = File(image!.path);
//                 });
//                 final renamedFile = File(
//                     '${avatar.parent.path}/${widget.studentProfile.registrationNumber}.png');
//                 await avatar.rename(renamedFile.path);
//                 print(renamedFile);
//                 print(renamedFile);
//                 print(renamedFile);
//                 print(renamedFile);
//                 print(renamedFile);
//                 print(renamedFile);
//                 print(renamedFile);
//                 uploadImage(renamedFile);
//               }else{
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   AwesomeDialog(
//                     context: context,
//                     dialogType: DialogType.info,
//                     dismissOnTouchOutside: true,
//                     borderSide: const BorderSide(color: Colors.green, width: 2),
//                     buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
//                     headerAnimationLoop: false,
//                     animType: AnimType.bottomSlide,
//                     title: 'Warning',
//                     desc:
//                     'No face detected!',
//                     showCloseIcon: false,
//                     btnOk: FormButton(
//                       onPressed: () async {
//                         Navigator.pop(context);
//
//                         // getImage(context);
//                         print(123456);
//                       },
//                       text: 'Retake',
//                       bgColor: AppColors.mainAppColor,
//                     ),
//                     // btnCancelOnPress: () {
//                     //   // Navigator.pop(context);
//                     // },
//                     btnOkOnPress: () {
//                       //Navigator.pop(context);
//                     },
//                   ).show();
//                 });
//               }
//
//             },
//             onFaceDetected: (Face? face) {
//               //Do something
//             },
//             messageBuilder: (context, face) {
//               if (face == null) {
//                 //setState(() {
//                 isCorrect=false;
//                 // });
//                 return _message('Place your face in the camera');
//               }
//               if (!face.wellPositioned) {
//                 //setState(() {
//                 isCorrect=false;
//                 //});
//                 return _message('Center your face in the square');
//               }
//               // setState(() {
//               isCorrect=true;
//               //});
//               return const SizedBox.shrink();
//             }),
//       );
//     })
//         //     SmartFaceCamera(
//         //   autoCapture: false,
//         //   defaultCameraLens: CameraLens.front,
//         //   message: 'Center your face in the square',
//         //
//         //   onCapture: (File? image) async {
//         //     print(image);
//         //     print(image);
//         //     print(image);
//         //     print(image);
//         //     print(image);
//         //     print(image);
//         //     setState(() {
//         //       avatar = File(image!.path);
//         //     });
//         //     final renamedFile = File(
//         //         '${avatar.parent.path}/${widget.studentProfile.registrationNumber}.png');
//         //     await avatar.rename(renamedFile.path);
//         //     print(renamedFile);
//         //     print(renamedFile);
//         //     print(renamedFile);
//         //     print(renamedFile);
//         //     print(renamedFile);
//         //     print(renamedFile);
//         //     print(renamedFile);
//         //     uploadImage(renamedFile);
//         //   },
//         // )
//         );
//   }
//
//   Widget _message(String msg) => Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
//         child: Text(msg,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//                 fontSize: 14, height: 1.5, fontWeight: FontWeight.w400)),
//       );
// }
