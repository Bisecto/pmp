part of 'plan_bloc.dart';

@immutable
sealed class PlanState {}

final class PlanInitial extends PlanState {}

class PlanLoadingState extends PlanState {}
class PlanInitializeLoadingState extends PlanState {}

class PlanErrorState extends PlanState {
  final String error;

  PlanErrorState(this.error);
}

class PlanSuccessState extends PlanState {
  final List<Plan> plans;

  PlanSuccessState(this.plans);
}

class PlanInitializeSuccessState extends PlanState {
  final InitializeModel initializeModel;
  final CurrentPlan newPlan;

  PlanInitializeSuccessState(this.initializeModel, this.newPlan);
}
