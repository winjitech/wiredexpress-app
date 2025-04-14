import 'dart:convert';

import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';

class CartModel {
  int? _id;
  int? _productId;
  int? _quantity;

  ProductModel? _product;
  TiredPricingModel? _tieredPricing;

  CartModel({
    required int? id,
    required int? productId,
    required int? quantity,
    required ProductModel? product,
    required TiredPricingModel? tieredPricing,
  }) {
    _id = id;
    _productId = productId;
    _quantity = quantity;

    _product = product;
    _tieredPricing = tieredPricing;
  }

  int? get id => _id;
  int? get productId => _productId;
  int? get quantity => _quantity;

  ProductModel? get product => _product;
  TiredPricingModel? get tieredPricing => _tieredPricing;
  set quantity(int? value) {
    _quantity = value;
  }

  CartModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _quantity = json['quantity'];

    _product =
        json['product'] != null ? ProductModel.fromJson(json['product']) : null;
    _tieredPricing = json['tiered_pricing'] != null
        ? TiredPricingModel.fromJson(json['tiered_pricing'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['product_id'] = _productId;
    data['quantity'] = _quantity;

    if (_product != null) {
      data['product'] = _product!.toJson();
    }
    if (_tieredPricing != null) {
      data['tiered_pricing'] = _tieredPricing!.toJson();
    }
    return data;
  }
}
