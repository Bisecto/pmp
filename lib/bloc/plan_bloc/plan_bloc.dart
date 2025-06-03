import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/initialize_plan_model.dart';
import '../../model/plan_model.dart';
import '../../repository/repository.dart';
import '../../res/apis.dart';
import '../../utills/app_utils.dart';
import '../../utills/shared_preferences.dart';

part 'plan_event.dart';

part 'plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  PlanBloc() : super(PlanInitial()) {
    on<GetPlanEvent>(getPlanEvent);
    on<InitializePlanEvent>(initializePlanEvent);
    // on<PlanEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  FutureOr<void> getPlanEvent(
      GetPlanEvent event, Emitter<PlanState> emit) async {
    emit(PlanLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString('access-token');
    try {
      var listPlanResponse = await appRepository.getRequestWithToken(
          accessToken, AppApis.planListApi);
      // var res = await appRepository.appGetRequest(
      //   '${AppApis.listProduct}?page=${event.page}&pageSize=${event.pageSize}',
      //   accessToken: accessToken,
      // );
      //AppUtils().debuglog(res.body);
      AppUtils().debuglog(" status Code ${listPlanResponse.statusCode}");
      AppUtils().debuglog(" Data ${listPlanResponse.body}");
      AppUtils().debuglog(json.decode(listPlanResponse.body));
      if (listPlanResponse.statusCode == 200 ||
          listPlanResponse.statusCode == 201) {
        List<dynamic> planJsonResponse =
            json.decode(listPlanResponse.body)['data'];

        List<Plan> planList =
            planJsonResponse.map((item) => Plan.fromJson(item)).toList();

        //updateData(customerProfile);
        AppUtils().debuglog(planList);
        emit(PlanSuccessState(planList)); // Emit success state with data
      } else {
        emit(PlanErrorState(
            AppUtils.getAllErrorMessages(json.decode(listPlanResponse.body)['errors'])));
        emit(PlanInitial());

        AppUtils().debuglog(json.decode(listPlanResponse.body));
      }
    } catch (e) {
      emit(PlanErrorState("An error occurred while fetching property."));
      emit(PlanInitial());
      AppUtils().debuglog(e);
    }
  }

  FutureOr<void> initializePlanEvent(
      InitializePlanEvent event, Emitter<PlanState> emit) async {
    emit(PlanInitializeLoadingState()); // Emit loading state at the start of the event

    AppRepository appRepository = AppRepository();
    String accessToken = await SharedPref.getString('access-token');
    //try {
      var initializePlanResponse = await appRepository.postRequestWithToken(
          accessToken,{"plan_id":event.planId}, AppApis.initializePlan);
      // var res = await appRepository.appGetRequest(
      //   '${AppApis.listProduct}?page=${event.page}&pageSize=${event.pageSize}',
      //   accessToken: accessToken,
      // );
      //AppUtils().debuglog(res.body);
      AppUtils().debuglog(" status Code ${initializePlanResponse.statusCode}");
      AppUtils().debuglog(" Data ${initializePlanResponse.body}");
      AppUtils().debuglog(json.decode(initializePlanResponse.body));
      if (initializePlanResponse.statusCode == 200 ||
          initializePlanResponse.statusCode == 201) {
        InitializeModel initializeModel = InitializeModel.fromJson(
            json.decode(initializePlanResponse.body)['data']);

        emit(PlanInitializeSuccessState(
            initializeModel)); // Emit success state with data
      } else {
        emit(PlanErrorState(AppUtils.getAllErrorMessages(
            json.decode(initializePlanResponse.body)['errors'])));
        emit(PlanInitial());

        AppUtils().debuglog(json.decode(initializePlanResponse.body));
      }
    // } catch (e) {
    //   emit(PlanErrorState("An error occurred while fetching property."));
    //   emit(PlanInitial());
    //   AppUtils().debuglog(e);
    // }
  }
}
