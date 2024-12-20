import 'dart:convert';

class ConfigModel {
  String? _storeName;
  String? _storeOpenTime;
  String? _storeCloseTime;
  String? _storeLogo;
  String? _storeAddress;
  String? _storePhone;
  String? _storeEmail;
  BaseUrls? _baseUrls;
  List<OpeningHoursModel>? _openingHours;

  String? _currencySymbol;
  String? _deliveryCharge;
  String? _cashOnDelivery;
  String? _digitalPayment;
  String? _termsAndConditions;
  String? _privacyPolicy;
  String? _aboutUs;
  Map<String?, dynamic>? _storeLocationCoverage;
  double? _minimumOrderValue;
  String? _appVersion;
  String? _phoneOTP;
  String? _serviceMessages;

  ConfigModel(
      {String? storeName,
      String? storeOpenTime,
      String? storeCloseTime,
      String? storeLogo,
      String? storeAddress,
      String? storePhone,
      List<OpeningHoursModel>? openTime,
      String? storeEmail,
      BaseUrls? baseUrls,
      String? currencySymbol,
      String? deliveryCharge,
      String? cashOnDelivery,
      String? digitalPayment,
      String? termsAndConditions,
      String? privacyPolicy,
      String? aboutUs,
      //  Map<String?, dynamic>? storeLocationCoverage,
      double? minimumOrderValue,
      String? appVersion,
      String? phoneOTP,
      String? serviceMessages}) {
    this._storeName = storeName;
    this._storeOpenTime = storeOpenTime;
    this._storeCloseTime = storeCloseTime;
    this._storeLogo = storeLogo;
    this._storeAddress = storeAddress;
    this._storePhone = storePhone;
    this._openingHours = openTime;
    this._storeEmail = storeEmail;
    this._baseUrls = baseUrls;
    this._currencySymbol = currencySymbol;
    this._deliveryCharge = deliveryCharge;
    this._cashOnDelivery = cashOnDelivery;
    this._digitalPayment = digitalPayment;
    this._termsAndConditions = termsAndConditions;
    this._aboutUs = aboutUs;
    this._privacyPolicy = privacyPolicy;
//    this._storeLocationCoverage = storeLocationCoverage;
    this._minimumOrderValue = minimumOrderValue;
    this._appVersion = appVersion;
    this._phoneOTP = phoneOTP;
    this._serviceMessages = serviceMessages;
  }

  String? get storeName => _storeName;
  String? get storeOpenTime => _storeOpenTime;
  String? get storeCloseTime => _storeCloseTime;
  String? get storeLogo => _storeLogo;
  String? get storeAddress => _storeAddress;
  String? get storePhone => _storePhone;
  String? get storeEmail => _storeEmail;
  BaseUrls? get baseUrls => _baseUrls;
  String? get currencySymbol => _currencySymbol;
  String? get deliveryCharge => _deliveryCharge;
  String? get cashOnDelivery => _cashOnDelivery;
  String? get digitalPayment => _digitalPayment;
  List<OpeningHoursModel>? get openingHours => _openingHours;
  String? get termsAndConditions => _termsAndConditions;
  String? get aboutUs => _aboutUs;
  String? get privacyPolicy => _privacyPolicy;
//  Map<String?, dynamic>? get storeLocationCoverage => _storeLocationCoverage;
  double? get minimumOrderValue => _minimumOrderValue;
  String? get appVersion => _appVersion;
  String? get phoneOTP => _phoneOTP;
  String? get serviceMessages => _serviceMessages;

