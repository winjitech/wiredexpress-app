import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';

class OrderDetailsModel {
  int? _id;
  int? _productId;
  int? _orderId;
  double? _price;
  Product? _productDetails;
  double? _discountOnProduct;
  String? _discountType;
  int? _quantity;
  double? _taxAmount;
  String? _createdAt;
  String? _updatedAt;
  TiredPricingModel? _tieredPricing;

  OrderDetailsModel(
      {int? id,
        int? productId,
        int? orderId,
        double? price,
        Product? productDetails,
        double? discountOnProduct,
        String? discountType,
        int? quantity,
        double? taxAmount,
        String? createdAt,
        String? updatedAt,
        TiredPricingModel? tieredPricing}) {
    this._id = id;
    this._productId = productId;
    this._orderId = orderId;
    this._price = price;
    this._productDetails = productDetails;
    this._discountOnProduct = discountOnProduct;
    this._discountType = discountType;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._tieredPricing = tieredPricing;
  }

  int? get id => _id;
  int? get productId => _productId;
  int? get orderId => _orderId;
  double? get price => _price;
  Product? get productDetails => _productDetails;
  double? get discountOnProduct => _discountOnProduct;
  String? get discountType => _discountType;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  TiredPricingModel? get tieredPricing => _tieredPricing;

  OrderDetailsModel.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _orderId = json['order_id'];

    _price = (json['price'] as num).toDouble();
    _productDetails = json['product_details'] != null
        ? new Product.fromJson(json['product_details'])
        : null;

    _discountOnProduct = (json['discount_on_product'] as num).toDouble();

    _discountType = json['discount_type'];
    _quantity = json['quantity'];
    _taxAmount = (json['tax_amount'] as num).toDouble();

    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _tieredPricing = json['tiered_pricing'] != null
        ? TiredPricingModel.fromJson(json['tiered_pricing'])
        : null;
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['id'] = this._id;
    data['product_id'] = this._productId;
    data['order_id'] = this._orderId;
    data['price'] = this._price;
    if (this._productDetails != null) {
      data['product_details'] = this._productDetails!.toJson();
    }

    data['discount_on_product'] = this._discountOnProduct;
    data['discount_type'] = this._discountType;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    if (_tieredPricing != null) {
      data['tiered_pricing'] = _tieredPricing!.toJson();
    }
    return data;
  }
}
