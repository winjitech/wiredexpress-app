class ZonesModel {
  int? _id;
  String? _name;
  double? _deliveryFee;

  ZonesModel({
    int? id,
    String? name,
    double? deliveryFee,
  }) {
    this._id = id;
    this._name = name;
    this._deliveryFee = deliveryFee;
  }

  int? get id => _id;
  String? get name => _name;

  double? get deliveryFee => _deliveryFee;

  ZonesModel.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _deliveryFee = json['delivery_fee']?.toDouble();
    _name = json['name'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['delivery_fee'] = this._deliveryFee;

    return data;
  }
}
