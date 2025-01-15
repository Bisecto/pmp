import 'package:flutter/material.dart';

import '../../../../../bloc/property_bloc/property_bloc.dart';
import '../../../../../model/property_model.dart';
import '../../../../../model/user_model.dart';
import '../../../../../res/app_colors.dart';
import '../../../../../utills/app_utils.dart';
import '../../../../widgets/app_custom_text.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Status",
                size: 14,
                weight: FontWeight.w400,
              ),
              CustomText(
                text: widget.property.status,
                color: AppColors.black,
                size: 14,
                weight: FontWeight.w400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
