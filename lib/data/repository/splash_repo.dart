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
      final response = await dioClient!.get(AppConstants.CONFIG_URI);
      print('success');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('error=> ${e}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> initSharedData() {
    if(!sharedPreferences!.containsKey(AppConstants.THEME)) {
      return sharedPreferences!.setBool(AppConstants.THEME, false);
    }
    if(!sharedPreferences!.containsKey(AppConstants.COUNTRY_CODE)) {
      return sharedPreferences!.setString(AppConstants.COUNTRY_CODE, 'US');
    }
    if(!sharedPreferences!.containsKey(AppConstants.LANGUAGE_CODE)) {
      return sharedPreferences!.setString(AppConstants.LANGUAGE_CODE, 'en');
    }
    if(!sharedPreferences!.containsKey(AppConstants.CART_LIST)) {
      return sharedPreferences!.setStringList(AppConstants.CART_LIST, []);
    }
    return Future.value(true);
  }


  Future<http.StreamedResponse> appUpdated(String update, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.UPDATE_VERSION_CODE_URI}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});

    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      '_method': 'put', 'update_version': update
    });

    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<bool> removeSharedData() {
    return sharedPreferences!.clear();
  }
}