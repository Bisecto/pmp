import 'package:flutter/material.dart';
import 'package:pim/model/property_model.dart';
import 'package:pim/model/user_model.dart';
import 'package:pim/res/apis.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/property_details.dart';
import 'package:pim/view/widgets/form_input.dart';

import '../../../../res/app_colors.dart';
import '../../../model/current_plan_model.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../widgets/app_custom_text.dart';

class LodgeList extends StatefulWidget {
  List<Property> properties;
  final UserModel userModel;
  final CurrentPlan currentPlan;

  LodgeList(
      {super.key,
      required this.properties,
      required this.userModel,
      required this.currentPlan});

  @override
  State<LodgeList> createState() => _LodgeListState();
}

class _LodgeListState extends State<LodgeList> {
  final TextEditingController _searchTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return widget.properties.isNotEmpty
        ? Column(children: [
            CustomTextFormField(
                controller: _searchTextEditingController,
                hint: 'Search....',
                hintColor: AppColors.black,
                borderColor: AppColors.grey,
                //icon: Icons.search,
                backgroundColor: AppColors.lightPrimary,
                onChanged: (val) {
                  setState(() {
                    _searchTextEditingController.text = val;
                  });
                },
                label: ''),
            Container(
              height: widget.properties.length * 351,
              child: ListView.builder(
                itemCount: widget.properties.length,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (widget.properties[index].propertyName
                      .toLowerCase()
                      .contains(
                          _searchTextEditingController.text.toLowerCase())) {
                    return lodgeContainer(
                        property: widget.properties[index], context: context);
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ])
        : Container(
            child: const CustomText(
                text: "No properties has been uploaded yet", size: 14),
          );
  }

  Widget lodgeContainer({required Property property, required context}) {
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
                  image: DecorationImage(
                      image: NetworkImage(
                        AppApis.appBaseUrl + property.firstImage,
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
                      textValue: property.propertyName,
                      textSize: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.red,
                          ),
                          CustomText(
                              text: "${property.city}, ${property.location}",
                              size: 14),
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
                      child: Row(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.cabin_rounded,
                                color: Colors.purple,
                              ),
                              CustomText(
                                text: ' ${property.totalSpace}  ',
                                size: 14,
                                maxLines: 3,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.people,
                                color: Colors.green,
                              ),
                              CustomText(
                                text: '  ${property.occupiedSpace}',
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
                              property: property,
                              userModel: widget.userModel,
                              currentPlan: widget.currentPlan,
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
