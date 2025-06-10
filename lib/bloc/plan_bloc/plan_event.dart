part of 'plan_bloc.dart';

@immutable
sealed class PlanEvent {}

class GetPlanEvent extends PlanEvent {
  GetPlanEvent();
}
class InitializePlanEvent extends PlanEvent {
  final String planId;
  final CurrentPlan plan;
  InitializePlanEvent(this.planId, this.plan);
}
