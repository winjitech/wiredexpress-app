import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/contractor_request_model.dart';
import 'package:wired_express/utill/app_constants.dart';

class ContractorRequestRepo {
  final DioClient? dioClient;
  ContractorRequestRepo({@required this.dioClient});

  Future<ApiResponse> getContractorRequests() async {
    try {
      final response =
          await dioClient!.get(AppConstants.contractorRequestListUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> cancelContractorRequest(int contractorRequestId) async {
    try {
      final response = await dioClient!.post(
        '${AppConstants.cancelContractorRequestUrl}?request_id=$contractorRequestId',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
