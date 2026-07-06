import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/body/review_body_model.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepo {
  final DioClient? dioClient;

  ProductRepo({@required this.dioClient});

  Future<ApiResponse> getFeaturedProducts(String offset,
      {int? showEarlyAccess}) async {
    try {
      String url =
          '${AppConstants.featuredProductsUrl}?limit=20&offset=$offset';
      if (showEarlyAccess != null) {
        url += '&show_early_access=$showEarlyAccess';
      }

      final response = await dioClient!.get(url);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> searchProduct(String productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var customer_id = await prefs.getInt('my_defined_user_id');
    try {
      final response = await dioClient!.get(
          '${AppConstants.productDetailsUrl}$productId&customer_id=$customer_id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitReview(ReviewBody reviewBody) async {
    try {
      final response =
          await dioClient!.post(AppConstants.reviewUrl, data: reviewBody);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitDeliveryManReview(ReviewBody reviewBody) async {
    try {
      final response = await dioClient!
          .post(AppConstants.deliveryManReviewUrl, data: reviewBody);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProductDetails(int productId) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.productDetailsUrl}$productId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
