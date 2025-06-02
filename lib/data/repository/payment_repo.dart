import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/payment_card_model.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  PaymentRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getAllCards(int userId) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.getAllCardsUrl}$userId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> cardUpdateLink() async {
    try {
      Response response = await dioClient!.get(
        '${AppConstants.cardUpdateLinkUrl}',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteCard(String cardId, int userId) async {
    try {
      final response = await dioClient!.post(
          '${AppConstants.deleteCardUrl}?user_id=$userId&card_id=$cardId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
