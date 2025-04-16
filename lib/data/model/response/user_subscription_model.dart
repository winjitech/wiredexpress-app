class UserSubscriptionPlanModel {
  int? _planId;
  String? _paypalPlanId;
  String? _paypalSubscriptionId;
  String? _givenName;
  String? _lastName;
  String? _email;

  UserSubscriptionPlanModel({
    required int? planId,
    required String? paypalPlanId,
    required String? paypalSubscriptionId,
    required String? givenName,
    required String? lastName,
    required String? email,
  }) {
    _planId = planId;
    _paypalPlanId = paypalPlanId;
    _paypalSubscriptionId = paypalSubscriptionId;
    _givenName = givenName;
    _lastName = lastName;
    _email = email;
  }

  int? get planId => _planId;
  String? get paypalPlanId => _paypalPlanId;
  String? get paypalSubscriptionId => _paypalSubscriptionId;
  String? get givenName => _givenName;
  String? get lastName => _lastName;
  String? get email => _email;

  UserSubscriptionPlanModel.fromJson(Map<String?, dynamic> json) {
    _planId = json['plan_id'];
    _paypalPlanId = json['paypal_plan_id'];
    _paypalSubscriptionId = json['paypal_subscription_id'];
    _givenName = json['given_name'];
    _lastName = json['last_name'];
    _email = json['email'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['plan_id'] = _planId;
    data['paypal_plan_id'] = _paypalPlanId;
    data['paypal_subscription_id'] = _paypalSubscriptionId;
    data['given_name'] = _givenName;
    data['last_name'] = _lastName;
    data['email'] = _email;
    return data;
  }
}
