import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pim/bloc/property_bloc/property_bloc.dart';
import 'package:pim/model/user_model.dart';
import 'package:pim/res/app_svg_images.dart';
import 'package:pim/utills/app_navigator.dart';
import 'package:pim/view/mobile_view/add_occupant/add_occupant.dart';
import 'package:pim/view/mobile_view/add_property/add_property_tab.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/tabview_container/occupant/occupant_container.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/tabview_container/space/room_container.dart';
import 'package:pim/view/mobile_view/landing_page.dart';
import 'package:pim/view/widgets/app_bar.dart';
import 'package:pim/view/widgets/app_custom_text.dart';
import 'package:pim/view/widgets/form_button.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../model/current_plan_model.dart';
import '../../../../model/property_model.dart';
import '../../../../res/apis.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_images.dart';
import '../../../../utills/app_utils.dart';
import '../../../important_pages/dialog_box.dart';
import '../../../important_pages/not_found_page.dart';
import 'tabview_container/occupant/occupant_list.dart';

class PropertyDetails extends StatefulWidget {
  final Property property;
  final UserModel userModel;
  final CurrentPlan currentPlan;

  const PropertyDetails(
      {super.key,
      required this.property,
      required this.userModel,
      required this.currentPlan});

  @override
  State<PropertyDetails> createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails>
    with SingleTickerProviderStateMixin {
  PropertyBloc propertyBloc = PropertyBloc();
  List<String> images = [];
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    propertyBloc.add(GetSinglePropertyEvent(widget.property.id.toString()));
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    tabController.addListener(() {
      if (tabController.indexIsChanging ||
          tabController.index != currentIndex) {
        setState(() {
          currentIndex = tabController.index; // Update currentIndex
        });
      }
    });
  }

  int currentIndex = 0;

  @override
  void dispose() {
    tabController.removeListener(() {});
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<PropertyBloc, PropertyState>(
          bloc: propertyBloc,
          listenWhen: (previous, current) => current is! PropertyInitial,
          buildWhen: (previous, current) => current is! PropertyInitial,
          listener: (context, state) {
            if (state is DeletePropertySuccessState) {
              MSG.snackBar(context, "Property has been deleted");
              AppNavigator.pushAndRemovePreviousPages(
                context,
                page: LandingPage(
                  selectedIndex: 0,
                  userModel: widget.userModel,
                  currentPlan: widget.currentPlan,
                ),
              );
            } else if (state is PropertyErrorState) {
              MSG.warningSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is SinglePropertySuccessState) {
              final singlePropertySuccessState = state;
              images = singlePropertySuccessState.property.imageUrls
                      .map((imageUrl) => AppApis.appBaseUrl + imageUrl.url)
                      .toList() ??
                  [];
              // final tabHeight = currentIndex == 0
              //     ? (singlePropertySuccessState.property.spaces.length + 0.5) *
              //         123.0
              //     : (singlePropertySuccessState.property.occupants.length +
              //             0.5) *
              //         165.0;
              // tabHeight + 35;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppAppBar(
                        title: singlePropertySuccessState.property.propertyName,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            text: "Property Details",
                            size: 16,
                            weight: FontWeight.w700,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  AppNavigator.pushAndStackPage(
                                    context,
                                    page: AddPropertyScreen(
                                      userModel: widget.userModel,
                                      isEdit: true,
                                      property:
                                          singlePropertySuccessState.property, currentPlan: widget.currentPlan,
                                    ),
                                  );
                                },
                                child: SvgPicture.asset(
                                  AppSvgImages.edit,
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  showDeleteConfirmationModal(context, () {
                                    propertyBloc.add(
                                      DeletePropertyEvent(
                                        singlePropertySuccessState.property.id
                                            .toString(),
                                      ),
                                    );
                                  });
                                },
                                child: SvgPicture.asset(
                                  AppSvgImages.delete,
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      lodgeContainer(
                        property: singlePropertySuccessState.property,
                        context: context,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: FormButton(
                              height: 50,
                              bgColor: currentIndex == 0
                                  ? AppColors.mainAppColor
                                  : AppColors.white,
                              text:
                                  'Spaces (${singlePropertySuccessState.property.spaces.length})',
                              textColor: currentIndex != 0
                                  ? AppColors.mainAppColor
                                  : AppColors.white,
                              onPressed: () {
                                setState(() {
                                  currentIndex = 0;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: FormButton(
                              //style: ElevatedButton.styleFrom(
                              height: 50,
                              bgColor: currentIndex == 1
                                  ? AppColors.mainAppColor
                                  : AppColors.white,
                              text:
                                  'Occupants (${singlePropertySuccessState.property.occupants.length})',
                              textColor: currentIndex != 1
                                  ? AppColors.mainAppColor
                                  : AppColors.white,
                              onPressed: () {
                                setState(() {
                                  currentIndex = 1;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        //height: tabHeight,
                        child: currentIndex == 0
                            ? RoomContainer(
                                property: singlePropertySuccessState.property,
                                userModel: widget.userModel,
                                propertyBloc: propertyBloc,
                              )
                            : OccupantContainer(
                                property: singlePropertySuccessState.property,
                                userModel: widget.userModel,
                                propertyBloc: propertyBloc,
                              ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is PropertyLoadingState) {
              return const Center(
                child: AppLoadingPage("Fetching Property..."),
              );
            }

            return const Center(
              child: AppLoadingPage("Fetching Property..."),
            );
          },
        ),
      ),
    );
  }

  void showDeleteConfirmationModal(
      BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Property'),
          content: const Text(
              'Are you sure you want to delete this property? This action cannot be undone.'),
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

  Widget lodgeContainer({required Property property, required context}) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 270,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          // color: AppColors.white,

          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (property.imageUrls.isNotEmpty)
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
              if (property.imageUrls.isNotEmpty) const SizedBox(height: 20),
              // GestureDetector(
              //   onTap: () => Get.to(() => FullGalleryScreen(
              //     index: 1,
              //     images: images,
              //   )),
              //   child: const Center(
              //     child: CustomText(
              //         color: Colors.black54,
              //         text: 'Tap to view in fullScreen',
              //         weight: FontWeight.w700,
              //         size: 13),
              //   ),
              // ),
              if (property.imageUrls.isEmpty)
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
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.red,
                        ),
                        CustomText(
                            text: "${property.city}, ${property.location}",
                            size: 14),
                      ],
                    ),
                    if (property.priceType.toLowerCase() == 'static')
                      TextStyles.textHeadings(
                        textValue:
                            "NGN ${AppUtils.convertPrice(property.price)}",
                        textSize: 12,
                      ),
                    if (property.priceType.toLowerCase() != 'static')
                      TextStyles.textHeadings(
                        textValue:
                            "NGN ${AppUtils.convertPrice(property.priceRangeStart.toString())} - ${AppUtils.convertPrice(property.priceRangeStop.toString())}",
                        textSize: 12,
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
