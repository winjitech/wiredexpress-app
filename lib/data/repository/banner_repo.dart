import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/utill/app_constants.dart';

class BannerRepo {
  final DioClient? dioClient;
  BannerRepo({@required this.dioClient});

  Future<ApiResponse> getBannerList() async {
    try {
      final response = await dioClient!.get(AppConstants.bannerUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProductDetails(String productID) async {
    try {
      final response = await dioClient!.get('${AppConstants.productDetailsUrl}$productID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}