import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/utill/app_constants.dart';

class CategoryRepo {
  final DioClient? dioClient;
  CategoryRepo({@required this.dioClient});

  Future<ApiResponse> getAllCategories() async {
    try {
      final response = await dioClient!.get(AppConstants.categoryUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSubCategories(int id) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.subCategoriesUrl}?category_id=$id',
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProductsByCategory(String offset,
      {int? categoryId, int? subcategoryId, int? showEarlyAccess}) async {
    try {
      String url =
          '${AppConstants.categoryProductUrl}?limit=20&offset=$offset&category_id=$categoryId';
      if (showEarlyAccess != null) {
        url += '&show_early_access=$showEarlyAccess';
      }
      if (subcategoryId != null) {
        url += '&subcategory_id=$subcategoryId';
      }

      final response = await dioClient!.get(url);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
