import 'package:wired_express/data/model/response/product_model.dart';

// class WishListModel {
//   int? id;
//   int? userId;
//   int? productId;
//   String? createdAt;
//   String? updatedAt;
//
//   WishListModel(
//       {this.id, this.userId, this.productId, this.createdAt, this.updatedAt});
//
//   WishListModel.fromJson(Map<String?, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     productId = json['product_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String?, dynamic> toJson() {
//     final Map<String?, dynamic> data = new Map<String?, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['product_id'] = this.productId;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

class WishlistModel {
  int? _id;
  int? _userId;
  int? _productId;
  String? _createdAt;
  String? _updatedAt;
  Product? _product;

  WishlistModel({
    int? id,
    int? userId,
    int? productId,
    String? createdAt,
    String? updatedAt,
    Product? product,
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
  Product? get product => _product;

  WishlistModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _productId = json['product_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _product = json['product'] != null ? Product.fromJson(json['product']) : null;

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