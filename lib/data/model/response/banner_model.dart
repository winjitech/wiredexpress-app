import 'package:wired_express/data/model/response/category_model.dart';

class BannerModel {
  int? _id;
  String? _title;
  String? _describe;
  String? _image;
  int? _productId;
  String? _createdAt;
  String? _updatedAt;
  int? _categoryId;
  CategoryModel? _category;

  BannerModel({
    int? id,
    String? title,
    String? describe,
    String? image,
    int? productId,
    String? createdAt,
    String? updatedAt,
    int? categoryId,
    CategoryModel? category,
  }) {
    _id = id;
    _title = title;
    _image = image;
    _describe = describe;
    _productId = productId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _categoryId = categoryId;
    _category = category;
  }

  int? get id => _id;
  String? get describe => _describe;
  String? get title => _title;
  String? get image => _image;
  int? get productId => _productId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get categoryId => _categoryId;
  CategoryModel? get category => _category;

  BannerModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _describe = json['description'];
    _title = json['title'];
    _image = json['image'];
    _productId = json['product_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _categoryId = json['category_id'];
    _category = json['category'] != null ? CategoryModel.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['title'] = _title;
    data['description'] = _describe;
    data['image'] = _image;
    data['product_id'] = _productId;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['category_id'] = _categoryId;
    if (_category != null) {
      data['category'] = _category!.toJson();
    }
    return data;
  }
}