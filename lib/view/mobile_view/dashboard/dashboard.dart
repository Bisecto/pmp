import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pim/bloc/property_bloc/property_bloc.dart';

import 'package:provider/provider.dart';
import '../../../model/current_plan_model.dart';
import '../../../model/user_model.dart';
import '../../../repository/review_helper.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_svg_images.dart';
import '../../../utills/custom_theme.dart';
import '../../important_pages/dialog_box.dart';
import '../../important_pages/not_found_page.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_custom_text.dart';
import 'property_list.dart';

class Dashboard extends StatefulWidget {
  final Function(int) onPageChanged;
  UserModel userModel;
  final CurrentPlan currentPlan;

  Dashboard(
      {super.key,
      required this.onPageChanged,
      required this.userModel,
      required this.currentPlan});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int semesterId = 0;
  bool isImageNull = false;
  bool isImageAccessible = true;
  List<String> topics = [];
  PropertyBloc propertyBloc = PropertyBloc();

  @override
  void initState() {
    propertyBloc.add(GetPropertyEvent());
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
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SafeArea(
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
                      textValue: 'Welcome ${widget.userModel.firstName}!',
                      textSize: 20),
                ],
              ),
              BlocConsumer<PropertyBloc, PropertyState>(
                  bloc: propertyBloc,
                  listenWhen: (previous, current) =>
                      current is! PropertyInitial,
                  buildWhen: (previous, current) => current is! PropertyInitial,
                  listener: (context, state) {
                    if (state is PropertySuccessState) {
                      //MSG.snackBar(context, state.msg);

                      // AppNavigator.pushAndRemovePreviousPages(context,
                      //     page: LandingPage(studentProfile: state.studentProfile));
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
                      case PropertySuccessState:
                        final propertySuccessState =
                            state as PropertySuccessState;

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.mainAppColor),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Properties
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Properties: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 13.0,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${propertySuccessState.propertiesModel.totalProperties}  ',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 13.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Rooms
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Total Space: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 13.0,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${propertySuccessState.propertiesModel.totalSpaces}  ',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 13.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // RichText(
                                      //   text: TextSpan(
                                      //     children: [
                                      //       const TextSpan(
                                      //         text: 'Occupied Space: ',
                                      //         style: TextStyle(
                                      //           fontWeight: FontWeight.bold,
                                      //           color: Colors.black,
                                      //           fontSize: 13.0,
                                      //         ),
                                      //       ),
                                      //       TextSpan(
                                      //         text:
                                      //             '${propertySuccessState.propertiesModel.totalOccupiedRooms}  ',
                                      //         style: const TextStyle(
                                      //           color: Colors.black,
                                      //           fontSize: 13.0,
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      // Tenants
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Occupied Space: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 13.0,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${propertySuccessState.propertiesModel.totalTenants}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 13.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              LodgeList(
                                properties: propertySuccessState
                                    .propertiesModel.properties,
                                userModel: widget.userModel,
                                currentPlan: widget.currentPlan,
                              ),
                            ],
                          ),
                        );

                      case PropertyLoadingState:
                        return const Column(
                          children: [
                            AppLoadingPage("Fetching Properties..."),
                          ],
                        );
                      default:
                        return const Column(
                          children: [
                            AppLoadingPage("Fetching Properties..."),
                          ],
                        );
                    }
                  })
            ],
          ),
        )),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    propertyBloc.add(GetPropertyEvent());
  }

  Set active = {};
  bool isLoading = true;

  void _handleTap(index) {
    setState(() {
      active.contains(index) ? active.remove(index) : active.add(index);
    });
  }

  Widget analyticsContainer() {
    return Container();
  }
}
