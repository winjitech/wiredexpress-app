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
  String? _deliveryType;
  String? _deliveryDate;
  String? _deliveryTime;
  int? _usePoints;

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
    int? deliveryManId,
    double? deliveryCharge,
    String? orderNote,
    List<Details>? details,
    DeliveryMan? deliveryMan,
    DeliveryAddress? deliveryAddress,
    int? detailsCount,
    String? deliveryType,
    String? deliveryDate,
    String? deliveryTime,
    int? usePoints,
  }) {
    _id = id;
    _userId = userId;
    _orderAmount = orderAmount;
    _couponDiscountAmount = couponDiscountAmount;
    _couponDiscountTitle = couponDiscountTitle;
    _paymentStatus = paymentStatus;
    _orderStatus = orderStatus;
    _totalTaxAmount = totalTaxAmount;
    _paymentMethod = paymentMethod;
    _transactionReference = transactionReference;
    _deliveryAddressId = deliveryAddressId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deliveryManId = deliveryManId;
    _deliveryCharge = deliveryCharge;
    _orderNote = orderNote;
    _details = details;
    _deliveryMan = deliveryMan;
    _deliveryAddress = deliveryAddress;
    _detailsCount = detailsCount;
    _deliveryType = deliveryType;
    _deliveryDate = deliveryDate;
    _deliveryTime = deliveryTime;
    _usePoints = usePoints;
  }

  int? get id => _id;
  int? get userId => _userId;
  double? get orderAmount => _orderAmount;
  double? get couponDiscountAmount => _couponDiscountAmount;
  String? get couponDiscountTitle => _couponDiscountTitle;
  String? get paymentStatus => _paymentStatus;
  String? get orderStatus => _orderStatus;
  double? get totalTaxAmount => _totalTaxAmount;
  String? get paymentMethod => _paymentMethod;
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
  String? get deliveryType => _deliveryType;
  String? get deliveryDate => _deliveryDate;
  String? get deliveryTime => _deliveryTime;
  int? get usePoints => _usePoints;

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
    _deliveryType = json['delivery_type'];
    _deliveryDate = json['delivery_date'];
    _deliveryTime = json['delivery_time'];
    _usePoints = json['use_points'];

    if (json['details'] != null) {
      _details = [];
      json['details']!.forEach((v) {
        _details!.add(Details.fromJson(v));
      });
    }
    _deliveryMan = json['delivery_man'] != null
        ? DeliveryMan.fromJson(json['delivery_man'])
        : null;
    _deliveryAddress = json['delivery_address'] != null
        ? DeliveryAddress.fromJson(json['delivery_address'])
        : null;
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = {};
    data['id'] = _id;
    data['user_id'] = _userId;
    data['order_amount'] = _orderAmount;
    data['coupon_discount_amount'] = _couponDiscountAmount;
    data['coupon_discount_title'] = _couponDiscountTitle;
    data['payment_status'] = _paymentStatus;
    data['order_status'] = _orderStatus;
    data['total_tax_amount'] = _totalTaxAmount;
    data['payment_method'] = _paymentMethod;
    data['transaction_reference'] = _transactionReference;
    data['delivery_address_id'] = _deliveryAddressId;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['delivery_man_id'] = _deliveryManId;
    data['delivery_charge'] = _deliveryCharge;
    data['order_note'] = _orderNote;
    data['details_count'] = _detailsCount;
    data['delivery_type'] = _deliveryType;
    data['delivery_date'] = _deliveryDate;
    data['delivery_time'] = _deliveryTime;
    data['use_points'] = _usePoints;

    if (_details != null) {
      data['details'] = _details!.map((v) => v.toJson()).toList();
    }
    if (_deliveryMan != null) {
      data['delivery_man'] = _deliveryMan!.toJson();
    }
    if (_deliveryAddress != null) {
      data['delivery_address'] = _deliveryAddress!.toJson();
    }
    return data;
  }
}

class Details {
  int? _id;
  int? _productId;
  int? _orderId;
  double? _price;
  ProductModel? _productDetails;
  double? _discountOnProduct;
  String? _discountType;
  int? _quantity;
  double? _taxAmount;
  String? _createdAt;
  String? _updatedAt;
  String? _image;
  Details(
      {int? id,
        int? productId,
        int? orderId,
        double? price,
        ProductModel? productDetails,
        double? discountOnProduct,
        String? discountType,
        int? quantity,
        double? taxAmount,
        String? createdAt,
        String? updatedAt,
        String? image}) {
    this._id = id;
    this._image = image;
    this._productId = productId;
    this._orderId = orderId;
    this._price = price;
    this._productDetails = productDetails;
    this._discountOnProduct = discountOnProduct;
    this._discountType = discountType;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int? get id => _id;
  String? get image => _image;
  int? get productId => _productId;
  int? get orderId => _orderId;
  double? get price => _price;
  ProductModel? get productDetails => _productDetails;
  double? get discountOnProduct => _discountOnProduct;
  String? get discountType => _discountType;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Details.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _orderId = json['order_id'];
    _image = json['image'];

    _price = (json['price'] as num).toDouble();

    _discountOnProduct = (json['discount_on_product'] as num).toDouble();
    _discountType = json['discount_type'];
    _quantity = json['quantity'];

    _taxAmount = (json['tax_amount'] as num).toDouble();
    _createdAt = json['created_at'];
    _productDetails = json['product_details'] != null
        ? ProductModel.fromJson(json['product_details'])
        : null;
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

    data['discount_on_product'] = this._discountOnProduct;
    data['discount_type'] = this._discountType;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;

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
