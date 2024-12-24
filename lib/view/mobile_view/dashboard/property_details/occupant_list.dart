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

import '../../../../model/user_model.dart';
import '../../../../res/app_colors.dart';
import '../../../../utills/app_utils.dart';
import '../../../widgets/app_custom_text.dart';
import 'countdown_function.dart';

class OccupantList extends StatefulWidget {
  final Property property;
  final UserModel userModel;

  OccupantList({super.key, required this.occupants, required this.property, required this.userModel});

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
    return SizedBox(
      height: widget.occupants.length * 162,
      child: ListView.builder(
        itemCount: widget.occupants.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {print(widget.occupants[index].rentDueDate.toString());
              AppNavigator.pushAndStackPage(context,
                  page: ViewOccupant(occupant: widget.occupants[index],
                    property: widget.property,
                    userModel: widget.userModel,));
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
      padding: const EdgeInsets.only(bottom: 10,right: 3,left: 3),
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
                            text: "  ${occupant.name}",
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              _makePhoneCall(occupant.mobileNumber);
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
                          onTap: () {
                            _sendSMS(occupant.mobileNumber, '');
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
                width: AppUtils
                    .deviceScreenSize(context)
                    .width,
                height: 75,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
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
                            text: ' ${occupant.roomNumber}  ',
                            size: 12,
                            maxLines: 3,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: AppUtils
                            .deviceScreenSize(context)
                            .width / 3,
                        //height: 100,
                        child: CountdownWidget(
                          targetDate:
                          DateTime.parse(occupant.rentDueDate.toString()),
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
      return "${difference
          .inDays} days" // ${difference.inHours.remainder(24)} hours, and ${difference.inMinutes.remainder(60)} minutes left"
          ;
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
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  String countdownText = "";
}
