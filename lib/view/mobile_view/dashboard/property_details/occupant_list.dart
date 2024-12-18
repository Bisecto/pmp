import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pim/model/property_model.dart';
import 'package:pim/res/apis.dart';
import 'package:pim/res/app_images.dart';
import 'package:pim/res/app_svg_images.dart';
import 'package:pim/utills/app_navigator.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/property_details.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/view_occupant.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../res/app_colors.dart';
import '../../../../utills/app_utils.dart';
import '../../../widgets/app_custom_text.dart';

class OccupantList extends StatefulWidget {
  OccupantList({super.key, required this.occupants});

  final List<Occupant> occupants;

  @override
  State<OccupantList> createState() => _OccupantListState();
}

class _OccupantListState extends State<OccupantList> {
  @override
  void initState() {
    // TODO: implement initState
    print(AppApis.appBaseUrl + widget.occupants[0].profilePic);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.occupants.length * 150,
      child: ListView.builder(
        itemCount: widget.occupants.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              AppNavigator.pushAndStackPage(context,
                  page: ViewOccupant(occupant: widget.occupants[index]));
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
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120,
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
                        Image.network(
                          AppApis.appBaseUrl + occupant.profilePic,
                          height: 50,
                          width: 50,
                        ),
                        TextStyles.textHeadings(
                          textValue: "  ${occupant.name}",
                          textSize: 18,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              _makePhoneCall(occupant.mobileNumber);
                            },
                            child: SvgPicture.asset(AppSvgImages.phone)),
                        const SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset(AppSvgImages.message),
                        GestureDetector(
                          onTap: () {
                            _sendSMS(occupant.mobileNumber, '');
                          },
                          child: const SizedBox(
                            width: 10,
                          ),
                        ),
                        //const Icon(Icons.more_vert)
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CustomText(
                          text: "Room Number:",
                          color: AppColors.black,
                          weight: FontWeight.bold,
                        ),
                        CustomText(
                          text: ' ${occupant.roomNumber}  ',
                          size: 14,
                          maxLines: 3,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const CustomText(
                          text: "Rent Due In:",
                          color: AppColors.black,
                          weight: FontWeight.bold,
                        ),
                        Container(
                          width: AppUtils.deviceScreenSize(context).width/2.5,
                          child: CustomText(
                            text:
                                '  ${getCountdownText(occupant.rentDueDate.toString())}',
                            size: 14,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ],
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
      return "${difference.inDays} days, ${difference.inHours.remainder(24)} hours, and ${difference.inMinutes.remainder(60)} minutes left";
    }
  }

  Future<void> _sendSMS(String phoneNumber, String message) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message},
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Could not launch $smsUri';
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri.parse(phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  String countdownText = "";
}
