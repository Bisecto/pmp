import 'package:pim/model/plan_model.dart';

class Subscription {
  Subscription({
    required this.id,
    required this.plan,
    required this.planDetails,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.amountPaid,
    required this.autoRenew,
    required this.daysRemaining,
    required this.isActive,
    required this.createdAt,
  });

  final String? id;
  final int? plan;
  final Plan? planDetails;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final String? amountPaid;
  final bool? autoRenew;
  final int? daysRemaining;
  final bool? isActive;
  final DateTime? createdAt;

  factory Subscription.fromJson(Map<String, dynamic> json){
    return Subscription(
      id: json["id"],
      plan: json["plan"],
      planDetails: json["plan_details"] == null ? null : Plan.fromJson(json["plan_details"]),
      startDate: DateTime.tryParse(json["start_date"] ?? ""),
      endDate: DateTime.tryParse(json["end_date"] ?? ""),
      status: json["status"],
      amountPaid: json["amount_paid"],
      autoRenew: json["auto_renew"],
      daysRemaining: json["days_remaining"],
      isActive: json["is_active"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "plan": plan,
    "plan_details": planDetails?.toJson(),
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "status": status,
    "amount_paid": amountPaid,
    "auto_renew": autoRenew,
    "days_remaining": daysRemaining,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
  };

}
