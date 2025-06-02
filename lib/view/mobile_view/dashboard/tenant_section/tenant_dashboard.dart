import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pim/bloc/property_bloc/property_bloc.dart';
import 'package:pim/view/mobile_view/dashboard/tenant_section/tenant_space.dart';

import 'package:provider/provider.dart';
import '../../../../model/user_model.dart';
import '../../../../repository/review_helper.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_svg_images.dart';
import '../../../../utills/custom_theme.dart';
import '../../../important_pages/dialog_box.dart';
import '../../../important_pages/not_found_page.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_custom_text.dart';
import '../property_list.dart';

class TenantDashboard extends StatefulWidget {
  final Function(int) onPageChanged;
  UserModel userModel;

  TenantDashboard(
      {super.key, required this.onPageChanged, required this.userModel});

  @override
  State<TenantDashboard> createState() => _TenantDashboardState();
}

class _TenantDashboardState extends State<TenantDashboard> {
  @override
  void initState() {
    reviewHelper.checkAndRequestReview();

    super.initState();
  }

  final ReviewHelper reviewHelper = ReviewHelper();

  @override
  Widget build(BuildContext context) {
    final themeContext = Provider.of<CustomThemeState>(context);
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      backgroundColor:
          theme.isDark ? AppColors.darkBackgroundColor : AppColors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            CustomAppBar(userModel: widget.userModel),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppSvgImages.finger,
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
                TextStyles.textSubHeadings(
                    textValue: 'Welcome ${widget.userModel.username}!',
                    textSize: 20),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      //width: context.size!.width,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.mainAppColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child:  RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Room Number: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 13.0,
                              ),
                            ),
                            TextSpan(
                              text:
                              '${widget.userModel.occupiedSpaces[0].spaceNumber}  ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     // Properties
                      //     RichText(
                      //       text: TextSpan(
                      //         children: [
                      //           const TextSpan(
                      //             text: 'Room Number: ',
                      //             style: TextStyle(
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.black,
                      //               fontSize: 13.0,
                      //             ),
                      //           ),
                      //           TextSpan(
                      //             text:
                      //                 '${widget.userModel.occupiedSpaces[0].spaceNumber}  ',
                      //             style: const TextStyle(
                      //               color: Colors.black,
                      //               fontSize: 13.0,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     // Rooms
                      //     // RichText(
                      //     //   text: TextSpan(
                      //     //     children: [
                      //     //       const TextSpan(
                      //     //         text: 'Rent Due Date: ',
                      //     //         style: TextStyle(
                      //     //           fontWeight: FontWeight.bold,
                      //     //           color: Colors.black,
                      //     //           fontSize: 13.0,
                      //     //         ),
                      //     //       ),
                      //     //       TextSpan(
                      //     //         text:
                      //     //             '${widget.userModel.occupiedSpaces[0].rentExpirationDate}  ',
                      //     //         style: const TextStyle(
                      //     //           color: Colors.black,
                      //     //           fontSize: 13.0,
                      //     //         ),
                      //     //       ),
                      //     //     ],
                      //     //   ),
                      //     // ),
                      //   ],
                      // ),
                    ),
                  ),
                  TenantSpace(
                    userModel: widget.userModel,
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
