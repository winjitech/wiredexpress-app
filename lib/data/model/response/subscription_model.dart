import 'package:wired_express/data/model/response/subscription_feature_model.dart';

class SubscriptionModel {
  int? _id;
  String? _name;
  String? _price;
  String? _frequency;
  bool? _usePlan;
  List<SubscriptionFeatureModel>? _features;

  SubscriptionModel({
    int? id,
    String? name,
    String? price,
    String? frequency,
    bool? usePlan,
    List<SubscriptionFeatureModel>? features,
  }) {
    this._id = id;
    this._name = name;
    this._price = price;
    this._frequency = frequency;
    this._usePlan = usePlan;
    this._features = features;
  }

  int? get id => _id;
  String? get name => _name;
  String? get price => _price;
  String? get frequency => _frequency;
  bool? get usePlan => _usePlan;
  List<SubscriptionFeatureModel>? get features => _features;

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _price = json['price'] == null ? "0.0" : json['price'].toString();
    _frequency = json['frequency'];
    _usePlan = json['use_plan'];
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
    if (this._features != null) {
      data['features'] = this._features!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
