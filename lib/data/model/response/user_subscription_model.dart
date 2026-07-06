
import 'package:wired_express/data/model/response/subscription_model.dart';

class UserSubscriptionPlanModel {
  int? _planId;
  String? _paypalPlanId;
  String? _paypalSubscriptionId;
  String? _stripeSubscriptionId;
  String? _givenName;
  String? _lastName;
  String? _email;
  SubscriptionPlanModel? _plan;

  UserSubscriptionPlanModel({
    required int? planId,
    required String? paypalPlanId,
    required String? paypalSubscriptionId,
    required String? stripeSubscriptionId,
    required String? givenName,
    required String? lastName,
    required String? email,
     SubscriptionPlanModel? plan,
  }) {
    _planId = planId;
    _paypalPlanId = paypalPlanId;
    _paypalSubscriptionId = paypalSubscriptionId;
    _stripeSubscriptionId = stripeSubscriptionId;
    _givenName = givenName;
    _lastName = lastName;
    _email = email;
    _plan = plan;
  }

  int? get planId => _planId;
  String? get paypalPlanId => _paypalPlanId;
  String? get paypalSubscriptionId => _paypalSubscriptionId;
  String? get stripeSubscriptionId => _stripeSubscriptionId;
  String? get givenName => _givenName;
  String? get lastName => _lastName;
  String? get email => _email;
  SubscriptionPlanModel? get plan => _plan;

  UserSubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    _planId = json['plan_id'];
    _paypalPlanId = json['paypal_plan_id'];
    _paypalSubscriptionId = json['paypal_subscription_id'];
    _stripeSubscriptionId = json['stripe_subscription_id'];
    _givenName = json['given_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _plan = json['plan'] != null
        ? SubscriptionPlanModel.fromJson(json['plan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plan_id'] = _planId;
    data['paypal_plan_id'] = _paypalPlanId;
    data['paypal_subscription_id'] = _paypalSubscriptionId;
    data['stripe_subscription_id'] = _stripeSubscriptionId;
    data['given_name'] = _givenName;
    data['last_name'] = _lastName;
    data['email'] = _email;
    if (_plan != null) {
      data['plan'] = _plan!.toJson();
    }
    return data;
  }
}