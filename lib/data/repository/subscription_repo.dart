import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/utill/app_constants.dart';

class SubscriptionRepo {
  final DioClient? dioClient;
  SubscriptionRepo({@required this.dioClient});

  Future<ApiResponse> getSubscriptionPlans() async {
    try {
      final response =
          await dioClient!.get(AppConstants.GET_SUBSCRIPTION_PLANS_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> subscribeUser(int planId) async {
    try {
      final response = await dioClient!
          .post('${AppConstants.SUBSCRIBE_USER_URI}?plan_id=$planId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> cancelSubscription(int id) async {
    try {
      final response = await dioClient!
          .post('${AppConstants.CANCEL_SUBSCRIPTION_URI}?plan_id=$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
