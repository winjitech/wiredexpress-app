import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class ChatRepo {
  final DioClient? dioClient;
  ChatRepo({@required this.dioClient});

  Future<ApiResponse> getChatList() async {

    try {
      final response = await dioClient!.get(AppConstants.messageUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<http.StreamedResponse> sendMessage(String message, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.sendMessageUrl}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});

    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'message': message
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<http.StreamedResponse> sendImage(File file, String token, String message) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.sendImageUrl}?message=$message'));
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
    print("Test responce");
    //
    print(response);
    return response;

  }

}