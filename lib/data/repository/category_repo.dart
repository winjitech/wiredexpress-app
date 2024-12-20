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
          await dioClient!.get('${AppConstants.CATEGORY_URI}/$iDCate');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCategoryList() async {
    try {
      final response = await dioClient!.get(AppConstants.CATEGORY_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getCategoryFeaturedList() async {
    try {
      final response = await dioClient!.get(AppConstants.CATEGORY_FEATURED_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCategoryListFull() async {
    try {
      final response = await dioClient!.get(AppConstants.CATEGORY_URI_FUlL);

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSubCategoryList(String parentID) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.SUB_CATEGORY_URI}$parentID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCategoryProductList(
      int pageNumber, String categoryID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var customer_id = await prefs.getInt('my_defined_user_id');
    try {
      final response = await dioClient!.get(
          '${AppConstants.CATEGORY_PRODUCT_URI}?category_id=$categoryID&page_number=$pageNumber');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
