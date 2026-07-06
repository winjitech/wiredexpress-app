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
  String? _ppuEarn;
  String? _ppuPurchase;
  List<String>? _workingDays;

  ConfigModel({
    String? storeName,
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
    double? minimumOrderValue,
    String? appVersion,
    String? phoneOTP,
    String? serviceMessages,
    String? ppuEarn,
    String? ppuPurchase,
    List<String>? workingDays,
  }) {
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
    this._minimumOrderValue = minimumOrderValue;
    this._appVersion = appVersion;
    this._phoneOTP = phoneOTP;
    this._serviceMessages = serviceMessages;
    this._ppuEarn = ppuEarn;
    this._ppuPurchase = ppuPurchase;
    this._workingDays = workingDays;
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
  double? get minimumOrderValue => _minimumOrderValue;
  String? get appVersion => _appVersion;
  String? get phoneOTP => _phoneOTP;
  String? get serviceMessages => _serviceMessages;
  String? get ppuEarn => _ppuEarn;
  String? get ppuPurchase => _ppuPurchase;
  List<String>? get workingDays => _workingDays;
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

    _minimumOrderValue = (json['minimum_order_value'] as num).toDouble();

    _appVersion = json['app_version'];
    _phoneOTP = json['phone_otp'];
    _serviceMessages = json['service_messages'];
    _ppuEarn = json['ppu_earn'];
    _ppuPurchase = json['ppu_purchase'];
    if (json['opening_hours'] != null) {
      _openingHours = [];
      json['opening_hours'].forEach((v) {
        _openingHours!.add(new OpeningHoursModel.fromJson(v));
      });
    }
    if (json['working_days'] != null) {
      _workingDays = List<String>.from(json['working_days']);
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

    data['minimum_order_value'] = this._minimumOrderValue;

    data['app_version'] = this.appVersion;
    data['phone_otp'] = this.phoneOTP;
    data['ppu_earn'] = _ppuEarn;
    data['ppu_purchase'] = _ppuPurchase;
    if (this._openingHours != null) {
      data['opening_hours'] =
          this._openingHours!.map((v) => v.toJson()).toList();
    }
    data['working_days'] = _workingDays;
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
  String? _electricianImageUrl;
  String? _contractorRequestAttachmentsUrl;

  BaseUrls({
    String? productImageUrl,
    String? customerImageUrl,
    String? bannerImageUrl,
    String? categoryImageUrl,
    String? reviewImageUrl,
    String? notificationImageUrl,
    String? storeImageUrl,
    String? contestImageUrl,
    String? deliveryManImageUrl,
    String? chatImageUrl,
    String? electricianImageUrl,
    String? contractorRequestAttachmentsUrl,
  }) {
    _productImageUrl = productImageUrl;
    _customerImageUrl = customerImageUrl;
    _bannerImageUrl = bannerImageUrl;
    _categoryImageUrl = categoryImageUrl;
    _reviewImageUrl = reviewImageUrl;
    _notificationImageUrl = notificationImageUrl;
    _storeImageUrl = storeImageUrl;
    _contestImageUrl = contestImageUrl;
    _deliveryManImageUrl = deliveryManImageUrl;
    _chatImageUrl = chatImageUrl;
    _electricianImageUrl = electricianImageUrl;
    _contractorRequestAttachmentsUrl = contractorRequestAttachmentsUrl;
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
  String? get electricianImageUrl => _electricianImageUrl;
  String? get contractorRequestAttachmentsUrl =>
      _contractorRequestAttachmentsUrl;

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
    _electricianImageUrl = json['electrician_image_url'];
    _contractorRequestAttachmentsUrl =
    json['contractor_request_attachments_url'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['product_image_url'] = _productImageUrl;
    data['customer_image_url'] = _customerImageUrl;
    data['banner_image_url'] = _bannerImageUrl;
    data['category_image_url'] = _categoryImageUrl;
    data['review_image_url'] = _reviewImageUrl;
    data['notification_image_url'] = _notificationImageUrl;
    data['store_image_url'] = _storeImageUrl;
    data['contest_image_url'] = _contestImageUrl;
    data['delivery_man_image_url'] = _deliveryManImageUrl;
    data['chat_image_url'] = _chatImageUrl;
    data['electrician_image_url'] = _electricianImageUrl;
    data['contractor_request_attachments_url'] =
        _contractorRequestAttachmentsUrl;
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
