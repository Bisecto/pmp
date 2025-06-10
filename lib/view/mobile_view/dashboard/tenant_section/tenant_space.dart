import 'package:flutter/material.dart';
import 'package:pim/model/property_model.dart';
import 'package:pim/model/user_model.dart';
import 'package:pim/res/apis.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/property_details.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/tabview_container/space/space_details.dart';
import 'package:pim/view/mobile_view/dashboard/tenant_section/tenant_space_details.dart';
import 'package:pim/view/widgets/form_input.dart';

import '../../../../../res/app_colors.dart';
import '../../../../res/app_images.dart';
import '../../../../utills/app_navigator.dart';
import '../../../../utills/app_utils.dart';
import '../../../widgets/app_custom_text.dart';

class TenantSpace extends StatefulWidget {
  final UserModel userModel;

  TenantSpace({super.key, required this.userModel});

  @override
  State<TenantSpace> createState() => _TenantSpaceState();
}

class _TenantSpaceState extends State<TenantSpace> {
  final TextEditingController _searchTextEditingController =
      TextEditingController();
@override
  void initState() {
    // TODO: implement initState
  print(widget.userModel.occupiedSpaces[0].propertySpaceDetails!.propertySpaceImages);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return widget.userModel.occupiedSpaces.isNotEmpty
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
              height: widget.userModel.occupiedSpaces.length * 351,
              child: ListView.builder(
                itemCount: widget.userModel.occupiedSpaces.length,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (widget.userModel.occupiedSpaces[index].spaceNumber
                      .toLowerCase()
                      .contains(
                          _searchTextEditingController.text.toLowerCase())) {
                    return spaceContainer(
                        occupiedSpace: widget.userModel.occupiedSpaces[index],
                        context: context,index:index);
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

  Widget spaceContainer({required Occupant occupiedSpace, required context, required index}) {
    return GestureDetector(
        onTap: () {
          AppNavigator.pushAndStackPage(context,
              page: TenantSpaceDetail(
                  userModel: widget.userModel,
                  index:index));

      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 255,
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                        image: NetworkImage(
      occupiedSpace.propertySpaceDetails!.propertySpaceImages.isEmpty?"https://nigerianbuildingdesigns.com/wp-content/uploads/2023/09/1-BEDROOM-FLATS-DESIGN-B.jpg":
                              occupiedSpace.propertySpaceDetails!
                                  .propertySpaceImages.first,
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
                        textValue: occupiedSpace.spaceNumber,
                        textSize: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.type_specimen_rounded,
                              color: AppColors.red,
                            ),
                            CustomText(
                                text: "${occupiedSpace.spaceType}", size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                //   child: Row(
                //     //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       GestureDetector(
                //         onTap: () {
                //           AppNavigator.pushAndStackPage(context,
                //               page: TenantSpaceDetail(
                //               userModel: widget.userModel,
                //               index:index));
                //         },
                //         child: Container(
                //           height: 50,
                //           width: AppUtils.deviceScreenSize(context).width / 2.5,
                //           decoration: BoxDecoration(
                //             color: AppColors.mainAppColor,
                //             // boxShadow: [
                //             //   BoxShadow(
                //             //     color: Colors.black.withOpacity(0.15),
                //             //     spreadRadius: 0,
                //             //     blurRadius: 10,
                //             //     offset: const Offset(0, 4),
                //             //   ),
                //             // ],
                //
                //             borderRadius: BorderRadius.circular(15),
                //           ),
                //           child: const Center(
                //             child: CustomText(
                //               text: 'View Property',
                //               size: 16,
                //               maxLines: 3,
                //               color: AppColors.white,
                //             ),
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
