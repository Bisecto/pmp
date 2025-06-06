import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pim/bloc/property_bloc/property_bloc.dart';
import 'package:pim/model/property_model.dart';
import 'package:pim/res/apis.dart';
import 'package:pim/res/app_images.dart';
import 'package:pim/res/app_svg_images.dart';
import 'package:pim/utills/app_navigator.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/property_details.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/view_occupant.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../model/user_model.dart';
import '../../../../../../res/app_colors.dart';
import '../../../../../../utills/app_utils.dart';
import '../../../../../widgets/app_custom_text.dart';
import '../../countdown_function.dart';

class OccupantList extends StatefulWidget {
  final Property property;
  final UserModel userModel;
  final PropertyBloc propertyBloc;

  OccupantList(
      {super.key,
      required this.occupants,
      required this.property,
      required this.userModel,
      required this.propertyBloc});

  final List<Occupant> occupants;

  @override
  State<OccupantList> createState() => _OccupantListState();
}

class _OccupantListState extends State<OccupantList> {
  @override
  void initState() {
    // TODO: implement initState
    AppUtils().debuglog(AppApis.appBaseUrl + widget.occupants[0].profilePic);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.occupants.length * 150,
      child: ListView.builder(
        itemCount: widget.occupants.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              //AppUtils().debuglog(widget.occupants[index].rentExpirationDate.toString());

              bool isDelete = await AppNavigator.pushAndStackPage(context,
                  page: ViewOccupant(
                    occupant: widget.occupants[index],
                    property: widget.property,
                    userModel: widget.userModel, occpuantId: widget.occupants[index].id,
                  ))??false;
              if (isDelete) {
                widget.propertyBloc
                    .add(GetSinglePropertyEvent(widget.property.id.toString()));
              }
            },
            child: occupantContainer(
                occupant: widget.occupants[index], context: context),
          );
        },
      ),
    );
  }

  Widget occupantContainer({required Occupant occupant, required context}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 3, left: 3),
      child: Container(
        height: 135,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            occupant.profilePic,
                          ),
                          //radius: 20,
                        ),
                        // Image.network(),
                        Container(
                          width: 150,
                          child: CustomText(
                            text: "  ${occupant.fullName}",
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              _makePhoneCall(occupant.mobilePhone);
                            },
                            child: SvgPicture.asset(
                              AppSvgImages.phone,
                              height: 25,
                              width: 25,
                            )),
                        const SizedBox(
                          width: 10,
                        ),

                        GestureDetector(
                          onTap: () async {
                            //_sendSMS(occupant.mobileNumber, '');
                            try {
                              await openSMS(
                                phone: occupant.mobilePhone,
                                text: '',
                              );
                            } on Exception catch (e) {
                              showDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                        title: CustomText(text: "Attention"),
                                        content: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            'We did not find the «SMS Messenger» application on your phone, please install it and try again»',
                                            style: context
                                                .theme.textTheme.labelSmall
                                                ?.copyWith(
                                              height: 1.1,
                                              color: context.theme.textTheme
                                                  .bodyLarge?.color,
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: Text('Close'),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ));
                            }
                          },
                          child: SvgPicture.asset(AppSvgImages.message,
                              height: 25, width: 25),
                        ),
                        //const Icon(Icons.more_vert)
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: AppUtils.deviceScreenSize(context).width,
                height: 75,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CustomText(
                            text: "Room Number:",
                            color: AppColors.black,
                            weight: FontWeight.w600,
                            size: 12,
                          ),
                          CustomText(
                            text: ' ${occupant.spaceNumber}  ',
                            size: 12,
                            maxLines: 3,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: AppUtils.deviceScreenSize(context).width / 3,
                        //height: 100,
                        child: CountdownWidget(
                          targetDate: DateTime.parse(
                              occupant.rentExpirationDate.toString()),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String getCountdownText(String targetDateString) {
    DateTime targetDate = DateTime.parse(targetDateString);
    DateTime now = DateTime.now();

    Duration difference = targetDate.difference(now);

    if (difference.isNegative) {
      return "Countdown has expired!";
    } else {
      return "${difference.inDays} days" // ${difference.inHours.remainder(24)} hours, and ${difference.inMinutes.remainder(60)} minutes left"
          ;
    }
  }

  Future<void> openSMS({
    required String phone,
    String? text,
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final String effectivePhone;
    if (Platform.isAndroid) {
      effectivePhone = phone.replaceAll('-', ' ');
    } else {
      effectivePhone = phone.replaceFirst('+', '');
    }

    final String effectiveText =
        Platform.isAndroid ? '?body=$text' : '&body=$text';

    final String url = 'sms:$effectivePhone';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse('$url$effectiveText'), mode: mode);
    } else {
      throw Exception('openSMS could not launching url: $url');
    }
  }

  // Future<void> _sendSMS(String phoneNumber, String message) async {
  //   final Uri smsUri = Uri(
  //     scheme: 'sms',
  //     path: phoneNumber,
  //     queryParameters: {'body': message},
  //   );
  //
  //   AppUtils().debuglog('Attempting to launch: $smsUri');
  //
  //   if (await canLaunchUrl(smsUri)) {
  //     try {
  //       await launchUrl(smsUri);
  //       AppUtils().debuglog('SMS sent successfully.');
  //     } catch (e) {
  //       AppUtils().debuglog('Error launching SMS URL: $e');
  //     }
  //   } else {
  //     AppUtils().debuglog('Could not launch SMS URL: $smsUri');
  //     throw 'Could not launch $smsUri';
  //   }
  // }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  String countdownText = "";
}
