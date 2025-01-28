import 'package:flutter/material.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/tabview_container/space/room_list.dart';
import '../../../../../../bloc/property_bloc/property_bloc.dart';
import '../../../../../../model/property_model.dart';
import '../../../../../../model/user_model.dart';
import '../../../../../../res/app_colors.dart';
import '../../../../../widgets/app_custom_text.dart';

class RoomContainer extends StatefulWidget {
  final Property property;
  final UserModel userModel;
  final PropertyBloc propertyBloc;

  const RoomContainer({
    Key? key,
    required this.property,
    required this.userModel,
    required this.propertyBloc,
  }) : super(key: key);

  @override
  State<RoomContainer> createState() => _RoomContainerState();
}

class _RoomContainerState extends State<RoomContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Spaces",
                size: 15,
                weight: FontWeight.w600,
              ),
              // Uncomment and adjust if needed for adding a space button
              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         // Add navigation to AddSpace screen
              //       },
              //       child: Container(
              //         height: 45,
              //         decoration: BoxDecoration(
              //           color: AppColors.blue,
              //           borderRadius: BorderRadius.circular(5),
              //         ),
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
              //     ),
              //   ],
              // ),
            ],
          ),
          const SizedBox(height: 10),
          if (widget.property.spaces.isEmpty)
            const CustomText(
              text: "No space has been added yet",
            )
          else
            SpaceList(
              spaces: widget.property.spaces,
              property: widget.property,
              userModel: widget.userModel,
              propertyBloc: widget.propertyBloc,
            ),
        ],
      ),
    );
  }
}
