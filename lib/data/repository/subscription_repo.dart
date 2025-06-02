import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/user_subscription_model.dart';
import 'package:wired_express/utill/app_constants.dart';

class SubscriptionRepo {
  final DioClient? dioClient;
  SubscriptionRepo({@required this.dioClient});

  Future<ApiResponse> getSubscriptionPlans() async {
    try {
      final response =
          await dioClient!.get(AppConstants.getSubscriptionPlansUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> subscribeUser(
      UserSubscriptionPlanModel userSubscription) async {
    print("userSubscription ==  ${userSubscription.toJson()}");

    try {
      final response = await dioClient!.post(AppConstants.subscriptionUserUrl,
          data: userSubscription.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> subscriptionDetails(String id) async {
    try {
      final response = await dioClient!
          .get('${AppConstants.subscriptionDetailsUrl}?subscription_id=$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> cancelSubscription(String id) async {
    try {
      final response = await dioClient!
          .post('${AppConstants.cancelSubscriptionUrl}?subscription_id=$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> stripeSubscriptionUser(
      int planId, String paymentMethodId) async {
    try {
      final response = await dioClient!.post(
          "${AppConstants.stripeSubscriptionUserUrl}?plan_id=$planId&payment_method_id=$paymentMethodId");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> stripeSubscriptionDetails() async {
    try {
      final response =
          await dioClient!.get(AppConstants.stripeSubscriptionDetailsUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> stripeCancelSubscription() async {
    try {
      final response =
          await dioClient!.post(AppConstants.stripeCancelSubscriptionUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
