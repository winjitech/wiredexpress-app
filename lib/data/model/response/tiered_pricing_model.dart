class TiredPricingModel {
  int? _productId;
  int? _minQuantity;
  String? _discountPrice;

  TiredPricingModel({int? productId, int? minQuantity, String? discountPrice}) {
    this._productId = productId;
    this._minQuantity = minQuantity;
    this._discountPrice = discountPrice;
  }

  int? get productId => _productId;
  int? get minQuantity => _minQuantity;
  String? get discountPrice => _discountPrice;

  TiredPricingModel.fromJson(Map<String?, dynamic> json) {
    _productId = json['product_id'];
    _minQuantity = json['min_quantity'];
    _discountPrice = json['discount_price'] == null
        ? null
        : json['discount_price'].toString();
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['product_id'] = this._productId;
    data['min_quantity'] = this._minQuantity;
    data['discount_price'] = this._discountPrice;
    return data;
  }
}
