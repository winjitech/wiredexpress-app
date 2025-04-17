class TiredPricingModel {
  int? _productId;
  int? _minQuantity;
  String? _discountPrice;
  int? _planId;

  TiredPricingModel({
    int? productId,
    int? minQuantity,
    String? discountPrice,
    int? planId,
  }) {
    this._productId = productId;
    this._minQuantity = minQuantity;
    this._discountPrice = discountPrice;
    this._planId = planId;
  }

  int? get productId => _productId;
  int? get minQuantity => _minQuantity;
  String? get discountPrice => _discountPrice;
  int? get planId => _planId;

  TiredPricingModel.fromJson(Map<String?, dynamic> json) {
    _productId = json['product_id'];
    _minQuantity = json['min_quantity'];
    _discountPrice = json['discount_price'] == null
        ? null
        : json['discount_price'].toString();
    _planId = json['plan_id'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['product_id'] = this._productId;
    data['min_quantity'] = this._minQuantity;
    data['discount_price'] = this._discountPrice;
    data['plan_id'] = this._planId;
    return data;
  }
}
