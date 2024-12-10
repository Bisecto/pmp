// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:disk_space_update/disk_space_update.dart';
// import 'package:external_path/external_path.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:teller_trust/model/transactionHistory.dart';
// import 'package:teller_trust/res/app_icons.dart';
// import 'package:teller_trust/utills/app_navigator.dart';
// import 'package:teller_trust/utills/app_utils.dart';
// import 'package:teller_trust/view/the_app_screens/landing_page.dart';
// import 'package:teller_trust/view/widgets/form_button.dart';
// import 'package:teller_trust/view/widgets/show_toast.dart';
//
// import '../../repository/app_repository.dart';
// import '../../res/apis.dart';
// import '../../res/app_colors.dart';
// import '../../utills/constants/loading_dialog.dart';
// import '../../utills/custom_theme.dart';
// import '../../utills/enums/toast_mesage.dart';
// import '../../utills/shared_preferences.dart';
// import 'app_custom_text.dart';
//
// class TransactionReceipt extends StatefulWidget {
//   final Transaction transaction;
//   bool isHome;
//
//   TransactionReceipt(
//       {super.key, required this.transaction, this.isHome = false});
//
//   @override
//   State<TransactionReceipt> createState() => _TransactionReceiptState();
// }
//
// class _TransactionReceiptState extends State<TransactionReceipt> {
//   bool isSharingPdf = false;
//   ScreenshotController screenshotController = ScreenshotController();
//   PdfDocument? document = PdfDocument();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     print(widget.transaction.toJson());
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//     ));
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
//
//     return Scaffold(
//       body: Screenshot(
//         controller: screenshotController,
//         child: Container(
//           height: AppUtils.deviceScreenSize(context).height,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 const Color(0x00f4fce3).withOpacity(1),
//                 const Color(0x00ffe4ab).withOpacity(1),
//                 const Color(0x00c2f6ae).withOpacity(1),
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.only(left: 15, right: 15),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 50),
//                   buildHeader(context, theme),
//                   const SizedBox(height: 20),
//                   buildReceiptDetails(),
//                   const SizedBox(height: 20),
//                   if (!isSharingPdf)
//                     buildActionButtons(widget.transaction.description),
//                   if (!isSharingPdf&&widget.isHome)
//                     FormButton(
//                       onPressed: () {
//                         AppNavigator.pushAndRemovePreviousPages(context, page: LandingPage());
//                       },
//                       width: AppUtils.deviceScreenSize(context).width/2,
//                       text: 'Homepage',
//                       iconWidget: Icons.arrow_forward,
//                       textColor: AppColors.white,
//                       isIcon: true,
//                       borderRadius: 20,
//                       bgColor: AppColors.green,
//                     ),
//                   const SizedBox(height: 50),
//                   buildFooter(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // AdaptiveThemeMode? adaptiveThemeMode =
//   //     await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light;
//
//   Widget buildHeader(BuildContext context, theme) {
//     return Container(
//       alignment: Alignment.center,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               if (!isSharingPdf)
//                 GestureDetector(
//                   onTap: () {
//                     if (widget.isHome) {
//                       AppNavigator.pushAndRemovePreviousPages(context,
//                           page: LandingPage());
//                     } else {
//                       Navigator.pop(context);
//                     }
//                     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//                       statusBarColor: Colors.transparent,
//                       statusBarIconBrightness:
//                           theme.isDark ? Brightness.light : Brightness.dark,
//                     ));
//                   },
//                   child: Container(
//                     height: 30,
//                     width: 30,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: AppColors.textColor2, width: 2),
//                     ),
//                     child: const Center(
//                       child: CustomText(
//                         text: "x",
//                         weight: FontWeight.bold,
//                         color: AppColors.textColor2,
//                       ),
//                     ),
//                   ),
//                 )
//             ],
//           ),
//           SvgPicture.asset(AppIcons.logoReceipt),
//           const CustomText(text: 'Transaction Receipt'),
//         ],
//       ),
//     );
//   }
//
//   Widget buildReceiptDetails() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           buildDetailRow(
//             'Product Name',
//             widget.transaction.order?.product?.name ??
//                 (widget.transaction.type.toLowerCase().contains('credit')
//                     ? 'Credit'
//                     : 'Debit'),
//           ),
//           buildDetailRow('Amount', 'N${widget.transaction.amount}'),
//           if (widget.transaction.order != null) const SizedBox(height: 12),
//           if (widget.transaction.order != null)
//             buildDetailRow(
//                 'To',
//                 widget.transaction.order?.requiredFields.meterNumber ??
//                     widget.transaction.order?.requiredFields.cardNumber ??
//                     widget.transaction.order?.requiredFields.phoneNumber ??
//                     '',
//                 true),
//           const SizedBox(height: 12),
//           buildDetailRow('Description', widget.transaction.description),
//           if (widget.transaction.order?.response?.utilityToken != null &&
//               widget.transaction.order!.response!.utilityToken.isNotEmpty &&
//               widget.transaction.status.toLowerCase() == 'success') ...[
//             const SizedBox(height: 12),
//             buildDetailRow(
//               'Utility Token',
//               widget.transaction.order!.response!.utilityToken,
//               true,
//             ),
//           ],
//           const SizedBox(height: 12),
//           buildDetailRow(
//               'Date',
//               AppUtils.formateSimpleDate(
//                   dateTime: widget.transaction.createdAt.toString())),
//           const SizedBox(height: 20),
//           const Divider(),
//           const SizedBox(height: 12),
//           buildDetailRow(
//               'Transaction Reference', widget.transaction.reference, true),
//           const SizedBox(height: 12),
//           buildDetailRow(
//               'Status',
//               widget.transaction.status.toLowerCase() == 'success'
//                   ? "SUCCESSFUL"
//                   : widget.transaction.status.toUpperCase()),
//           const SizedBox(height: 20),
//           Center(
//             child: TextStyles.textHeadings(
//               textValue: 'TellaTrust',
//               textColor: AppColors.textColor2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildDetailRow(String label, String value, [bool isCopyable = false]) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomText(text: label, size: 12, color: AppColors.textColor2),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               width:
//                   //isCopyable
//
//                   // ?
//                   AppUtils.deviceScreenSize(context).width / 1.5,
//
//               //  : null,
//               child: CustomText(
//                 text: value,
//                 size: 14,
//                 color: AppColors.black,
//                 maxLines: 2,
//               ),
//             ),
//             if (isCopyable)
//               if (!isSharingPdf)
//                 GestureDetector(
//                   onTap: () {
//                     AppUtils().copyToClipboard(value, context);
//                   },
//                   child: SvgPicture.asset(AppIcons.copy2),
//                 ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget buildActionButtons(String title) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         GestureDetector(
//           onTap: () {
//             pdfShare(context, title);
//           },
//           child: buildActionButton('Share', AppIcons.send, pdfShare),
//         ),
//         GestureDetector(
//           onTap: () {
//             pdfDownload(context, title);
//           },
//           child: buildActionButton('Download', AppIcons.download, pdfDownload),
//         ),
//         if (widget.transaction.status.toLowerCase() == 'success')
//           GestureDetector(
//             onTap: () {
//               repeatTransaction(context, widget.transaction.id);
//             },
//             child:
//                 buildActionButton('Repeat', AppIcons.reload, repeatTransaction),
//           ),
//         buildActionButton('Report', AppIcons.infoOutlined, () {}),
//       ],
//     );
//   }
//
//   Widget buildActionButton(String label, String icon, Function onTap) {
//     return Column(
//       children: [
//         Container(
//           height: 40,
//           width: 40,
//           decoration: BoxDecoration(
//             color: const Color(0xffF3FFEB),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Center(
//             child: SvgPicture.asset(icon, color: AppColors.darkGreen),
//           ),
//         ),
//         const SizedBox(height: 5),
//         CustomText(
//           text: label,
//           size: 12,
//           color: AppColors.darkGreen,
//           weight: FontWeight.bold,
//         ),
//       ],
//     );
//   }
//
//   Widget buildFooter() {
//     return Column(
//       children: [
//         const CustomText(
//           text: 'Thank You!',
//           textAlign: TextAlign.center,
//           size: 14,
//         ),
//         const CustomText(
//           text: 'For Your Purchase',
//           textAlign: TextAlign.center,
//           size: 14,
//         ),
//         const SizedBox(height: 20),
//         const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.lock, color: AppColors.green),
//             CustomText(
//               text: 'Secured by TellaTrust',
//               textAlign: TextAlign.center,
//               size: 14,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   String getCurrentDate() {
//     return DateFormat('_yyyyMMdd_kkmmss').format(DateTime.now());
//   }
//
//   Future<void> pdfShare(BuildContext context, String title) async {
//     final plugin = DeviceInfoPlugin();
//     final android = await plugin.androidInfo;
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (_) => const LoadingDialog('Preparing to share...'),
//     );
//     final storageStatus = android.version.sdkInt < 33
//         ? await Permission.storage.request()
//         : PermissionStatus.granted;
//
//     if (storageStatus == PermissionStatus.granted) {
//       setState(() {
//         isSharingPdf = true;
//       });
//
//       var freeSpace = await DiskSpace.getFreeDiskSpace;
//       if (freeSpace != null && freeSpace > 10.00) {
//         await screenshotController
//             .capture(delay: const Duration(milliseconds: 5))
//             .then((Uint8List? image) async {
//           if (image != null) {
//             var path = await ExternalPath.getExternalStoragePublicDirectory(
//                 ExternalPath.DIRECTORY_DOWNLOADS);
//
//             // Ensure directory exists
//             final directory = Directory(path);
//             if (!directory.existsSync()) {
//               directory.createSync(recursive: true);
//             }
//
//             final imagePath =
//                 await File('$path/${title + getCurrentDate()}.png')
//                     .create(recursive: true);
//             await imagePath.writeAsBytes(image);
//
//             final Uint8List imageData = File(imagePath.path).readAsBytesSync();
//             final PdfBitmap pdfBitmap = PdfBitmap(imageData);
//
//             final PdfDocument document = PdfDocument();
//             final PdfPage page = document.pages.add();
//             final Size pageSize = page.getClientSize();
//             page.graphics.drawImage(pdfBitmap,
//                 Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));
//
//             var pdfPath = '$path/${title + getCurrentDate()}.pdf';
//             await File(pdfPath).writeAsBytes(await document.save());
//             document.dispose();
//
//             final targetFile = File(imagePath.path);
//             if (targetFile.existsSync()) {
//               targetFile.deleteSync(recursive: true);
//             }
//
//             await Share.shareXFiles([
//               XFile(pdfPath,
//                   mimeType: 'application/pdf',
//                   name: '${title + getCurrentDate()}.pdf')
//             ]);
//
//             final targetFile2 = File(pdfPath);
//             if (targetFile2.existsSync()) {
//               targetFile2.deleteSync(recursive: true);
//             }
//
//             setState(() {
//               Navigator.pop(context);
//               isSharingPdf = false;
//             });
//           }
//         });
//       } else {
//         Navigator.pop(context);
//         setState(() {
//           isSharingPdf = false;
//         });
//         showToast(
//           context: context,
//           title: 'Error occurred',
//           subtitle: 'Inadequate space on disk',
//           type: ToastMessageType.error,
//         );
//       }
//     } else {
//       Navigator.pop(context);
//       setState(() {
//         isSharingPdf = false;
//       });
//       showToast(
//         context: context,
//         title: "Permission required",
//         subtitle: 'Permission was denied',
//         type: ToastMessageType.info,
//       );
//     }
//   }
//
//   Future<void> repeatTransaction(
//       BuildContext context, String transactionId) async {
//     AppRepository appRepository = AppRepository();
//
//     try {
//       showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (_) => const LoadingDialog('Preparing to repeat...'),
//       );
//       String accessToken = await SharedPref.getString("access-token");
//
//       var response = await appRepository.appGetRequest(
//           accessToken: accessToken,
//           "${AppApis.getOneTransactionDetails}/$transactionId");
//       print(response.statusCode);
//       print(response.body);
//       print(json.decode(response.body));
//     } catch (e) {
//       setState(() {
//         isSharingPdf = false;
//         Navigator.pop(context);
//       });
//       showToast(
//         context: context,
//         title: 'Error occurred',
//         subtitle: 'An unexpected error has occurred, try again later',
//         type: ToastMessageType.error,
//       );
//     }
//   }
//
//   Future<void> pdfDownload(BuildContext context, String title) async {
//     try {
//       setState(() {
//         isSharingPdf = true;
//       });
//       showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (_) => const LoadingDialog('Preparing to download...'),
//       );
//       final plugin = DeviceInfoPlugin();
//       final android = await plugin.androidInfo;
//
//       final storageStatus = android.version.sdkInt < 33
//           ? await Permission.storage.request()
//           : PermissionStatus.granted;
//       if (storageStatus == PermissionStatus.granted) {
//         setState(() {
//           isSharingPdf = true;
//         });
//
//         var freeSpace = await DiskSpace.getFreeDiskSpace;
//         if (freeSpace != null && freeSpace > 10.00) {
//           await screenshotController
//               .capture(delay: const Duration(milliseconds: 5))
//               .then((Uint8List? image) async {
//             if (image != null) {
//               var path = await ExternalPath.getExternalStoragePublicDirectory(
//                   ExternalPath.DIRECTORY_DOWNLOADS);
//
//               final imagePath =
//                   await File('$path/${title + getCurrentDate()}.png').create();
//               await imagePath.writeAsBytes(image);
//
//               final Uint8List imageData =
//                   File(imagePath.path).readAsBytesSync();
//               final PdfBitmap pdfBitmap = PdfBitmap(imageData);
//
//               final PdfDocument document = PdfDocument();
//               final PdfPage page = document.pages.add();
//               final Size pageSize = page.getClientSize();
//               page.graphics.drawImage(pdfBitmap,
//                   Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));
//
//               var pdfPath = '$path/${title + getCurrentDate()}.pdf';
//               await File(pdfPath).writeAsBytes(await document.save());
//               document.dispose();
//
//               final targetFile = File(imagePath.path);
//               if (targetFile.existsSync()) {
//                 targetFile.deleteSync(recursive: true);
//               }
//
//               setState(() {
//                 isSharingPdf = false;
//                 Navigator.pop(context);
//               });
//               showToast(
//                 context: context,
//                 title: 'Download Successful',
//                 subtitle: 'View PDF in downloads',
//                 type: ToastMessageType.success,
//               );
//             }
//           });
//         } else {
//           setState(() {
//             isSharingPdf = false;
//             Navigator.pop(context);
//           });
//           showToast(
//             context: context,
//             title: 'Error occurred',
//             subtitle: 'Inadequate space on disk',
//             type: ToastMessageType.error,
//           );
//         }
//       } else {
//         setState(() {
//           isSharingPdf = false;
//           Navigator.pop(context);
//         });
//         showToast(
//           context: context,
//           title: "Permission required",
//           subtitle: 'Permission was denied',
//           type: ToastMessageType.info,
//         );
//       }
//     } catch (e) {
//       setState(() {
//         isSharingPdf = false;
//         Navigator.pop(context);
//       });
//       showToast(
//         context: context,
//         title: 'Error occurred',
//         subtitle: 'An unexpected error has occurred, try again later',
//         type: ToastMessageType.error,
//       );
//     }
//   }
// }
