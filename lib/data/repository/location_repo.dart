import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/address_model.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  LocationRepo({this.dioClient, this.sharedPreferences});

  Future<ApiResponse> getAllAddress() async {
    try {
      final response = await dioClient!.get(AppConstants.addressListUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeAddressByID(int id) async {
    try {
      final response = await dioClient!.post(
          '${AppConstants.removeAddressUrl}$id',
          data: {"_method": "delete"});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addAddress(AddressModel addressModel) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.addAddressUrl,
        data: addressModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateAddress(
      AddressModel addressModel, int addressId) async {
    try {
      Response response = await dioClient!.post(
        '${AppConstants.updateAddressUrl}$addressId',
        data: addressModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  List<String> getAllAddressType({BuildContext? context}) {
    return [
      'Home',
      'Workplace',
      'Other',
    ];
  }


}
