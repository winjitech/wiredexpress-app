import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  SearchRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getSearchProductList(String query, {int? planId}) async {
    try {
      String url = '${AppConstants.searchUrl}?name=$query';
      if (planId != null) {
        url += '&plan_id=$planId';
      }
      final response = await dioClient!.get(url);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> filteredProducts(
      String type, String problem, String serviceId) async {
    try {
      print('parameters----------- ${type + ' ' + problem + ' ' + serviceId}');
      final response = await dioClient!.get(
          '${AppConstants.filteredProductsUrl}?type=$type&problem=$problem');
      //   final response = await dioClient!.post(AppConstants.filteredProductsUrl, data:{'type':type, 'problem': problem, 'service_id':serviceId});
      print('heeeey----------- ${type + ' ' + problem + ' ' + serviceId}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('error here ----------- ${(e)}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> sendSearch(String search) async {
    try {
      final response = await dioClient!
          .post(AppConstants.sendSearchUrl, data: {'search': search});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for save home address
  Future<void> saveSearchAddress(String searchAddress) async {
    try {
      List<String> searchKeywordList =
          sharedPreferences!.getStringList(AppConstants.searchAddress) ?? [];
      if (!searchKeywordList.contains(searchAddress)) {
        searchKeywordList.add(searchAddress);
      }
      await sharedPreferences!
          .setStringList(AppConstants.searchAddress, searchKeywordList);
    } catch (e) {
      throw e;
    }
  }

  List<String> getSearchAddress() {
    return sharedPreferences!.getStringList(AppConstants.searchAddress) ?? [];
  }

  Future<bool> clearSearchAddress() async {
    return sharedPreferences!.setStringList(AppConstants.searchAddress, []);
  }
}
