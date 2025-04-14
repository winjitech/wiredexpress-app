import 'package:wired_express/data/model/response/area_model.dart';

class UserSubscriptionModel {
  int? _planId;
  String? _expiresAt;
  String? _status;

  UserSubscriptionModel({
    int? planId,
    String? expiresAt,
    String? status,
  }) {
    this._planId = planId;
    this._expiresAt = expiresAt;
    this._status = status;
  }

  int? get planId => _planId;
  String? get expiresAt => _expiresAt;
  String? get status => _status;

  UserSubscriptionModel.fromJson(Map<String?, dynamic> json) {
    _planId = json['plan_id'];
    _expiresAt = json['expires_at'];
    _status = json['status'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['plan_id'] = this._planId;
    data['expires_at'] = this._expiresAt;
    data['status'] = this._status;
    return data;
  }
}
