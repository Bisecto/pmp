import 'package:flutter/material.dart';
import 'package:pim/model/space_model.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/tabview_container/space/add_space/add_space_tab.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/tabview_container/space/room_list.dart';

import '../../../../../../bloc/property_bloc/property_bloc.dart';
import '../../../../../../model/property_model.dart';
import '../../../../../../model/user_model.dart';
import '../../../../../../res/app_colors.dart';
import '../../../../../../utills/app_navigator.dart';
import '../../../../../../utills/app_utils.dart';
import '../../../../../widgets/app_custom_text.dart';

class RoomContainer extends StatefulWidget {
  final Property property;
  final UserModel userModel;
  final PropertyBloc propertyBloc;

  const RoomContainer(
      {super.key,
      required this.property,
      required this.userModel,
      required this.propertyBloc});

  @override
  State<RoomContainer> createState() => _RoomContainerState();
}

class _RoomContainerState extends State<RoomContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Spaces",
                size: 15,
                weight: FontWeight.w600,
              ),
              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         AppNavigator.pushAndStackPage(context,
              //             page: AddSpace(
              //               userModel: widget.userModel,
              //               property: widget.property,
              //               isEdit: false,
              //               space: Space(
              //                   id: 0,
              //                   spaceNumber: '',
              //                   spaceType: '',
              //                   isOccupied: false,
              //                   description: '',
              //                   price: 0,
              //                   imageUrls: [],
              //                   propertyName: '',
              //                   advertise: false),
              //             ));
              //       },
              //       child: Container(
              //         height: 45,
              //         // width:
              //         //     AppUtils.deviceScreenSize(context)
              //         //             .width /
              //         //         3,
              //         decoration: BoxDecoration(
              //             color: AppColors.blue,
              //             borderRadius: BorderRadius.circular(5)),
              //         child: const Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             CustomText(
              //               text: "  Add Space  ",
              //               color: AppColors.white,
              //               size: 14,
              //               weight: FontWeight.bold,
              //             ),
              //           ],
              //         ),
              //       ),
              //     )
              //   ],
              // )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          if (widget.property.spaces.isEmpty)
            const CustomText(
              text: "No space has been added yet",
            ),
          if (widget.property.spaces.isNotEmpty)
            SpaceList(
              spaces: widget.property.spaces,
              property: widget.property,
              userModel: widget.userModel,
              propertyBloc: widget.propertyBloc,
            )
        ],
      ),
    );
  }
}
