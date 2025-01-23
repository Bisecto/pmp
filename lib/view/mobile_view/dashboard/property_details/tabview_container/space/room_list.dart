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
import 'package:pim/view/mobile_view/dashboard/property_details/tabview_container/space/space_details.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../model/space_model.dart';
import '../../../../../../model/user_model.dart';
import '../../../../../../res/app_colors.dart';
import '../../../../../../utills/app_utils.dart';
import '../../../../../widgets/app_custom_text.dart';
import '../../countdown_function.dart';

class SpaceList extends StatefulWidget {
  final Property property;
  final UserModel userModel;
  final PropertyBloc propertyBloc;

  SpaceList({super.key,
    required this.spaces,
    required this.property,
    required this.userModel,
    required this.propertyBloc});

  final List<Space> spaces;

  @override
  State<SpaceList> createState() => _SpaceListState();
}

class _SpaceListState extends State<SpaceList> {
  @override
  void initState() {
    // TODO: implement initState
    AppUtils().debuglog(AppApis.appBaseUrl + widget.property.firstImage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.spaces.length * 123,
      child: ListView.builder(
        itemCount: widget.spaces.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              AppNavigator.pushAndStackPage(context, page: SpaceDetails(
                  space: widget.spaces[index],
                  userModel: widget.userModel,
                  property: widget.property));
            },
            child: spaceContainer(
                space: widget.spaces[index], context: context),
          );
        },
      ),
    );
  }

  Widget spaceContainer({required Space space, required context}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 3, left: 3),
      child: Container(
        height: 110,
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
                            AppApis.appBaseUrl + widget.property.firstImage,
                          ),
                          //radius: 20,
                        ),
                        // Image.network(),
                        Container(
                          width: 150,
                          child: CustomText(
                            text: "  ${space.spaceNumber}",
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: AppUtils
                    .deviceScreenSize(context)
                    .width,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CustomText(
                            text: "Room Type:",
                            color: AppColors.black,
                            weight: FontWeight.w600,
                            size: 12,
                          ),
                          CustomText(
                            text: ' ${space.spaceType}  ',
                            size: 12,
                            maxLines: 3,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const CustomText(
                            text: "Price:",
                            color: AppColors.black,
                            weight: FontWeight.w600,
                            size: 12,
                          ),
                          CustomText(
                            text: ' NGN${space.price}  ',
                            size: 12,
                            maxLines: 3,
                          ),
                        ],
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


}
