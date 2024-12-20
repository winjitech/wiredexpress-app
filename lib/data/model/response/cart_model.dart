import 'dart:convert';

import 'package:wired_express/data/model/response/product_model.dart';

class CartModel {
  int? _id;
  int? _userId;
  int? _productId;
  int? _quantity;
  String? _createdAt;
  String? _updatedAt;
  Product? _product;
  List<dynamic>? _variationIndex;

  CartModel({
    int? id,
    int? userId,
    int? productId,
    int? quantity,
    String? createdAt,
    String? updatedAt,
    Product? product,
    List<dynamic>? variationIndex,
  }) {
    this._id = id;
    this._userId = userId;
    this._productId = productId;
    this._quantity = quantity;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._product = product;
    this._variationIndex = variationIndex;
  }

  int? get id => _id;
  int? get userId => _userId;
  int? get productId => _productId;
  int? get quantity => _quantity;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Product? get product => _product;
  List<dynamic>? get variationIndex => _variationIndex;
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

    if (json.containsKey('variation_index') &&
        json['variation_index'] != null) {
      _variationIndex = jsonDecode(json['variation_index']);
    } else {
      _variationIndex = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['product_id'] = this._productId;
    data['quantity'] = this._quantity;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['variation_index'] = this._variationIndex;
    if (_product != null) {
      data['product'] = _product!.toJson();
    }
    data['variation_index'] = _variationIndex;
    return data;
  }
}
