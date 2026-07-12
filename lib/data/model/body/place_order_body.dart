import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';

class PlaceOrderBody {
  List<ProductCart>? _cart;
  double? _couponDiscountAmount;
  double? _usePointsDiscountAmount;
  String? _couponDiscountTitle;
  String? _totalTaxAmount;
  double? _orderAmount;
  String? _orderType;
  int? _deliveryAddressId;
  String? _paymentMethod;
  String? _orderNote;
  String? _couponCode;
  // String? _deliveryDateTime;
  int? _usePoints;
  double? _remainingUserPoints;
  double? _deliveryCharge;
  int? _priorityDelivery;
  String? _cardId;
  String? _deliveryDate;
  String? _deliveryTime;
  bool? _useInstallment;
  int? _months;
  double? _downPayment;
  double? _monthlyPayment;
  PlaceOrderBody({
    required List<ProductCart> cart,
    required double couponDiscountAmount,
    required double usePointsDiscountAmount,
    required String couponDiscountTitle,
    required String couponCode,
    required String totalTaxAmount,
    required double orderAmount,
    required int deliveryAddressId,
    required String orderType,
    required String paymentMethod,
    required String orderNote,
    // required String deliveryDateTime,
    required String deliveryDate,
    required String deliveryTime,
    required int usePoints,
    required double remainingUserPoints,
    required double deliveryCharge,
    required int priorityDelivery,
    required String cardId,
    required  bool useInstallment,
    int? months,
    double? downPayment,
    double? monthlyPayment,
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
    // this._deliveryDateTime = deliveryDateTime;
    this._deliveryDate = deliveryDate;
    this._deliveryTime = deliveryTime;

    this._usePoints = usePoints;
    this._usePointsDiscountAmount = usePointsDiscountAmount;
    this._remainingUserPoints = remainingUserPoints;
    this._deliveryCharge = deliveryCharge;
    this._priorityDelivery = priorityDelivery;
    this._cardId = cardId;
    _useInstallment = useInstallment;
    _months = months;
    _downPayment = downPayment;
    _monthlyPayment = monthlyPayment;
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
  // String? get deliveryDateTime => _deliveryDateTime;
  String? get deliveryDate => _deliveryDate;
  String? get deliveryTime => _deliveryTime;
  int? get usePoints => _usePoints;
  double? get usePointsDiscountAmount => _usePointsDiscountAmount;
  double? get remainingUserPoints => _remainingUserPoints;
  double? get deliveryCharge => _deliveryCharge;
  int? get priorityDelivery => _priorityDelivery;
  String? get cardId => _cardId;
  bool? get useInstallment => _useInstallment;
  int? get months => _months;
  double? get downPayment => _downPayment;
  double? get monthlyPayment => _monthlyPayment;
  PlaceOrderBody.fromJson(Map<String?, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart']!.forEach((v) {
        _cart!.add(ProductCart.fromJson(v));
      });
    }
    _couponDiscountAmount = json['coupon_discount_amount'];
    _usePointsDiscountAmount = json['use_points_discount_amount'];
    _couponDiscountTitle = json['coupon_discount_title'];
    _orderAmount = json['order_amount'];
    _totalTaxAmount = json['total_tax_amount'];
    _orderType = json['order_type'];
    _deliveryAddressId = json['delivery_address_id'];
    _paymentMethod = json['payment_method'];
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
    // _deliveryDateTime = json['delivery_date_time'];
    _usePoints = json['use_points'];
    _remainingUserPoints = json['remaining_user_points'];
    _deliveryCharge = json['delivery_charge'];
    _priorityDelivery = json['priority_delivery'];
    _cardId = json['card_id'];
    _deliveryDate = json['delivery_date'];
    _deliveryTime = json['delivery_time'];
    _useInstallment = json['use_installment'];
    _months = json['months'];
    _downPayment = json['down_payment']?.toDouble();
    _monthlyPayment = json['monthly_payment']?.toDouble();
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = {};
    if (_cart != null) {
      data['cart'] = _cart!.map((v) => v.toJson()).toList();
    }
    data['coupon_discount_amount'] = _couponDiscountAmount;
    data['use_points_discount_amount'] = _usePointsDiscountAmount;
    data['coupon_discount_title'] = _couponDiscountTitle;
    data['order_amount'] = _orderAmount;
    data['total_tax_amount'] = _totalTaxAmount;
    data['order_type'] = _orderType;
    data['delivery_address_id'] = _deliveryAddressId;
    data['payment_method'] = _paymentMethod;
    data['order_note'] = _orderNote;
    data['coupon_code'] = _couponCode;
    // data['delivery_date_time'] = _deliveryDateTime;
    data['use_points'] = _usePoints;
    data['remaining_user_points'] = _remainingUserPoints;
    data['delivery_charge'] = _deliveryCharge;
    data['priority_delivery'] = _priorityDelivery;
    data['card_id'] = _cardId;
    data['delivery_date'] = _deliveryDate;
    data['delivery_time'] = _deliveryTime;
    data['use_installment'] = _useInstallment;
    data['months'] = _months;
    data['down_payment'] = _downPayment;
    data['monthly_payment'] = _monthlyPayment;
    return data;
  }
}

class ProductCart {
  String _productId;
  String _price;
  double _discountAmount;
  int _quantity;
  double _taxAmount;
  TiredPricingModel? _tieredPricing;

  ProductCart({
    required String productId,
    required String price,
    required double discountAmount,
    required int quantity,
    required double taxAmount,
    TiredPricingModel? tieredPricing,
  })  : _productId = productId,
        _price = price,
        _discountAmount = discountAmount,
        _quantity = quantity,
        _taxAmount = taxAmount;

  String get productId => _productId;
  String get price => _price;
  double get discountAmount => _discountAmount;
  int get quantity => _quantity;
  double get taxAmount => _taxAmount;
  TiredPricingModel? get tieredPricing => _tieredPricing;

  ProductCart.fromJson(Map<String, dynamic> json)
      : _productId = json['product_id'],
        _price = json['price'],
        _discountAmount = json['discount_amount'],
        _quantity = json['quantity'],
        _taxAmount = json['tax_amount'],
        _tieredPricing = json['tiered_pricing'] != null
            ? TiredPricingModel.fromJson(json['tiered_pricing'])
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['product_id'] = _productId;
    data['price'] = _price;
    data['discount_amount'] = _discountAmount;
    data['quantity'] = _quantity;
    data['tax_amount'] = _taxAmount;
    if (_tieredPricing != null) {
      data['tiered_pricing'] = _tieredPricing!.toJson();
    }

    return data;
  }
}
