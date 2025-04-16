import 'package:wired_express/data/model/response/subscription_feature_model.dart';

class SubscriptionPlanModel {
  int? _id;
  String? _name;
  String? _price;
  String? _frequency;
  bool? _usePlan;
  String? _paypalPlanId;
  List<SubscriptionFeatureModel>? _features;

  SubscriptionPlanModel({
    int? id,
    String? name,
    String? price,
    String? frequency,
    bool? usePlan,
    String? paypalPlanId,
    List<SubscriptionFeatureModel>? features,
  }) {
    this._id = id;
    this._name = name;
    this._price = price;
    this._frequency = frequency;
    this._usePlan = usePlan;
    this._paypalPlanId = paypalPlanId;
    this._features = features;
  }

  int? get id => _id;
  String? get name => _name;
  String? get price => _price;
  String? get frequency => _frequency;
  bool? get usePlan => _usePlan;
  String? get paypalPlanId => _paypalPlanId;
  List<SubscriptionFeatureModel>? get features => _features;

  SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _price = json['price'] == null ? "0.0" : json['price'].toString();
    _frequency = json['frequency'];
    _usePlan = json['use_plan'];
    _paypalPlanId = json['paypal_plan_id'];
    if (json['features'] != null) {
      _features = <SubscriptionFeatureModel>[];
      json['features'].forEach((v) {
        _features!.add(SubscriptionFeatureModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['price'] = this._price;
    data['frequency'] = this._frequency;
    data['use_plan'] = this._usePlan;
    data['paypal_plan_id'] = this._paypalPlanId;
    if (this._features != null) {
      data['features'] = this._features!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
