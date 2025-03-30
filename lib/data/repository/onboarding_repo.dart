import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/onboarding_model.dart';
import 'package:wired_express/utill/images.dart';

class OnBoardingRepo {
  final DioClient? dioClient;

  OnBoardingRepo({@required this.dioClient});

  Future<ApiResponse> getOnBoardingList(BuildContext? context) async {
    try {
      List<OnBoardingModel> onBoardingList = [
        OnBoardingModel(Images.onboarding_one, 'Make you Order', 'Choose your desired product'),
        OnBoardingModel(Images.onboarding_two, 'Select ypur delivery location', 'Select Accurate Location'),
        OnBoardingModel(Images.onboarding_three, 'Deliver at your home', 'Get delivery at your home'),
      ];

      Response response = Response(requestOptions: RequestOptions(path: ''), data: onBoardingList, statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