  ConfigModel.fromJson(Map<String?, dynamic> json) {
    _storeName = json['store_name'];
    _storeOpenTime = json['store_open_time'];
    _storeCloseTime = json['store_close_time'];
    _storeLogo = json['store_logo'];
    _storeAddress = json['store_address'];
    _storePhone = json['store_phone'];
    _storeEmail = json['store_email'];
    _baseUrls = json['base_urls'] != null
        ? new BaseUrls.fromJson(json['base_urls'])
        : null;
    _currencySymbol = json['currency_symbol'];
    _deliveryCharge = json['delivery_charge'];
    _cashOnDelivery = json['cash_on_delivery'];
    _digitalPayment = json['digital_payment'];
    _termsAndConditions = json['terms_and_conditions'];
    _privacyPolicy = json['privacy_policy'];
    _aboutUs = json['about_us'];
    //  _storeLocationCoverage = jsonDecode(json['store_location_coverage']);

    _minimumOrderValue = (json['minimum_order_value'] as num).toDouble();

    _appVersion = json['app_version'];
    _phoneOTP = json['phone_otp'];
    _serviceMessages = json['service_messages'];
    if (json['opening_hours'] != null) {
      _openingHours = [];
      json['opening_hours'].forEach((v) {
        _openingHours!.add(new OpeningHoursModel.fromJson(v));
      });
    }
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['store_name'] = this._storeName;
    data['store_open_time'] = this._storeOpenTime;
    data['store_close_time'] = this._storeCloseTime;
    data['store_logo'] = this._storeLogo;
    data['store_address'] = this._storeAddress;
    data['store_phone'] = this._storePhone;
    data['store_email'] = this._storeEmail;
    if (this._baseUrls != null) {
      data['base_urls'] = this._baseUrls!.toJson();
    }
    data['currency_symbol'] = this._currencySymbol;
    data['delivery_charge'] = this._deliveryCharge;
    data['cash_on_delivery'] = this._cashOnDelivery;
    data['digital_payment'] = this._digitalPayment;
    data['terms_and_conditions'] = this._termsAndConditions;
    data['privacy_policy'] = this.privacyPolicy;
    data['about_us'] = this.aboutUs;
    //  data['store_location_coverage'] = this.storeLocationCoverage;

    data['minimum_order_value'] = this._minimumOrderValue;

    data['app_version'] = this.appVersion;
    data['phone_otp'] = this.phoneOTP;

    if (this._openingHours != null) {
      data['opening_hours'] =
          this._openingHours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OpeningHoursModel {
  String? _start;
  String? _end;

  OpeningHoursModel({String? start, String? end}) {
    this._start = start;
    this._end = end;
  }

  String? get start => _start;
  String? get end => _end;

  OpeningHoursModel.fromJson(Map<String?, dynamic> json) {
    _start = json['start'];
    _end = json['end'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['start'] = this._start;
    data['end'] = this._end;

    return data;
  }
}

class BaseUrls {
  String? _productImageUrl;
  String? _customerImageUrl;
  String? _bannerImageUrl;
  String? _categoryImageUrl;
  String? _reviewImageUrl;
  String? _notificationImageUrl;
  String? _storeImageUrl;
  String? _contestImageUrl;
  String? _deliveryManImageUrl;
  String? _chatImageUrl;

  BaseUrls(
      {String? productImageUrl,
      String? customerImageUrl,
      String? bannerImageUrl,
      String? categoryImageUrl,
      String? reviewImageUrl,
      String? notificationImageUrl,
      String? storeImageUrl,
      String? contestImageUrl,
      String? deliveryManImageUrl,
      String? chatImageUrl}) {
    this._productImageUrl = productImageUrl;
    this._customerImageUrl = customerImageUrl;
    this._bannerImageUrl = bannerImageUrl;
    this._categoryImageUrl = categoryImageUrl;
    this._reviewImageUrl = reviewImageUrl;
    this._notificationImageUrl = notificationImageUrl;
    this._storeImageUrl = storeImageUrl;
    this._contestImageUrl = contestImageUrl;
    this._deliveryManImageUrl = deliveryManImageUrl;
    this._chatImageUrl = chatImageUrl;
  }

  String? get productImageUrl => _productImageUrl;
  String? get customerImageUrl => _customerImageUrl;
  String? get bannerImageUrl => _bannerImageUrl;
  String? get categoryImageUrl => _categoryImageUrl;
  String? get reviewImageUrl => _reviewImageUrl;
  String? get notificationImageUrl => _notificationImageUrl;
  String? get storeImageUrl => _storeImageUrl;
  String? get contestImageUrl => _contestImageUrl;
  String? get deliveryManImageUrl => _deliveryManImageUrl;
  String? get chatImageUrl => _chatImageUrl;

  BaseUrls.fromJson(Map<String?, dynamic> json) {
    _productImageUrl = json['product_image_url'];
    _customerImageUrl = json['customer_image_url'];
    _bannerImageUrl = json['banner_image_url'];
    _categoryImageUrl = json['category_image_url'];
    _reviewImageUrl = json['review_image_url'];
    _notificationImageUrl = json['notification_image_url'];
    _storeImageUrl = json['store_image_url'];
    _contestImageUrl = json['contest_image_url'];
    _deliveryManImageUrl = json['delivery_man_image_url'];
    _chatImageUrl = json['chat_image_url'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['product_image_url'] = this._productImageUrl;
    data['customer_image_url'] = this._customerImageUrl;
    data['banner_image_url'] = this._bannerImageUrl;
    data['category_image_url'] = this._categoryImageUrl;
    data['review_image_url'] = this._reviewImageUrl;
    data['notification_image_url'] = this._notificationImageUrl;
    data['store_image_url'] = this._storeImageUrl;
    data['contest_image_url'] = this._contestImageUrl;
    data['delivery_man_image_url'] = this._deliveryManImageUrl;
    data['chat_image_url'] = this._chatImageUrl;
    return data;
  }
}

class StoreLocationCoverage {
  String? _longitude;
  String? _latitude;
  double? _coverage;

  StoreLocationCoverage(
      {String? longitude, String? latitude, double? coverage}) {
    this._longitude = longitude;
    this._latitude = latitude;
    this._coverage = coverage;
  }

  String? get longitude => _longitude;
  String? get latitude => _latitude;
  double? get coverage => _coverage;

  StoreLocationCoverage.fromJson(Map<String?, dynamic> json) {
    _longitude = json['longitude'];
    _latitude = json['latitude'];

    _coverage = (json['coverage'] as num).toDouble();
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['longitude'] = this._longitude;
    data['latitude'] = this._latitude;
    data['coverage'] = this._coverage;
    return data;
  }
}
