import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pim/bloc/property_bloc/property_bloc.dart';
import 'package:pim/model/property_model.dart';
import 'package:pim/model/user_model.dart';
import 'package:pim/res/app_svg_images.dart';
import 'package:pim/utills/app_navigator.dart';
import 'package:pim/view/mobile_view/add_occupant/add_occupant.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/tabview_container/space/add_space/add_space_tab.dart';

import 'package:pim/view/mobile_view/landing_page.dart';
import 'package:pim/view/widgets/app_bar.dart';
import 'package:pim/view/widgets/app_custom_text.dart';
import 'package:pim/view/widgets/form_button.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../../../model/space_model.dart';
import '../../../../../../res/apis.dart';
import '../../../../../../res/app_colors.dart';
import '../../../../../../utills/app_utils.dart';
import '../../../important_pages/dialog_box.dart';
import '../../../important_pages/not_found_page.dart';

class TenantSpaceDetail extends StatefulWidget {
  final UserModel userModel;
  final int index;

  const TenantSpaceDetail({
    super.key,
    required this.userModel,
    required this.index,
  });

  @override
  State<TenantSpaceDetail> createState() => _TenantSpaceDetailState();
}

class _TenantSpaceDetailState extends State<TenantSpaceDetail> {
  PropertyBloc spaceBloc = PropertyBloc();
  List<String> images = [];

  @override
  void initState() {
    // TODO: implement initState
    spaceBloc.add(GetSingleSpaceEvent(
        widget.userModel.occupiedSpaces[widget.index].propertySpaceDetails!.id
            .toString(),
        widget.userModel.occupiedSpaces[widget.index].propertyDetails!.id
            .toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
          child: BlocConsumer<PropertyBloc, PropertyState>(
              bloc: spaceBloc,
              listenWhen: (previous, current) => current is! PropertyInitial,
              buildWhen: (previous, current) => current is! PropertyInitial,
              listener: (context, state) {
                if (state is SingleSpaceSuccessState) {
                  //MSG.snackBar(context, state.msg);

                  // AppNavigator.pushAndRemovePreviousPages(context,
                  //     page: LandingPage(studentProfile: state.studentProfile));
                } else if (state is DeleteSpaceSuccessState) {
                  MSG.snackBar(context, "Space has beedn deleted");
                  Navigator.pop(context, true);
                  // AppNavigator.pushAndRemovePreviousPages(context,
                  //     page: LandingPage(
                  //         selectedIndex: 0, userModel: widget.userModel));
                } else if (state is PropertyErrorState) {
                  MSG.warningSnackBar(context, state.error);
                }
              },
              builder: (context, state) {
                switch (state.runtimeType) {
                  // case PostsFetchingState:
                  //   return const Center(
                  //     child: CircularProgressIndicator(),
                  //   );
                  case SingleSpaceSuccessState:
                    final singleSpaceSuccessState =
                        state as SingleSpaceSuccessState;
                    images = singleSpaceSuccessState.space.imageUrls
                            .map((imageUrl) => AppApis.appBaseUrl + imageUrl)
                            .toList() ??
                        [];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppAppBar(
                                  title: singleSpaceSuccessState
                                      .space.spaceNumber),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const CustomText(
                                    text: "Space Details",
                                    size: 16,
                                    weight: FontWeight.w700,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              lodgeContainer(
                                  space: singleSpaceSuccessState.space,
                                  context: context),
                              TextStyles.textDetails(
                                  textValue:
                                      "Description: ${singleSpaceSuccessState.space.description}",
                                  textSize: 12,
                                  textColor: AppColors.black),
                              const SizedBox(
                                height: 15,
                              ),
                              TextStyles.textDetails(
                                  textValue:
                                      "Occupant: ${singleSpaceSuccessState.space.occupantName}",
                                  textSize: 12,
                                  textColor: AppColors.black),
                              const SizedBox(
                                height: 15,
                              ),
                              TextStyles.textDetails(
                                  textValue:
                                      "Space Type: ${singleSpaceSuccessState.space.spaceType}",
                                  textSize: 12,
                                  textColor: AppColors.black),
                              const SizedBox(
                                height: 15,
                              ),
                              TextStyles.textHeadings(
                                textValue:
                                    "NGN ${AppUtils.convertPrice(singleSpaceSuccessState.space.price)}",
                                textSize: 12,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                  case PropertyLoadingState:
                    return const Column(
                      children: [
                        AppLoadingPage("Fetching Space..."),
                      ],
                    );
                  default:
                    return const Column(
                      children: [
                        AppLoadingPage("Fetching Space..."),
                      ],
                    );
                }
              })),
    );
  }

  void showDeleteConfirmationModal(
      BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Space'),
          content: const Text(
              'Are you sure you want to delete this space? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the modal
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the modal
                onConfirm(); // Trigger the confirm action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const CustomText(
                text: 'Delete',
                color: AppColors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  int imageNum = 0;

  PageController _controller = PageController();

  _onPageChanged(int index) {
    setState(() {
      imageNum = index;
    });
  }

  void nextPage() {
    _controller.animateToPage(_controller.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);

    setState(() {
      if (imageNum == images.length - 1) {
      } else {
        imageNum = imageNum + 1;
      }
    });
  }

  void previousPage() {
    _controller.animateToPage(_controller.page!.toInt() - 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);

    setState(() {
      if (imageNum == 0) {
      } else {
        imageNum = imageNum - 1;
      }
    });
  }

  // Set active = {};
  //
  // void _handleTap(index) {
  //   setState(() {
  //     active.contains(index) ? active.remove(index) : active.add(index);
  //   });
  // }

  Widget lodgeContainer({required Space space, required context}) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: space.imageUrls.isEmpty ? 50 : 270,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          // color: AppColors.white,

          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (space.imageUrls.isEmpty)
                TextStyles.textDetails(
                    textValue:
                        "No image has been added to this space yet. \nClick the edit icon to added required details",
                    textColor: AppColors.black),
              if (space.imageUrls.isNotEmpty)
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        itemCount: images.length,
                        controller: _controller,
                        onPageChanged: _onPageChanged,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(images[index]),
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.width * 0.2,
                      left: 25,
                      child: GestureDetector(
                        onTap: () {
                          previousPage();
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.width * 0.2,
                      right: 25,
                      child: GestureDetector(
                        onTap: () {
                          nextPage();
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        //width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: SizedBox(
                            width: 78,
                            child: Material(
                              type: MaterialType.card,
                              color: Colors.black38,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.camera_enhance,
                                      color: Colors.orange,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    CustomText(
                                      maxLines: 1,
                                      text: imageNum == 0
                                          ? '1/${images.length}'
                                          : '${imageNum + 1}/${images.length}',
                                      color: Colors.orange,
                                      size: 14,
                                      weight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
