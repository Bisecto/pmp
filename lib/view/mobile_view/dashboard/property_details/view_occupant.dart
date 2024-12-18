import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pim/res/apis.dart';
import 'package:pim/res/app_colors.dart';
import 'package:pim/view/widgets/form_button.dart';

import '../../../../model/property_model.dart';
import '../../../../res/app_images.dart';
import '../../../../res/app_svg_images.dart';
import '../../../../utills/app_utils.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_custom_text.dart';

class ViewOccupant extends StatefulWidget {
  final Occupant occupant;

  const ViewOccupant({super.key, required this.occupant});

  @override
  State<ViewOccupant> createState() => _ViewOccupantState();
}

class _ViewOccupantState extends State<ViewOccupant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppAppBar(title: widget.occupant.name!),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "Occupant Details",
                      size: 18,
                      weight: FontWeight.w700,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(AppSvgImages.edit),
                        //const Icon(Icons.edit),
                        const SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset(AppSvgImages.delete),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                FormButton(
                  onPressed: () {},
                  text: "Download",
                  isIcon: true,
                  borderRadius: 10,
                  bgColor: AppColors.blue,
                  iconWidget: Icons.download,
                ),
                const SizedBox(
                  height: 15,
                ),
                profileContainer(widget.occupant,context: context),
                const SizedBox(
                  height: 15,
                ),
                moreDetailsContainer(widget.occupant,context: context)

              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget profileContainer(Occupant  occupant,{required context}) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 350,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.2),

          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 250,
                width: AppUtils.deviceScreenSize(context).width,
                decoration: BoxDecoration(
                  //color: AppColors.red,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.15),
                  //     spreadRadius: 0,
                  //     blurRadius: 10,
                  //     offset: const Offset(0, 4),
                  //   ),
                  // ],
                  image:   DecorationImage(
                      image: NetworkImage(
                        AppApis.appBaseUrl+occupant.profilePic!,
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: occupant.name,
                    color: AppColors.black,
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                  CustomText(
                    text: '✅ Active  ',
                    size: 14,
                    weight: FontWeight.bold,

                  ),
                ],
              ),

              const SizedBox(
                height: 10,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomText(
                        text: "Marital status:",
                        color: AppColors.black,
                        size: 13,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: ' ${occupant.relationship}  ',
                        size: 13,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: "Employment Status:",
                        color: AppColors.black,
                        size: 13,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: '  ${occupant.occupationStatus}',
                        size: 13,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
  Widget moreDetailsContainer(Occupant  occupant,{required context}) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.2),

          borderRadius: BorderRadius.circular(10),
        ),
        child:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomText(
                        text: "Room Number:",
                        color: AppColors.black,
                        size: 14,
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
                      CustomText(
                        text: "Rent Due In:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: '  2nd Jan,2025.',
                        size: 14,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomText(
                        text: "DOB:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: ' ${AppUtils.formateSimpleDate(dateTime:occupant.dob.toString())}  ',
                        size: 14,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: "Gender:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: '  ${occupant.gender}',
                        size: 14,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomText(
                        text: "LGA:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: ' ${occupant.localGovernment}  ',
                        size: 14,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: "State:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: '  ${occupant.state}',
                        size: 14,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

}
