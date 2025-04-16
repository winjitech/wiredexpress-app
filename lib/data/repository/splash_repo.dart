import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  SplashRepo({@required this.sharedPreferences, @required this.dioClient});

  Future<ApiResponse> getConfig() async {
    try {
      final response = await dioClient!.get(AppConstants.configUrl);
      print('success');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('error=> ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> initSharedData() {
    if (!sharedPreferences!.containsKey(AppConstants.theme)) {
      return sharedPreferences!.setBool(AppConstants.theme, false);
    }
    if (!sharedPreferences!.containsKey(AppConstants.countryCode)) {
      return sharedPreferences!.setString(AppConstants.countryCode, 'US');
    }
    if (!sharedPreferences!.containsKey(AppConstants.languageCode)) {
      return sharedPreferences!.setString(AppConstants.languageCode, 'en');
    }
    if (!sharedPreferences!.containsKey(AppConstants.cartList)) {
      return sharedPreferences!.setStringList(AppConstants.cartList, []);
    }
    return Future.value(true);
  }

  Future<http.StreamedResponse> appUpdated(String update, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('${AppConstants.baseUrl}${AppConstants.updateVersionUrl}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});

    Map<String, String> _fields = Map();
    _fields
        .addAll(<String, String>{'_method': 'put', 'update_version': update});

    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<bool> removeSharedData() {
    return sharedPreferences!.clear();
  }

  Future<ApiResponse> getNearbyElectricians(
      String latitude, String longitude) async {
    try {
      final response = await dioClient!.get(
          "${AppConstants.electriciansUrl}?latitude=$latitude&longitude=$longitude");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
