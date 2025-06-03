part of 'plan_bloc.dart';

@immutable
sealed class PlanEvent {}

class GetPlanEvent extends PlanEvent {
  GetPlanEvent();
}
class InitializePlanEvent extends PlanEvent {
  final String planId;
  InitializePlanEvent(this.planId);
}
