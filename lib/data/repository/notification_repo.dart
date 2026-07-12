import 'package:flutter/foundation.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/utill/app_constants.dart';

class NotificationRepo {
  final DioClient? dioClient;

  NotificationRepo({@required this.dioClient});


  Future<ApiResponse> fetchNotifications(String offset) async {
    try {
      String url = '${AppConstants.notificationsUrl}?limit=20&offset=$offset';

      print("url -- $url");
      final response = await dioClient!.get(url);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> markAsRead(int notificationId) async {
    try {
      String url = '${AppConstants.markAsRead}?notification_id=$notificationId';

      print("url -- $url");
      final response = await dioClient!.post(url);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
