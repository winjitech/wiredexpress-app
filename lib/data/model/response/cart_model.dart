import 'dart:convert';

import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';

class CartModel {
  int? _id;
  int? _userId;
  int? _productId;
  int? _quantity;
  String? _createdAt;
  String? _updatedAt;
  Product? _product;
  TiredPricingModel? _tieredPricing;

  CartModel({
    int? id,
    int? userId,
    int? productId,
    int? quantity,
    String? createdAt,
    String? updatedAt,
    Product? product,
    TiredPricingModel? tieredPricing,
  }) {
    _id = id;
    _userId = userId;
    _productId = productId;
    _quantity = quantity;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _product = product;
    _tieredPricing = tieredPricing;
  }

  int? get id => _id;
  int? get userId => _userId;
  int? get productId => _productId;
  int? get quantity => _quantity;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Product? get product => _product;
  TiredPricingModel? get tieredPricing => _tieredPricing;
  set quantity(int? value) {
    _quantity = value;
  }

  CartModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _productId = json['product_id'];
    _quantity = json['quantity'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
    _tieredPricing = json['tiered_pricing'] != null
        ? TiredPricingModel.fromJson(json['tiered_pricing'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['user_id'] = _userId;
    data['product_id'] = _productId;
    data['quantity'] = _quantity;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    if (_product != null) {
      data['product'] = _product!.toJson();
    }
    if (_tieredPricing != null) {
      data['tiered_pricing'] = _tieredPricing!.toJson();
    }
    return data;
  }
}
