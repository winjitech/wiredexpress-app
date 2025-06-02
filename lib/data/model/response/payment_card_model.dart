class PaymentCardModel {
  String? _id;
  String? _brand;
  String? _last4;

  PaymentCardModel({
    String? id,
    String? brand,
    String? last4,
  }) {
    this._id = id;
    this._brand = brand;
    this._last4 = last4;
  }

  String? get id => _id;
  String? get brand => _brand;
  String? get last4 => _last4;

  PaymentCardModel.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _brand = json['brand'];
    _last4 = json['last4'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['id'] = this._id;
    data['brand'] = this._brand;
    data['last4'] = this._last4;

    return data;
  }
}
