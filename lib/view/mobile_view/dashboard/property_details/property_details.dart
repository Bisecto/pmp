import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pim/res/app_svg_images.dart';
import 'package:pim/utills/app_navigator.dart';
import 'package:pim/view/mobile_view/add_occupant/add_occupant.dart';
import 'package:pim/view/widgets/app_bar.dart';
import 'package:pim/view/widgets/app_custom_text.dart';
import 'package:pim/view/widgets/form_button.dart';

import '../../../../model/property_model.dart';
import '../../../../res/apis.dart';
import '../../../../res/app_colors.dart';
import '../../../../utills/app_utils.dart';
import 'occupant_list.dart';

class PropertyDetails extends StatefulWidget {
  final Property property;

  const PropertyDetails({super.key, required this.property});

  @override
  State<PropertyDetails> createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
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
                AppAppBar(title: widget.property.propertyName),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "Property Details",
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
                lodgeContainer(property: widget.property, context: context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "Status",
                          size: 18,
                          weight: FontWeight.w600,
                        ),
                        Container(
                          height: 45,
                          width: AppUtils.deviceScreenSize(context).width / 2.5,
                          decoration: BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: CustomText(
                            text: widget.property.availableFlatsRooms == 0
                                ? "Fully Booked"
                                : "Not Fully Booked",
                            color: AppColors.white,
                            weight: FontWeight.bold,
                          )),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "Available rooms",
                          size: 18,
                          weight: FontWeight.w600,
                        ),
                        Container(
                          height: 45,
                          width: AppUtils.deviceScreenSize(context).width / 2.5,
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                              child: CustomText(
                            text: "${widget.property.availableFlatsRooms}",
                            color: AppColors.black,
                            weight: FontWeight.bold,
                          )),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "Occupants",
                      size: 18,
                      weight: FontWeight.w600,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(AppSvgImages.download),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            AppNavigator.pushAndStackPage(context,
                                page: AddOccupantScreen());
                          },
                          child: Container(
                            height: 45,
                            width: AppUtils.deviceScreenSize(context).width / 3,
                            decoration: BoxDecoration(
                                color: AppColors.blue,
                                borderRadius: BorderRadius.circular(5)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_box,
                                  color: AppColors.white,
                                ),
                                CustomText(
                                  text: " Add occupant",
                                  color: AppColors.white,
                                  weight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                OccupantList()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget lodgeContainer({required Property property, required context}) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 250,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          // color: AppColors.white,

          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 200,
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
                  image: DecorationImage(
                      image: NetworkImage(
                        AppApis.appBaseUrl + property.firstImage,
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.red,
                        ),
                        CustomText(text: 'Dublin,ireland', size: 14),
                      ],
                    ),
                    TextStyles.textHeadings(
                      textValue: "NGN ${property.price}",
                      textSize: 18,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
