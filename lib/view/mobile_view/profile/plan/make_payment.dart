import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pim/model/current_plan_model.dart';
import 'package:pim/model/initialize_plan_model.dart';
import 'package:pim/model/user_model.dart';
import 'package:pim/view/mobile_view/profile/plan/payment_success.dart';
import 'package:pim/view/widgets/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../res/app_colors.dart';
import '../../../../../utills/app_navigator.dart';
import '../../../../repository/repository.dart';
import '../../../../utills/app_utils.dart';
import '../../../../utills/shared_preferences.dart';
import '../../../important_pages/not_found_page.dart';
import '../../../widgets/app_custom_text.dart';
import '../../landing_page.dart';

class MakePayment extends StatefulWidget {
  final InitializeModel initializeModel;
  final CurrentPlan currentPlan;
  final UserModel userModel;

  MakePayment({
    super.key,
    required this.initializeModel,
    required this.currentPlan,
    required this.userModel,
  });

  @override
  State<MakePayment> createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  late final WebViewController _webViewController;
  var loadingPercentage = 0;
  bool isConfirmLoading = false;
  bool isPaymentSuccess = false;

  @override
  void initState() {
    // TODO: implement initState
    //if (Platform.isAndroid) WebView.platform = AndroidWebView();
    _webViewController = WebViewController()
      ..loadRequest(Uri.parse(widget.initializeModel.authorizationUrl!))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..currentUrl()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onUrlChange: (url) {
            AppUtils().debuglog(url);
            AppUtils().debuglog(url);
            AppUtils().debuglog(url);
            AppUtils().debuglog(url);
            AppUtils().debuglog(url);
            AppUtils().debuglog(url);
            AppUtils().debuglog(url);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            AppUtils().debuglog(123456789);
            AppUtils().debuglog(123456789);
            AppUtils().debuglog(123456789);
            AppUtils().debuglog(123456789);
            AppUtils().debuglog(request.url);
            AppUtils().debuglog(request.url);
            AppUtils().debuglog(request.url);
            AppUtils().debuglog(request.url);
            AppUtils().debuglog(request.url);
            AppUtils().debuglog(request.url);
            AppUtils().debuglog(request.url);
            AppUtils().debuglog(request.url);
            AppUtils().debuglog(request.url);
            AppUtils().debuglog(123456789);
            AppUtils().debuglog(123456789);
            AppUtils().debuglog(123456789);
            AppUtils().debuglog(123456789);
            AppUtils().debuglog(NavigationDecision.values);

            AppUtils().debuglog(request.url);
            AppUtils().debuglog(request.url);
            AppUtils().debuglog(request.url);
            AppUtils().debuglog(request.url);
            AppUtils().debuglog(request.url);
            AppUtils().debuglog(request.url);
            AppUtils().debuglog(request.url);
            AppUtils().debuglog(request.url);

            if (request.url.toLowerCase().contains(
                "https://property.appleadng.net/api/subscription/payment/callback/?reference=")) {
              AppUtils().debuglog("12345678976543234567");

              AppRepository appRepository = AppRepository();
              try {
                String accessToken = await SharedPref.getString('access-token');

                final verifyPayment = await appRepository.postRequestWithToken(
                    accessToken,
                    {"reference": widget.initializeModel.reference},
                    "https://property.appleadng.net/api/subscription/payment/verify/");
                AppUtils().debuglog("12345678976543234567");

                AppUtils().debuglog(verifyPayment.statusCode);
                AppUtils().debuglog(verifyPayment.body);
                if (verifyPayment.statusCode == 200 ||
                    verifyPayment.statusCode == 201) {
                  setState(() {
                    isPaymentSuccess = true;
                  });
                } else if (verifyPayment.statusCode == 401) {
                  //emit(AccessTokenExpireState());
                } else {
                  // emit(ErrorState(json.decode(paymentInitResponse.body)['detail'] ??
                  //     json.decode(paymentInitResponse.body)['error']));
                  //AppUtils().debuglog(event.password);
                  AppUtils().debuglog(json.decode(verifyPayment.body));
                }
              } catch (e) {
                AppUtils().debuglog(e);
              }
              // Navigator.of(context).pop();
              // return NavigationDecision.prevent;
            }
            if (request.url == "https://hello.pstk.xyz/callback") {
              AppUtils().debuglog("reference");
              //verifyTransaction(reference);
              Navigator.of(context).pop(); //close webview
            }
            if (request.url == "https://www.google.com/") {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    //..loadRequest(Uri.parse('https://flutter.dev'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isPaymentSuccess
        ? TransactionSuccessful(
            buttonText: 'Go To Dashboard',
            successfulText:
                'Plan was successfully  change from ${widget.currentPlan.plan!.displayName} to ${widget.initializeModel.plan}',
            buttonAction: () {
              AppNavigator.pushAndRemovePreviousPages(context,
                  page: LandingPage(
                    selectedIndex: 0,
                    userModel: widget.userModel,
                    currentPlan: widget.currentPlan,
                  ));
            },
          )
        : Scaffold(
            backgroundColor: AppColors.white,
            // appBar: AppBar(
            //   automaticallyImplyLeading: false,
            //   centerTitle: true,
            //   title: const CustomText(
            //     text: 'Make payment',
            //     color: AppColors.white,
            //     size: 16,
            //   ),
            //   backgroundColor: AppColors.mainAppColor,
            //   leading: GestureDetector(
            //       onTap: () {
            //         // if (widget.isFromModal) {
            //         //   Navigator.pop(context);
            //         // }
            //
            //         Navigator.pop(context);
            //       },
            //       child: const Icon(
            //         Icons.arrow_back,
            //         color: AppColors.white,
            //       )),
            // ),
            body: Padding(
                padding: const EdgeInsets.fromLTRB(15,25.0,10,15),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppAppBar(title: "Make Payment"),
                      SizedBox(
                        height: AppUtils.deviceScreenSize(context).height / 1.5,
                        child: WebViewWidget(
                          controller: _webViewController,
                        ),
                      ),
                      if (loadingPercentage < 100)
                        const Center(
                            child: AppLoadingPage("Initializing Payment...")),
                      // if (loadingPercentage > 99)
                      //   Container(
                      //     color: AppColors.white,
                      //     // height: AppUtils.deviceScreenSize(context).height / 1.7,
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.end,
                      //       children: [
                      //
                      //         const CustomText(
                      //           text:
                      //           "Click the button below once your payment is completed to confirm your payment. Your prompt action is appreciated.",
                      //           size: 14,
                      //           weight: FontWeight.w400,
                      //           maxLines: 3,
                      //           textAlign: TextAlign.center,
                      //         ),
                      //         FormButton(
                      //            onPressed: () async {},
                      //           //   //AppUtils().debuglog(widget.orderModel.id);
                      //           //   setState(() {
                      //           //     isConfirmLoading = true;
                      //           //   });
                      //           //   try {
                      //           //     //String cookie =
                      //           //     //await SharedPref.getString('user_login_cookie');
                      //           //     String accessToken = await SharedPref.getString('access-token');
                      //           //     Map<String, dynamic> formData = {
                      //           //       'is_candidate': false,
                      //           //       //'otp': event.otp,
                      //           //     };
                      //           //     AppRepository appRepository=AppRepository();
                      //           //     final response =await appRepository.postRequestWithToken(accessToken, formData, "${AppApis.appBaseUrl}/fee/verify-school-fees-payment/${widget.studentProfile.id}/${widget.paymentInitializationResponse.credoReference}/");
                      //           //
                      //           //     // final response = await orderRepository.startOrder(
                      //           //     //     widget.orderModel.id, cookie);
                      //           //     AppUtils().debuglog(response.statusCode);
                      //           //     AppUtils().debuglog(json.decode(response.body));
                      //           //     if (response.statusCode == 200 ||
                      //           //         response.statusCode == 201) {
                      //           //       // OrderModel orderModel =
                      //           //       // OrderModel.fromJson(json.decode(response.body));
                      //           //
                      //           //     } else {
                      //           //       if (mounted) {
                      //           //         setState(() {
                      //           //           isConfirmLoading = false;
                      //           //         });
                      //           //       }
                      //           //
                      //           //       MSG.warningSnackBar(context,
                      //           //           "There was a problem confirming payment. Please Confirm if payment was successful and try again. Thanks. ");
                      //           //     }
                      //           //   } catch (e) {
                      //           //     setState(() {
                      //           //       isConfirmLoading = false;
                      //           //     });
                      //           //     AppUtils().debuglog('cached Error');
                      //           //     AppUtils().debuglog(e);
                      //           //     AppUtils().debuglog(e);
                      //           //   }
                      //           //   //AppNavigator.pushAndStackPage(context, page: MakePayment( orderModel: widget.orderModel,))
                      //           // },
                      //           borderRadius: 30,
                      //           height: 50,
                      //           bgColor: AppColors.mainAppColor,
                      //           disableButton: isConfirmLoading,
                      //           text: isConfirmLoading
                      //               ? "Loading... Please wait"
                      //               : "Confirm payment",
                      //         ),
                      //         SizedBox(
                      //           height: 10,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                    ],
                  ),
                )),
          );
  }
}
