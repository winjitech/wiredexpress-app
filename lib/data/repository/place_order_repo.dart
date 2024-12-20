import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/body/place_order_body.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaceOrderRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  PlaceOrderRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> placeOrder(PlaceOrderBody orderBody) async {
    try {
      final response = await dioClient!
          .post(AppConstants.PLACE_ORDER_URI, data: orderBody.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }





  Future<ApiResponse> getHistoryOrdersList(String offset) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.HISTORY_ORDER_LIST_URI}?limit=10&offset=$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getRunningOrdersList() async {
    try {
      final response =
      await dioClient!.get('${AppConstants.RUNNING_ORDER_LIST_URI}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }





  Future<ApiResponse> trackOrder(String orderID) async {
    try {
      final response =
      await dioClient!.get('${AppConstants.TRACK_URI}?order_id=$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }














}
