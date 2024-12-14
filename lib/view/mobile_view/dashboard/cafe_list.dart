import 'package:flutter/material.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/property_details.dart';

import '../../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../widgets/app_custom_text.dart';

class LodgeList extends StatelessWidget {
  LodgeList({super.key});

  final List<String> lodges = [
    'Ozo Lodge 1',
    'Ozo Lodge 2',
    'Ozo Lodge 3',
    'Ozo Lodge 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: lodges.length * 351,
      child: ListView.builder(
        itemCount: lodges.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return lodgeContainer(lodge: lodges[index], context: context);
        },
      ),
    );
  }

  Widget lodgeContainer({required String lodge, required context}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 335,
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
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 180,
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextStyles.textHeadings(
                      textValue: lodge,
                      textSize: 18,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: AppColors.red,
                          ),
                          CustomText(text: 'Dublin,ireland', size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: AppUtils.deviceScreenSize(context).width / 2.5,
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

                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.cabin_rounded,
                                color: Colors.purple,
                              ),
                              CustomText(
                                text: ' 19  ',
                                size: 14,
                                maxLines: 3,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                color: Colors.green,
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
                    ),
                    GestureDetector(
                      onTap: () {
                        AppNavigator.pushAndStackPage(context,
                            page: PropertyDetails(
                              title: lodge,
                            ));
                      },
                      child: Container(
                        height: 50,
                        width: AppUtils.deviceScreenSize(context).width / 2.5,
                        decoration: BoxDecoration(
                          color: AppColors.mainAppColor,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(0.15),
                          //     spreadRadius: 0,
                          //     blurRadius: 10,
                          //     offset: const Offset(0, 4),
                          //   ),
                          // ],

                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: CustomText(
                            text: 'View Property',
                            size: 16,
                            maxLines: 3,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    )
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
