class ProductPlanDiscountModel {
  int? _productId;
  int? _planId;
  double? _discount;
  String? _discountType;

  ProductPlanDiscountModel({
    int? productId,
    int? planId,
    double? discount,
    String? discountType,
  }) {
    this._productId = productId;
    this._planId = planId;
    this._discount = discount;
    this._discountType = discountType;
  }

  int? get productId => _productId;
  int? get planId => _planId;
  double? get discount => _discount;
  String? get discountType => _discountType;

  ProductPlanDiscountModel.fromJson(Map<String?, dynamic> json) {
    _productId = json['product_id'];
    _planId = json['plan_id'];
    _discount = json['discount'] != null
        ? double.tryParse(json['discount'].toString())
        : null;
    _discountType = json['discount_type'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['product_id'] = this._productId;
    data['plan_id'] = this._planId;
    data['discount'] = this._discount;
    data['discount_type'] = this._discountType;
    return data;
  }
}
