import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';

class PlaceOrderBody {
  List<ProductCart>? _cart;
  double? _couponDiscountAmount;
  String? _couponDiscountTitle;
  String? _totalTaxAmount;
  double? _orderAmount;
  String? _orderType;
  int? _deliveryAddressId;
  String? _paymentMethod;
  String? _orderNote;
  String? _couponCode;
  int? _branchId;
  String? _deliveryDateTime;

  PlaceOrderBody({
    @required List<ProductCart>? cart,
    @required double? couponDiscountAmount,
    @required String? couponDiscountTitle,
    @required String? couponCode,
    @required String? totalTaxAmount,
    @required double? orderAmount,
    @required int? deliveryAddressId,
    @required String? orderType,
    @required String? paymentMethod,
    @required int? branchId,
    @required String? orderNote,
    @required String? deliveryDateTime,
  }) {
    this._cart = cart;
    this._couponDiscountAmount = couponDiscountAmount;
    this._couponDiscountTitle = couponDiscountTitle;
    this._orderAmount = orderAmount;
    this._totalTaxAmount = totalTaxAmount;
    this._orderType = orderType;
    this._deliveryAddressId = deliveryAddressId;
    this._paymentMethod = paymentMethod;
    this._orderNote = orderNote;
    this._couponCode = couponCode;
    this._branchId = branchId;
    this._deliveryDateTime = deliveryDateTime;
  }

  List<ProductCart>? get cart => _cart;
  double? get couponDiscountAmount => _couponDiscountAmount;
  String? get couponDiscountTitle => _couponDiscountTitle;
  double? get orderAmount => _orderAmount;
  String? get totalTaxAmount => _totalTaxAmount;
  String? get orderType => _orderType;
  int? get deliveryAddressId => _deliveryAddressId;
  String? get paymentMethod => _paymentMethod;
  String? get orderNote => _orderNote;
  String? get couponCode => _couponCode;
  int? get branchId => _branchId;
  String? get deliveryDateTime => _deliveryDateTime;

  PlaceOrderBody.fromJson(Map<String?, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart']!.forEach((v) {
        _cart!.add(new ProductCart.fromJson(v));
      });
    }
    _couponDiscountAmount = json['coupon_discount_amount'];
    _couponDiscountTitle = json['coupon_discount_title'];
    _orderAmount = json['order_amount'];
    _totalTaxAmount = json['total_tax_amount'];
    _orderType = json['order_type'];
    _deliveryAddressId = json['delivery_address_id'];
    _paymentMethod = json['payment_method'];
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
    _branchId = json['branch_id'];
    _deliveryDateTime = json['delivery_date_time'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    if (this._cart != null) {
      data['cart'] = this._cart!.map((v) => v.toJson()).toList();
    }
    data['coupon_discount_amount'] = this._couponDiscountAmount;
    data['coupon_discount_title'] = this._couponDiscountTitle;
    data['order_amount'] = this._orderAmount;
    data['total_tax_amount'] = this._totalTaxAmount;
    data['order_type'] = this._orderType;
    data['delivery_address_id'] = this._deliveryAddressId;
    data['payment_method'] = this._paymentMethod;
    data['order_note'] = this._orderNote;
    data['coupon_code'] = this._couponCode;
    data['branch_id'] = this._branchId;
    data['delivery_date_time'] = this._deliveryDateTime;
    return data;
  }
}

class ProductCart {
  String? _productId;
  String? _price;

  double? _discountAmount;
  int? _quantity;
  double? _taxAmount;
  TiredPricingModel? _tieredPricing;

  ProductCart(
      String? productId,
      String? price,
      double? discountAmount,
      int? quantity,
      double? taxAmount,
      TiredPricingModel? tieredPricing,
      ) {
    this._productId = productId;
    this._price = price;

    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._tieredPricing = tieredPricing;
  }

  String? get productId => _productId;
  String? get price => _price;
  double? get discountAmount => _discountAmount;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;
  TiredPricingModel? get tieredPricing => _tieredPricing;

  ProductCart.fromJson(Map<String?, dynamic> json) {
    _productId = json['product_id'];
    _price = json['price'];

    _discountAmount = json['discount_amount'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'];
    _tieredPricing = json['tiered_pricing'] != null
        ? TiredPricingModel.fromJson(json['tiered_pricing'])
        : null;
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['product_id'] = this._productId;
    data['price'] = this._price;

    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    if (_tieredPricing != null) {
      data['tiered_pricing'] = _tieredPricing!.toJson();
    }
    return data;
  }
}
