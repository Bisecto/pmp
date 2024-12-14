import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pim/res/app_images.dart';
import 'package:pim/res/app_svg_images.dart';
import 'package:pim/utills/app_navigator.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/property_details.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/view_occupant.dart';

import '../../../../res/app_colors.dart';
import '../../../../utills/app_utils.dart';
import '../../../widgets/app_custom_text.dart';

class OccupantList extends StatelessWidget {
  OccupantList({super.key});

  final List<String> occupants = [
    'Occupant 1',
    'Occupant 2',
    'Occupant 3',
    'Occupant 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: occupants.length * 150,
      child: ListView.builder(
        itemCount: occupants.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              AppNavigator.pushAndStackPage(context,
                  page: ViewOccupant(occupantName: occupants[index]));
            },
            child:
                occupantContainer(occupant: occupants[index], context: context),
          );
        },
      ),
    );
  }

  Widget occupantContainer({required String occupant, required context}) {
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
                        Image.asset(
                          AppImages.person,
                          height: 50,
                          width: 50,
                        ),
                        TextStyles.textHeadings(
                          textValue: "  " + occupant,
                          textSize: 18,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(AppSvgImages.phone),
                        const SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset(AppSvgImages.message),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(Icons.more_vert)
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: "Room Number:",
                          color: AppColors.black,
                          weight: FontWeight.bold,
                        ),
                        CustomText(
                          text: ' B12  ',
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
                          weight: FontWeight.bold,
                        ),
                        CustomText(
                          text: '  35',
                          size: 14,
                          maxLines: 3,
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
}
