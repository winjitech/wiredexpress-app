import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/body/place_order_body.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wired_express/view/screens/track/direction_repository.dart';

class OrderRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  OrderRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getOrderDetails(String orderID) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.orderDetailsUrl}$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> cancelOrder(String orderID) async {
    try {
      Map<String, dynamic> data = Map<String, dynamic>();
      data['order_id'] = orderID;
      data['_method'] = 'put';
      final response =
          await dioClient!.post(AppConstants.orderCancelUrl, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updatePaymentMethod(String orderID) async {
    try {
      Map<String, dynamic> data = Map<String, dynamic>();
      data['order_id'] = orderID;
      data['_method'] = 'put';
      data['payment_method'] = 'cash_on_delivery';
      final response =
          await dioClient!.post(AppConstants.updateMethodUrl, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> trackOrder(String orderID) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.trackUrl}?order_id=$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> placeOrder(PlaceOrderBody orderBody) async {
    try {
      final response = await dioClient!
          .post(AppConstants.placeOrderUrl, data: orderBody.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeliveryManData(String orderID) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.lastLocationUrl}$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getHistoryOrdersList(String offset) async {
    try {
      final response = await dioClient!
          .get('${AppConstants.historyOrderListUrl}?limit=10&offset=$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<dynamic> getDirections(LatLng origin, LatLng destination) async {
    print('origin ${origin}');
    print('destination ${destination}');
    final directions = await DirectionsRepository()
        .getDirections(origin: origin, destination: destination);

    return directions;
  }

  Future<ApiResponse> getLastDeliveryCoordinates(String orderId) async {
    try {
      final response = await dioClient!
          .get('${AppConstants.getLastDeliveryCoordinatesUrl}$orderId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
