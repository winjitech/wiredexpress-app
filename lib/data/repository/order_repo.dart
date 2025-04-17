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
          await dioClient!.get('${AppConstants.ORDER_DETAILS_URI}$orderID');
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
          await dioClient!.post(AppConstants.ORDER_CANCEL_URI, data: data);
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
          await dioClient!.post(AppConstants.UPDATE_METHOD_URI, data: data);
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

  Future<ApiResponse> placeOrder(PlaceOrderBody orderBody) async {
    try {
      final response = await dioClient!
          .post(AppConstants.PLACE_ORDER_URI, data: orderBody.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDeliveryManData(String orderID) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.LAST_LOCATION_URI}$orderID');
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
          .get('${AppConstants.GET_LAST_DELIVERY_COORDINATES_URI}$orderId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
