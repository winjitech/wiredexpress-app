import 'package:wired_express/data/model/response/product_model.dart';

class OrdersItems {
  int? _totalSize;
  String? _limit;
  String? _offset;
  int? _totalPrice;
  List<OrderModel>? _orders;

  OrdersItems(
      {int? totalSize,
      String? limit,
      String? offset,
      int? totalPrice,
      List<OrderModel>? orders}) {
    this._totalSize = totalSize;
    this._limit = limit;
    this._offset = offset;
    this._totalPrice = totalPrice;
    this._orders = orders;
  }

  int? get totalSize => _totalSize;
  String? get limit => _limit;
  String? get offset => _offset;
  int? get totalPrice => _totalPrice;
  List<OrderModel>? get orders => _orders;

  OrdersItems.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'].toString();
    _offset = json['offset'];
    _totalPrice = json['total_price'];
    if (json['orders'] != null) {
      _orders = [];
      json['orders'].forEach((v) {
        _orders!.add(new OrderModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this._totalSize;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    data['total_price'] = this._totalPrice;
    if (this._orders != null) {
      data['orders'] = this._orders!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class OrderModel {
  int? _id;
  int? _userId;
  double? _orderAmount;
  double? _couponDiscountAmount;
  String? _couponDiscountTitle;
  String? _paymentStatus;
  String? _orderStatus;
  double? _totalTaxAmount;
  String? _paymentMethod;
  String? _transactionReference;
  int? _deliveryAddressId;
  String? _createdAt;
  String? _updatedAt;
  int? _deliveryManId;
  double? _deliveryCharge;
  String? _orderNote;
  List<Details>? _details;
  DeliveryMan? _deliveryMan;
  DeliveryAddress? _deliveryAddress;
  int? _detailsCount;
  String? _orderType;

  OrderModel({
    int? id,
    int? userId,
    double? orderAmount,
    double? couponDiscountAmount,
    String? couponDiscountTitle,
    String? paymentStatus,
    String? orderStatus,
    double? totalTaxAmount,
    String? paymentMethod,
    String? transactionReference,
    int? deliveryAddressId,
    String? createdAt,
    String? updatedAt,
    String? checked,
    int? deliveryManId,
    double? deliveryCharge,
    String? orderNote,
    List<Details>? details,
    DeliveryMan? deliveryMan,
    DeliveryAddress? deliveryAddress,
    int? detailsCount,
    String? orderType,
    String? gift,
  }) {
    this._id = id;
    this._userId = userId;
    this._orderAmount = orderAmount;
    this._couponDiscountAmount = couponDiscountAmount;
    this._couponDiscountTitle = couponDiscountTitle;
    this._paymentStatus = paymentStatus;
    this._orderStatus = orderStatus;
    this._totalTaxAmount = totalTaxAmount;
    this._paymentMethod = paymentMethod;
    this._transactionReference = transactionReference;
    this._deliveryAddressId = deliveryAddressId;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._deliveryManId = deliveryManId;
    this._deliveryCharge = deliveryCharge;
    this._orderNote = orderNote;
    this._details = details;
    this._deliveryMan = deliveryMan;
    this._deliveryAddress = deliveryAddress;
    this._detailsCount = detailsCount;
    this._orderType = orderType;
  }

  int? get id => _id;
  int? get userId => _userId;
  double? get orderAmount => _orderAmount;
  double? get couponDiscountAmount => _couponDiscountAmount;
  String? get couponDiscountTitle => _couponDiscountTitle;
  String? get paymentStatus => _paymentStatus;
  String? get orderStatus => _orderStatus;
  double? get totalTaxAmount => _totalTaxAmount;
  // ignore: unnecessary_getters_setters
  String? get paymentMethod => _paymentMethod;
  // ignore: unnecessary_getters_setters
  set paymentMethod(String? method) => _paymentMethod = method;
  String? get transactionReference => _transactionReference;
  int? get deliveryAddressId => _deliveryAddressId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get deliveryManId => _deliveryManId;
  double? get deliveryCharge => _deliveryCharge;
  String? get orderNote => _orderNote;

  List<Details>? get details => _details;
  DeliveryMan? get deliveryMan => _deliveryMan;
  DeliveryAddress? get deliveryAddress => _deliveryAddress;
  int? get detailsCount => _detailsCount;
  String? get orderType => _orderType;
  OrderModel.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];

    _orderAmount = (json['order_amount'] as num).toDouble();
    _couponDiscountAmount = (json['coupon_discount_amount'] as num).toDouble();
    _couponDiscountTitle = json['coupon_discount_title'];
    _paymentStatus = json['payment_status'];
    _orderStatus = json['order_status'];

    _totalTaxAmount = (json['total_tax_amount'] as num).toDouble();

    _paymentMethod = json['payment_method'];
    _transactionReference = json['transaction_reference'];
    _deliveryAddressId = json['delivery_address_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deliveryManId = json['delivery_man_id'];

    _deliveryCharge = (json['delivery_charge'] as num).toDouble();
    _orderNote = json['order_note'];

    _detailsCount = json['details_count'] as int? ?? 0;

    if (json['details'] != null) {
      _details = [];
      json['details']!.forEach((v) {
        _details!.add(Details.fromJson(v));
      });
    }
    _deliveryMan = json['delivery_man'] != null
        ? DeliveryMan.fromJson(json['delivery_man'])
        : null;
    _orderType = json['order_type'];
    _deliveryAddress = json['delivery_address'] != null
        ? DeliveryAddress.fromJson(json['delivery_address'])
        : null;
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['order_amount'] = this._orderAmount;
    data['coupon_discount_amount'] = this._couponDiscountAmount;
    data['coupon_discount_title'] = this._couponDiscountTitle;
    data['payment_status'] = this._paymentStatus;
    data['order_status'] = this._orderStatus;
    data['total_tax_amount'] = this._totalTaxAmount;
    data['payment_method'] = this._paymentMethod;
    data['transaction_reference'] = this._transactionReference;
    data['delivery_address_id'] = this._deliveryAddressId;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['delivery_man_id'] = this._deliveryManId;
    data['delivery_charge'] = this._deliveryCharge;
    data['order_note'] = this._orderNote;

    data['details_count'] = this._detailsCount;
    if (this._details != null) {
      data['details'] = this._details!.map((v) => v.toJson()).toList();
    }
    if (this._deliveryMan != null) {
      data['delivery_man'] = this._deliveryMan!.toJson();
    }
    if (this._deliveryAddress != null) {
      data['delivery_address'] = this._deliveryAddress!.toJson();
    }
    data['order_type'] = this._orderType;

    return data;
  }
}

class Details {
  int? _id;
  int? _productId;
  int? _orderId;
  double? _price;
  Product? _productDetails;
  Variation? _variation;
  double? _discountOnProduct;
  String? _discountType;
  int? _quantity;
  double? _taxAmount;
  String? _createdAt;
  String? _updatedAt;
  String? _variant;
  String? _image;
  Details(
      {int? id,
      int? productId,
      int? orderId,
      double? price,
      Product? productDetails,
      Variation? variation,
      double? discountOnProduct,
      String? discountType,
      int? quantity,
      double? taxAmount,
      String? createdAt,
      String? updatedAt,
      String? image,
      String? variant}) {
    this._id = id;
    this._image = image;
    this._productId = productId;
    this._orderId = orderId;
    this._price = price;
    this._productDetails = productDetails;
    this._variation = variation;
    this._discountOnProduct = discountOnProduct;
    this._discountType = discountType;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;

    this._variant = variant;
  }

  int? get id => _id;
  String? get image => _image;
  int? get productId => _productId;
  int? get orderId => _orderId;
  double? get price => _price;
  Product? get productDetails => _productDetails;
  Variation? get variation => _variation;
  double? get discountOnProduct => _discountOnProduct;
  String? get discountType => _discountType;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get variant => _variant;

  Details.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _orderId = json['order_id'];
    _image = json['image'];

    _price = (json['price'] as num).toDouble();
    // _variation = json['variation'];
    _variation = json['variation'] != null
        ? Variation.fromJson(json['variation'])
        : null;
    _discountOnProduct = (json['discount_on_product'] as num).toDouble();
    _discountType = json['discount_type'];
    _quantity = json['quantity'];

    _taxAmount = (json['tax_amount'] as num).toDouble();
    _createdAt = json['created_at'];
    _productDetails = json['product_details'] != null
        ? Product.fromJson(json['product_details'])
        : null;

    _variant = json['variant'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['id'] = this._id;
    data['product_id'] = this._productId;
    data['order_id'] = this._orderId;
    data['image'] = this._image;
    data['price'] = this._price;
    if (_productDetails != null) {
      data['product_details'] = _productDetails!.toJson();
    }
    if (_variation != null) {
      data['variation'] = _variation!.toJson();
    }
    data['discount_on_product'] = this._discountOnProduct;
    data['discount_type'] = this._discountType;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;

    data['variant'] = this._variant;
    return data;
  }
}

class DeliveryAddress {
  int? _id;
  String? _addressType;
  String? _contactPersonNumber;
  String? _address;
  String? _latitude;
  String? _longitude;
  int? _isCurrent;
  String? _createdAt;
  String? _updatedAt;
  int? _userId;
  String? _contactPersonName;
  DeliveryAddress({
    int? id,
    String? addressType,
    String? contactPersonNumber,
    String? address,
    String? latitude,
    String? longitude,
    int? isCurrent,
    String? createdAt,
    String? updatedAt,
    int? userId,
    String? contactPersonName,
  }) {
    this._id = id;
    this._isCurrent = isCurrent;
    this._address = address;
    this._addressType = addressType;
    this._contactPersonNumber = contactPersonNumber;
    this._latitude = latitude;
    this._longitude = longitude;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._userId = userId;
    this._contactPersonName = contactPersonName;
  }

  int? get id => _id;
  String? get address => _address;
  String? get addressType => _addressType;
  int? get isCurrent => _isCurrent;
  int? get userId => _userId;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get contactPersonNumber => _contactPersonNumber;
  String? get contactPersonName => _contactPersonName;
// "delivery_address": {
// "id": 1,
// "address_type": "Home",
// "contact_person_number": "6666666",
// "address": "1650, Santa Clara County, US",
// "latitude": "37.42209351379723",
// "longitude": "-122.08392206579445",
// "is_current": 0,
// "created_at": "2024-03-03T21:23:06.000000Z",
// "updated_at": "2024-03-03T21:23:06.000000Z",
// "user_id": 8,
// "contact_person_name": "Address One"
// }

  DeliveryAddress.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _addressType = json['address_type'];
    _contactPersonNumber = json['contact_person_number'];
    _address = json['address'];
    _contactPersonName = json['contact_person_name'];
    _isCurrent = json['is_current'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['id'] = this._id;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['address_type'] = this._addressType;
    data['contact_person_number'] = this._contactPersonNumber;
    data['address'] = this._address;
    data['user_id'] = this._userId;
    data['contact_person_name'] = this._contactPersonName;
    data['is_current'] = this._isCurrent;

    return data;
  }
}

class DeliveryMan {
  int? _id;
  String? _fName;
  String? _lName;
  String? _phone;
  String? _email;
  String? _identityNumber;
  String? _identityType;
  String? _identityImage;
  String? _image;
  String? _latitude;
  String? _longitude;
  String? _password;
  String? _createdAt;
  String? _updatedAt;
  String? _authToken;
  List<Rating>? _rating;

  DeliveryMan(
      {int? id,
      String? fName,
      String? lName,
      String? phone,
      String? email,
      String? identityNumber,
      String? identityType,
      String? identityImage,
      String? image,
      String? latitude,
      String? longitude,
      String? password,
      String? createdAt,
      String? updatedAt,
      String? authToken,
      List<Rating>? rating}) {
    this._id = id;
    this._fName = fName;
    this._lName = lName;
    this._phone = phone;
    this._email = email;
    this._identityNumber = identityNumber;
    this._identityType = identityType;
    this._identityImage = identityImage;
    this._image = image;
    this._latitude = latitude;
    this._longitude = longitude;
    this._password = password;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._authToken = authToken;
    this._rating = rating;
  }

  int? get id => _id;
  String? get fName => _fName;
  String? get lName => _lName;
  String? get phone => _phone;
  String? get email => _email;
  String? get identityNumber => _identityNumber;
  String? get identityType => _identityType;
  String? get identityImage => _identityImage;
  String? get image => _image;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get password => _password;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get authToken => _authToken;
  List<Rating>? get rating => _rating;

  DeliveryMan.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _phone = json['phone'];
    _email = json['email'];
    _identityNumber = json['identity_number'];
    _identityType = json['identity_type'];
    _identityImage = json['identity_image'];
    _image = json['image'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _password = json['password'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _authToken = json['auth_token'];
    if (json['rating'] != null) {
      _rating = [];
      json['rating']!.forEach((v) {
        _rating!.add(new Rating.fromJson(v));
      });
    }
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['id'] = this._id;
    data['f_name'] = this._fName;
    data['l_name'] = this._lName;
    data['phone'] = this._phone;
    data['email'] = this._email;
    data['identity_number'] = this._identityNumber;
    data['identity_type'] = this._identityType;
    data['identity_image'] = this._identityImage;
    data['image'] = this._image;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['password'] = this._password;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['auth_token'] = this._authToken;
    if (this._rating != null) {
      data['rating'] = this._rating!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
