import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryRepo {
  final DioClient? dioClient;
  CategoryRepo({@required this.dioClient});

  Future<ApiResponse> getCategory(String iDCate) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.categoryUrl}/$iDCate');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCategoryList() async {
    try {
      final response = await dioClient!.get(AppConstants.categoryUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCategoryFeaturedList() async {
    try {
      final response = await dioClient!.get(AppConstants.categoryFeaturedUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCategoryProductList(String offset, String categoryID,
      {int? showEarlyAccess}) async {
    try {
      String url =
          '${AppConstants.categoryProductUrl}?limit=20&offset=$offset&category_id=$categoryID';
      if (showEarlyAccess != null) {
        url += '&show_early_access=$showEarlyAccess';
      }

      final response = await dioClient!.get(url);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

// Future<ApiResponse> getCategoryProductList(
  //     int pageNumber, String categoryID) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var customer_id = await prefs.getInt('my_defined_user_id');
  //   try {
  //     final response = await dioClient!.get(
  //         '${AppConstants.categoryProductUrl}?category_id=$categoryID&page_number=$pageNumber');
  //     return ApiResponse.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }
}
