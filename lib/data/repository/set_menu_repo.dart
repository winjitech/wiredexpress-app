import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/utill/app_constants.dart';

class SetMenuRepo {
  final DioClient? dioClient;
  SetMenuRepo({@required this.dioClient});

  Future<ApiResponse> getSetMenuList() async {
    try {
      final response = await dioClient!.get(AppConstants.SET_MENU_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}