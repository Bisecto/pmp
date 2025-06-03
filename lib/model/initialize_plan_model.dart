class InitializeModel {
  InitializeModel({
    required this.subscriptionId,
    required this.transactionId,
    required this.authorizationUrl,
    required this.reference,
    required this.credoReference,
    required this.amount,
    required this.plan,
    required this.callbackUrl,
  });

  final String? subscriptionId;
  final String? transactionId;
  final String? authorizationUrl;
  final String? reference;
  final String? credoReference;
  final double? amount;
  final String? plan;
  final String? callbackUrl;

  factory InitializeModel.fromJson(Map<String, dynamic> json){
    return InitializeModel(
      subscriptionId: json["subscription_id"],
      transactionId: json["transaction_id"],
      authorizationUrl: json["authorization_url"],
      reference: json["reference"],
      credoReference: json["credo_reference"],
      amount: json["amount"],
      plan: json["plan"],
      callbackUrl: json["callback_url"],
    );
  }

  Map<String, dynamic> toJson() => {
    "subscription_id": subscriptionId,
    "transaction_id": transactionId,
    "authorization_url": authorizationUrl,
    "reference": reference,
    "credo_reference": credoReference,
    "amount": amount,
    "plan": plan,
    "callback_url": callbackUrl,
  };

}
