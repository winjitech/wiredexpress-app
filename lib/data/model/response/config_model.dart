import 'dart:convert';

import 'package:wired_express/data/model/response/base_urls_model.dart';
import 'package:wired_express/data/model/response/financing_provider_model.dart';
import 'package:wired_express/data/model/response/installment_plan_model.dart';

import 'package:wired_express/data/model/response/working_hours_model.dart';

class ConfigModel {
  String? _storeName;
  String? _storeOpenTime;
  String? _storeCloseTime;
  String? _storeLogo;
  String? _storeAddress;
  String? _storePhone;
  String? _storeEmail;
  BaseUrls? _baseUrls;
  List<FinancingProviderModel>? _financingProviders;
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
  Map<String, WorkingHoursModel>? _workingHours;
  List<InstallmentPlanModel>? _installmentPlans;
  ConfigModel({
    String? storeName,
    String? storeOpenTime,
    String? storeCloseTime,
    String? storeLogo,
    String? storeAddress,
    String? storePhone,
    String? storeEmail,
    BaseUrls? baseUrls,
    String? currencySymbol,
    String? deliveryCharge,
    String? cashOnDelivery,
    String? digitalPayment,
    String? termsAndConditions,
    String? privacyPolicy,
    List<FinancingProviderModel>? financingProviders,
    String? aboutUs,
    double? minimumOrderValue,
    String? appVersion,
    String? phoneOTP,
    String? serviceMessages,
    String? ppuEarn,
    String? ppuPurchase,
    List<InstallmentPlanModel>? installmentPlans,
    Map<String, WorkingHoursModel>? workingHours,
  }) {
    this._storeName = storeName;
    this._storeOpenTime = storeOpenTime;
    this._storeCloseTime = storeCloseTime;
    this._storeLogo = storeLogo;
    this._storeAddress = storeAddress;
    this._storePhone = storePhone;
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
    this._financingProviders = financingProviders;
    this._phoneOTP = phoneOTP;
    this._serviceMessages = serviceMessages;
    this._ppuEarn = ppuEarn;
    this._ppuPurchase = ppuPurchase;
    this._installmentPlans = installmentPlans;
    _workingHours = workingHours;
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
  String? get termsAndConditions => _termsAndConditions;
  String? get aboutUs => _aboutUs;
  String? get privacyPolicy => _privacyPolicy;
  double? get minimumOrderValue => _minimumOrderValue;
  String? get appVersion => _appVersion;
  String? get phoneOTP => _phoneOTP;
  String? get serviceMessages => _serviceMessages;
  String? get ppuEarn => _ppuEarn;
  String? get ppuPurchase => _ppuPurchase;
  List<FinancingProviderModel>? get financingProviders => _financingProviders;
  List<InstallmentPlanModel>? get installmentPlans => _installmentPlans;
  Map<String, WorkingHoursModel>? get workingHours => _workingHours;
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
    if (json['financing_providers'] != null) {
      _financingProviders = [];
      json['financing_providers'].forEach((v) {
        _financingProviders!.add(FinancingProviderModel.fromJson(v));
      });
    }
    if (json['installment_plans'] != null) {
      _installmentPlans = [];
      json['installment_plans'].forEach((v) {
        _installmentPlans!.add(InstallmentPlanModel.fromJson(v));
      });
    }
    if (json['working_hours'] != null) {
      _workingHours = {};

      (json['working_hours'] as Map<String, dynamic>).forEach((key, value) {
        _workingHours![key] = WorkingHoursModel.fromJson(value);
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

    data['minimum_order_value'] = this._minimumOrderValue;
    if (_financingProviders != null) {
      data['financing_providers'] =
          _financingProviders!.map((e) => e.toJson()).toList();
    }
    data['app_version'] = this.appVersion;
    data['phone_otp'] = this.phoneOTP;
    data['ppu_earn'] = _ppuEarn;
    data['ppu_purchase'] = _ppuPurchase;
    if (_workingHours != null) {
      data['working_hours'] = _workingHours!.map(
        (key, value) => MapEntry(key, value.toJson()),
      );
    }

    if (_installmentPlans != null) {
      data['installment_plans'] =
          _installmentPlans!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}
