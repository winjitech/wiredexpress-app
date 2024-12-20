import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class DeliveryManChatRepo {
  final DioClient? dioClient;
  DeliveryManChatRepo({@required this.dioClient});

  Future<ApiResponse> getChatList(String orderId) async {
    try {
      final response = await dioClient!.get('${AppConstants.DM_MESSAGE_URI}?order_id=$orderId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> sendMessage(String message, String token, String orderId) async {
    print('order id --- ${orderId}');
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.DM_SEND_MESSAGE_URI}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});

    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'message': message,
      'order_id': orderId
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> sendImage(File file, String token, String message, String orderId) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.DM_SEND_IMAGE_URI}?message=$message&order_id=$orderId'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer ${token}'});
    if(file != null) {
      print('image --');
      print('----------------${file.readAsBytes().asStream()}/${file.lengthSync()}/${file.path.split('/').last}');
      request.files.add(http.MultipartFile('image', new http.ByteStream(DelegatingStream.typed(file.openRead())), file.lengthSync(), filename: file.path.split('/').last));
    }
    Map<String, String> _fields = Map();
    {
      _fields.addAll(<String, String>{
        '_method': 'post',
      });
    }
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }
}