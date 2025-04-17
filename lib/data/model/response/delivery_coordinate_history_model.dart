
import 'dart:convert';

import 'dart:convert';

class DeliveryCoordinateHistoryModel {
  int? _id;
  int? _deliveryManId;
  int? _orderId;
  List<Map<String, double>>? _coordinates;
  String? _lastUpdate;
  String? _token;

  DeliveryCoordinateHistoryModel({
    int? id,
    int? deliveryManId,
    int? orderId,
    List<Map<String, double>>? coordinates,
    String? lastUpdate,
    String? token,
  }) {
    _id = id;
    _deliveryManId = deliveryManId;
    _orderId = orderId;
    _coordinates = coordinates;
    _lastUpdate = lastUpdate;
    _token = token;
  }

  int? get id => _id;
  int? get deliveryManId => _deliveryManId;
  int? get orderId => _orderId;
  List<Map<String, double>>? get coordinates => _coordinates;
  String? get lastUpdate => _lastUpdate;
  String? get token => _token;

  DeliveryCoordinateHistoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _deliveryManId = json['delivery_man_id'];
    _orderId = json['order_id'];
    _lastUpdate = json['last_update'];
    _token = json['token'];

    if (json['coordinates'] != null) {
      _coordinates = List<Map<String, double>>.from(
        json['coordinates'].map(
              (v) => {
            'latitude': (v['latitude'] as num).toDouble(),
            'longitude': (v['longitude'] as num).toDouble(),
          },
        ),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['delivery_man_id'] = _deliveryManId;
    data['order_id'] = _orderId;
    data['last_update'] = _lastUpdate;
    data['token'] = _token;

    if (_coordinates != null) {
      data['coordinates'] = jsonEncode(_coordinates);
    }

    return data;
  }
}
