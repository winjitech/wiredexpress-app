import 'package:wired_express/data/model/response/moq_setting_model.dart';
import 'package:wired_express/data/model/response/product_plan_discount_model.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';

class ProductBody {
  int? _totalSize;
  String? _limit;
  String? _offset;
  List<ProductModel>? _products;

  ProductBody(
      {int? totalSize,
      String? limit,
      String? offset,
      List<ProductModel>? products}) {
    this._totalSize = totalSize;
    this._limit = limit;
    this._offset = offset;
    this._products = products;
  }

  int? get totalSize => _totalSize;
  String? get limit => _limit;
  String? get offset => _offset;
  List<ProductModel>? get products => _products;

  ProductBody.fromJson(Map<String?, dynamic> json) {
    _totalSize = json['total_size'];
    if (json['limit'] is int?) {
      _limit = json['limit'].toString();
    } else {
      _limit = json['limit'];
    }

    _offset = json['offset'].toString();
    if (json['products'] != null) {
      _products = [];
      json['products']!.forEach((v) {
        _products!.add(new ProductModel.fromJson(v));
      });
    }
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['total_size'] = this._totalSize;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._products != null) {
      data['products'] = this._products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductModel {
  int? _id;
  String? _name;
  String? _description;
  String? _image;
  double? _price;
  List<TiredPricingModel>? _tiredPricing;
  double? _tax;
  String? _availableTimeStarts;
  String? _availableTimeEnds;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  double? _discount;
  String? _discountType;
  String? _taxType;
  int? _setMenu;
  List<Rating>? _rating;
  String? _matchedTag;
  String? _availability;
  int? _isEarlyProduct;
  // MoqSettingModel? _moqSetting;
  List<ProductPlanDiscountModel>? _productPlanDiscount;
  int? _minimumOrderQuantity;
  int? _isService;
  ProductModel({
    int? id,
    String? name,
    String? description,
    String? image,
    double? price,
    List<TiredPricingModel>? tiredPricing,
    double? tax,
    String? availableTimeStarts,
    String? availableTimeEnds,
    int? status,
    String? createdAt,
    String? updatedAt,
    double? discount,
    String? discountType,
    String? taxType,
    int? setMenu,
    List<Rating>? rating,
    String? matchedTag,
    String? availability,
    // MoqSettingModel? moqSetting,
    int? isEarlyProduct,
    List<ProductPlanDiscountModel>? productPlanDiscount,
    int? minimumOrderQuantity,
    int? isService,
  }) {
    this._id = id;
    this._name = name;
    this._description = description;
    this._image = image;
    this._price = price;
    this._tiredPricing = tiredPricing;
    this._tax = tax;
    this._availableTimeStarts = availableTimeStarts;
    this._availableTimeEnds = availableTimeEnds;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._discount = discount;
    this._discountType = discountType;
    this._taxType = taxType;
    this._setMenu = setMenu;
    this._rating = rating;
    this._matchedTag = matchedTag;
    this._availability = availability;
    // this._moqSetting = moqSetting;
    this._productPlanDiscount = productPlanDiscount;
    this._isEarlyProduct = isEarlyProduct;
    this._minimumOrderQuantity = minimumOrderQuantity;
    this._isService = isService;
  }

  int? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get image => _image;
  double? get price => _price;
  List<TiredPricingModel>? get tiredPricing => _tiredPricing;
  double? get tax => _tax;
  String? get availableTimeStarts => _availableTimeStarts;
  String? get availableTimeEnds => _availableTimeEnds;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  double? get discount => _discount;
  String? get discountType => _discountType;
  String? get taxType => _taxType;
  String? get matchedTag => _matchedTag;
  int? get setMenu => _setMenu;
  List<Rating>? get rating => _rating;
  String? get availability => _availability;
  // MoqSettingModel? get moqSetting => _moqSetting;
  List<ProductPlanDiscountModel>? get productPlanDiscount =>
      _productPlanDiscount;
  int? get isEarlyProduct => _isEarlyProduct;
  int? get minimumOrderQuantity => _minimumOrderQuantity;
  int? get isService => _isService;
  ProductModel.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _image = json['image'];

    _price = (json['price'] as num).toDouble();

    if (json['tired_pricing'] != null) {
      _tiredPricing = [];
      json['tired_pricing']!.forEach((v) {
        _tiredPricing!.add(new TiredPricingModel.fromJson(v));
      });
    }
    if (json['plan_discounts'] != null) {
      _productPlanDiscount = [];
      json['plan_discounts']!.forEach((v) {
        _productPlanDiscount!.add(new ProductPlanDiscountModel.fromJson(v));
      });
    }

    _tax = (json['tax'] as num?)?.toDouble() ?? 0.0;
    _availableTimeStarts = json['available_time_starts'];
    _availableTimeEnds = json['available_time_ends'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];

    _discount = (json['discount'] as num).toDouble();
    _discountType = json['discount_type'];
    _taxType = json['tax_type'];
    _setMenu = json['set_menu'];
    _matchedTag = json['matchedTag'] ?? '';
    _availability = json['availability'];
    _isEarlyProduct = json['is_early_product'];
    if (json['rating'] != null) {
      _rating = [];
      json['rating']!.forEach((v) {
        _rating!.add(new Rating.fromJson(v));
      });
    } else {
      _rating = [];
    }
    // _moqSetting = json['moq_setting'] != null
    //     ? MoqSettingModel.fromJson(json['moq_setting'])
    //     : null;
    _minimumOrderQuantity = json['minimum_order_quantity'];
    _isService = json['is_service'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['name_ar'] = this._name;
    data['description'] = this._description;
    data['image'] = this._image;
    data['price'] = this._price;

    if (this._tiredPricing != null) {
      data['tired_pricing'] =
          this._tiredPricing!.map((v) => v.toJson()).toList();
    }

    if (this._productPlanDiscount != null) {
      data['plan_discounts'] =
          this._productPlanDiscount!.map((v) => v.toJson()).toList();
    }
    data['tax'] = this._tax;
    data['available_time_starts'] = this._availableTimeStarts;
    data['available_time_ends'] = this._availableTimeEnds;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;

    data['discount'] = this._discount;
    data['discount_type'] = this._discountType;
    data['tax_type'] = this._taxType;
    data['set_menu'] = this._setMenu;
    data['matchedTag'] = this._matchedTag ?? '';
    data['availability'] = this._availability;
    data['is_early_product'] = this._isEarlyProduct;
    if (this._rating != null) {
      data['rating'] = this._rating!.map((v) => v.toJson()).toList();
    }
    // if (this._moqSetting != null) {
    //   data['moq_setting'] = this._moqSetting!.toJson();
    // }
    data['minimum_order_quantity'] = this._minimumOrderQuantity;
    data['is_service'] = this._isService;
    return data;
  }
}

class Rating {
  String? _average;
  int? _productId;

  Rating({String? average, int? productId}) {
    this._average = average;
    this._productId = productId;
  }

  String? get average => _average;
  int? get productId => _productId;

  Rating.fromJson(Map<String?, dynamic> json) {
    _average = json['average'];
    _productId = json['product_id'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['average'] = this._average;
    data['product_id'] = this._productId;
    return data;
  }
}
