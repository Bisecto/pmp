import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import '../../../../res/app_colors.dart';
import '../../../widgets/custom_container.dart';



class TransactionSuccessful extends StatelessWidget {
  final String? bargeLink;
  final String? successfulText;
  final String? paymentlink;
  final String buttonText;
  final dynamic buttonAction;

  TransactionSuccessful(
      {Key? key,
        this.bargeLink,
        this.paymentlink,
        this.successfulText,
        this.buttonText = "Okay",
        this.buttonAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: Container(
        //margin: Tools.generalMargin,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child:
                    SvgPicture.asset(bargeLink ?? "assets/svg_images/success.svg"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 230,
                    child: Text(
                      successfulText ?? "Transaction Successful!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (paymentlink != null)
                    SizedBox(
                      width: 230,
                      child: Text(
                        paymentlink ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  if (paymentlink != null)
                    Row(
                      children: [
                        Icon(
                          Icons.copy,
                          size: 30,
                        ),
                        Text(
                          'Copy',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
              Positioned(
                bottom: 40,
                right: 0,
                left: 0,
                child: ElevatedButton(
                  onPressed: buttonAction ??
                          () {
                        Navigator.pop(context);
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainAppColor,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(buttonText),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
