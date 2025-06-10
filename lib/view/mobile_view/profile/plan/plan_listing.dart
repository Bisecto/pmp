import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pim/bloc/plan_bloc/plan_bloc.dart';
import 'package:pim/model/current_plan_model.dart';
import 'package:pim/model/user_model.dart';
import 'package:pim/view/widgets/form_button.dart';

import '../../../../model/plan_model.dart';
import '../../../../res/app_colors.dart';
import '../../../../utills/app_navigator.dart';
import '../../../../utills/app_utils.dart';
import '../../../important_pages/dialog_box.dart';
import '../../../important_pages/not_found_page.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_custom_text.dart';
import 'make_payment.dart';

class PlanListing extends StatefulWidget {
  final CurrentPlan currentPlan;
  final UserModel userModel;

  const PlanListing(
      {super.key, required this.currentPlan, required this.userModel});

  @override
  State<PlanListing> createState() => _PlanListingState();
}

class _PlanListingState extends State<PlanListing> {
  PlanBloc planBloc = PlanBloc();

  @override
  void initState() {
    // TODO: implement initState
    planBloc.add(GetPlanEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const AppAppBar(
                  title: 'PMP Plans',
                ),
                BlocConsumer<PlanBloc, PlanState>(
                  bloc: planBloc,
                  listenWhen: (previous, current) => current is! PlanInitial,
                  buildWhen: (previous, current) => current is PlanSuccessState,
                  listener: (context, state) async {
                    if (state is PlanSuccessState) {
                      // Handle success, e.g., navigate to a new page or show a snackbar
                    } else if (state is PlanErrorState) {
                      MSG.warningSnackBar(context, state.error);
                      Navigator.pop(context);
                    } else if (state is PlanInitializeSuccessState) {
                      Navigator.pop(context);

                      AppNavigator.pushAndStackPage(context,
                          page: MakePayment(
                            initializeModel: state.initializeModel,
                            currentPlan: widget.currentPlan,
                            userModel: widget.userModel,
                            newPlan: state.newPlan,
                          ));
                    }
                  },
                  builder: (context, state) {
                    if (state is PlanSuccessState) {
                      final planList = state.plans;

                      return planList.isEmpty
                          ? const Center(
                              child: Text('There are no plans to display'),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                width: double.infinity,
                                // decoration: BoxDecoration(

                                //),
                                child: Material(
                                  type: MaterialType.card,
                                  color: AppColors.lightPrimary,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const ScrollPhysics(),
                                    itemCount: planList.length,
                                    itemBuilder: (context, index) {
                                      final plan = planList[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child:
                                            planContainer(plan, colors[index]),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                    }else if(state is PlanInitializeLoadingState){
                      return const Center(
                        child: AppLoadingPage("Initializing payment......"),
                      );
                    } else {
                      return const Center(
                        child: AppLoadingPage("Loading......"),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> colors = [
    AppColors.black,
    AppColors.blue,
    AppColors.lightPurple,
    AppColors.green
  ];

  Widget planContainer(Plan plan, Color color) {
    print(plan.postExpiryWarningEnabled);
    return Container(
      //height: 300,
      decoration: BoxDecoration(
          //color: AppColors.mainAppColor,
          border: Border.all(color: AppColors.grey),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Container(
            height: 100,
            width: AppUtils.deviceScreenSize(context).width,
            decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  TextStyles.textHeadings(
                      textValue: plan.price!.toString().startsWith('0')
                          ? "Free"
                          : "NGN ${AppUtils.convertPrice(plan.price!)}",
                      textColor: AppColors.white),
                  const SizedBox(
                    height: 2,
                  ),
                  CustomText(
                      text: widget.currentPlan.plan!.name == plan.name
                          ? "CurrentPlan"
                          : plan.displayName,
                      //"${widget.currentPlan!.plan!.description}",
                      size: 13,
                      color: AppColors.white),
                  const SizedBox(
                    height: 2,
                  ),
                  CustomText(
                      text: plan.description,
                      //"${widget.currentPlan!.plan!.description}",
                      size: 13,
                      color: AppColors.white)
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Max Property",
                        size: 12,
                        weight: FontWeight.w800,
                      ),
                      CustomText(
                        text: plan.maxProperties!.toString(),
                        size: 12,
                        weight: FontWeight.w800,
                        color: AppColors.red,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Max Space/Property",
                        size: 12,
                        weight: FontWeight.w800,
                      ),
                      CustomText(
                        text: plan.maxPropertySpacesPerProperty!.toString(),
                        size: 12,
                        weight: FontWeight.w800,
                        color: AppColors.red,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Max Image/Property",
                        size: 12,
                        weight: FontWeight.w800,
                      ),
                      CustomText(
                        text: plan.maxImagesPerProperty!.toString(),
                        size: 12,
                        weight: FontWeight.w800,
                        color: AppColors.red,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Sending Email",
                        size: 12,
                        weight: FontWeight.w800,
                      ),
                      if (plan.sendingEmailEnabled!)
                        Icon(
                          Icons.verified_user,
                          color: AppColors.green,
                          size: 15,
                        )
                      else
                        Icon(
                          Icons.cancel_sharp,
                          color: AppColors.red,
                          size: 15,
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Property Listing",
                        size: 12,
                        weight: FontWeight.w800,
                      ),
                      if (plan.propertyListingEnabled!)
                        Icon(
                          Icons.verified_user,
                          color: AppColors.green,
                          size: 15,
                        )
                      else
                        Icon(
                          Icons.cancel_sharp,
                          color: AppColors.red,
                          size: 15,
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Occupant Image",
                        size: 12,
                        weight: FontWeight.w800,
                      ),
                      if (plan.occupantImageEnabled!)
                        Icon(
                          Icons.verified_user,
                          color: AppColors.green,
                          size: 15,
                        )
                      else
                        Icon(
                          Icons.cancel_sharp,
                          color: AppColors.red,
                          size: 15,
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Receipt Generation",
                        size: 12,
                        weight: FontWeight.w800,
                      ),
                      Icon(
                        Icons.verified_user,
                        color: AppColors.green,
                        size: 15,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ), Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Rent Warning Notification",
                        size: 12,
                        weight: FontWeight.w800,
                      ),
                      if (plan.rentWarningNotificationEnabled!)
                        Icon(
                          Icons.verified_user,
                          color: AppColors.green,
                          size: 15,
                        )
                      else
                        Icon(
                          Icons.cancel_sharp,
                          color: AppColors.red,
                          size: 15,
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ), Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Rent Expiration Warning",
                        size: 12,
                        weight: FontWeight.w800,
                      ),
                      if (plan.postExpiryWarningEnabled!)
                        Icon(
                          Icons.verified_user,
                          color: AppColors.green,
                          size: 15,
                        )
                      else
                        Icon(
                          Icons.cancel_sharp,
                          color: AppColors.red,
                          size: 15,
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Duration",
                        size: 12,
                        weight: FontWeight.w800,
                      ),
                      CustomText(
                        text: "${plan.durationDays!} Days",
                        size: 12,
                        weight: FontWeight.w800,
                        color: AppColors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FormButton(
              onPressed: () {
                planBloc.add(InitializePlanEvent(plan.id.toString(),CurrentPlan(hasActiveSubscription: true, plan: plan, subscription: null, usage: null, daysRemaining: null, expiresAt: null)));
              },
              text: "Subscribe",
              bgColor: color,
              borderRadius: 15,
            ),
          )
        ],
      ),
    );
  }
}
