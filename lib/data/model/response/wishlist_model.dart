import 'package:wired_express/data/model/response/product_model.dart';

class WishlistModel {
  int? _id;
  int? _userId;
  int? _productId;
  String? _createdAt;
  String? _updatedAt;
  ProductModel? _product;

  WishlistModel({
    int? id,
    int? userId,
    int? productId,
    String? createdAt,
    String? updatedAt,
    ProductModel? product,
  }) {
    this._id = id;
    this._userId = userId;
    this._productId = productId;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._product = product;
  }

  int? get id => _id;
  int? get userId => _userId;
  int? get productId => _productId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  ProductModel? get product => _product;

  WishlistModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _productId = json['product_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _product =
        json['product'] != null ? ProductModel.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['product_id'] = this._productId;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    if (_product != null) {
      data['product'] = _product!.toJson();
    }
    return data;
  }
}
