import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/config_model.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/data/repository/splash_repo.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class SplashProvider extends ChangeNotifier {
  final SplashRepo? splashRepo;

  SplashProvider({@required this.splashRepo});

  ConfigModel? _configModel;
  BaseUrls? _baseUrls;
  DateTime _currentTime = DateTime.now();
  bool _isLoading = false;

  ConfigModel? get configModel => _configModel;
  BaseUrls? get baseUrls => _baseUrls;
  DateTime get currentTime => _currentTime;
  bool get isLoading => _isLoading;

  int? _isPhoneOtp;
  int? get isPhoneOtp => _isPhoneOtp;

  int? _serviceMessagesStatus;
  int? get serviceMessagesStatus => _serviceMessagesStatus;

  bool _ratingActive = true;
  bool get ratingActive => _ratingActive;

  void setRatingStatus(bool status) {
    _ratingActive = status;
    notifyListeners();
  }

  Future<bool> initConfig(GlobalKey<ScaffoldMessengerState> globalKey) async {
    ApiResponse apiResponse = await splashRepo!.getConfig();
    bool isSuccess;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _configModel = ConfigModel.fromJson(apiResponse.response!.data);
      print('config model --- ${jsonEncode(_configModel)}');
      _baseUrls = ConfigModel.fromJson(apiResponse.response!.data).baseUrls;
      //  _isPhoneOtp = int.parse(_configModel!.phoneOTP!);

      isSuccess = true;
      notifyListeners();
    } else {
      isSuccess = false;
      String _error;
      if (apiResponse.error is String) {
        _error = apiResponse.error;
      } else {
        _error = apiResponse.error.errors[0].message;
      }
      print(_error);
      globalKey.currentState!.showSnackBar(
          SnackBar(content: Text(_error), backgroundColor: Colors.red));
    }
    return isSuccess;
  }

  Future<ResponseModel> appUpdated(String update, String token) async {
    _isLoading = false;
    notifyListeners();
    ResponseModel _responseModel;

    http.StreamedResponse response =
        await splashRepo!.appUpdated(update, token);

    if (response.statusCode == 200) {
      _isLoading = true;
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      //_userInfoModel = updateUserModel;
      _responseModel = ResponseModel(true, message);
      print(message);
    } else {
      _responseModel = ResponseModel(
          false, '${response.statusCode} ${response.reasonPhrase}');
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return _responseModel;
  }

  Future<bool> initSharedData() {
    return splashRepo!.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo!.removeSharedData();
  }

  bool isStoreClosed() {
    DateTime _open = DateFormat('hh:mm').parse(_configModel!.storeOpenTime!);
    DateTime _close = DateFormat('hh:mm').parse(_configModel!.storeCloseTime!);
    DateTime _openTime = DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, _open.hour, _open.minute);
    DateTime _closeTime = DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, _close.hour, _close.minute);
    if (_closeTime.isBefore(_openTime)) {
      _closeTime = _closeTime.add(Duration(days: 1));
    }
    if (_currentTime.isAfter(_openTime) && _currentTime.isBefore(_closeTime)) {
      return false;
    } else {
      return true;
    }
  }
}
