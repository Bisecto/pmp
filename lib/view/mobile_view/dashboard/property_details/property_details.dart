import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pim/res/app_svg_images.dart';
import 'package:pim/view/widgets/app_bar.dart';
import 'package:pim/view/widgets/app_custom_text.dart';
import 'package:pim/view/widgets/form_button.dart';

import '../../../../res/app_colors.dart';
import '../../../../utills/app_utils.dart';
import 'occupant_list.dart';

class PropertyDetails extends StatefulWidget {
  final String title;

  const PropertyDetails({super.key, required this.title});

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
                AppAppBar(title: widget.title),
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
                lodgeContainer(lodge: widget.title, context: context),
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
                          child: const Center(
                              child: CustomText(
                            text: "Fully Booked",
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
                          child: const Center(
                              child: CustomText(
                            text: "0",
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
                        const SizedBox(width: 10,),
                        Container(
                          height: 45,
                          width: AppUtils.deviceScreenSize(context).width / 3,
                          decoration: BoxDecoration(
                              color: AppColors.blue,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_box,color: AppColors.white,),
                              CustomText(
                                text: " Add occupant",
                                color: AppColors.white,
                                weight: FontWeight.bold,
                              ),
                            ],
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

  Widget lodgeContainer({required String lodge, required context}) {
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
                  image: const DecorationImage(
                      image: NetworkImage(
                        "https://images.crowdspring.com/blog/wp-content/uploads/2017/08/23163415/pexels-binyamin-mellish-106399.jpg",
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
                      textValue: "NGN 200,000",
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
