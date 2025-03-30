import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/signup_model.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  AuthRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> registration(SignUpModel signUpModel) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.REGISTER_URI,
        data: signUpModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> login({String? email, String? password}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.LOGIN_URI,
        data: {"email": email, "password": password},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e.toString());
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> loginByPhone({String? firebaseToken}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.LOGIN_BY_PHONE_URI,
        data: {"firebasetoken": firebaseToken},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e.toString());
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> signByPhone(
      String fName, String lName, String phone) async {
    try {
      Response response = await dioClient!.post(
          '${AppConstants.SIGN_BY_PHONE_URI}?f_name=$fName&l_name=$lName&phone=$phone');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e.toString());
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateToken() async {
    try {
      String? _deviceToken;
      if (!Platform.isAndroid) {
        NotificationSettings settings =
            await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          _deviceToken = await _saveDeviceToken();
        }
      } else {
        _deviceToken = await _saveDeviceToken();
      }
      print('device token --- ${_deviceToken}');
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
      FirebaseMessaging.instance.subscribeToTopic('Specific_TOPIC');
      Response response = await dioClient!.post(
        AppConstants.TOKEN_URI,
        data: {"_method": "put", "cm_firebase_token": _deviceToken},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String> _saveDeviceToken() async {
    String? _deviceToken = await FirebaseMessaging.instance.getToken();
    if (_deviceToken != null) {
      print('--------Device Token---------- ' + _deviceToken);
    }
    return _deviceToken!;
  }

  // for forgot password
  Future<ApiResponse> forgetPassword(String email) async {
    try {
      Response response = await dioClient!
          .post(AppConstants.FORGET_PASSWORD_URI, data: {"email": email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyToken(String email, String token) async {
    try {
      Response response = await dioClient!.post(AppConstants.VERIFY_TOKEN_URI,
          data: {"email": email, "reset_token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> resetPassword(
      String resetToken, String password, String confirmPassword) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.RESET_PASSWORD_URI,
        data: {
          "_method": "put",
          "reset_token": resetToken,
          "password": password,
          "confirm_password": confirmPassword
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for verify phone number
  Future<ApiResponse> checkEmail(String email) async {
    try {
      print('success');
      Response response =
          await dioClient!.post('${AppConstants.CHECK_EMAIL_URI}?email=$email');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('error: $e');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> verifyEmail(String email, String token) async {
    try {
      Response response = await dioClient!.post(AppConstants.VERIFY_EMAIL_URI,
          data: {"email": email, "token": token});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> checkPassword(String token, String password) async {
    try {
      final response = await dioClient!.post(
          '${AppConstants.CHECK_PASSWORD_URI}?token=$token&password=$password');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteAccount(String token) async {
    try {
      final response = await dioClient!
          .delete('${AppConstants.DELETE_ACCOUNT}?token=$token');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for  user token
  Future<void> saveUserToken(String token) async {
    dioClient!.token = token;
    dioClient!.dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      await sharedPreferences!.setString(AppConstants.TOKEN, token);
    } catch (e) {
      throw e;
    }
  }

  String getUserToken() {
    print('------------------------------------------------------------------');
    print(sharedPreferences!.getString(AppConstants.TOKEN));
    print('------------------------------------------------------------------');
    return sharedPreferences!.getString(AppConstants.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.TOKEN);
  }

  Future<bool> clearSharedData() async {
    if (!kIsWeb) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
    }
    await sharedPreferences!.remove(AppConstants.TOKEN);
    await sharedPreferences!.remove(AppConstants.CART_LIST);
    await sharedPreferences!.remove(AppConstants.USER_ADDRESS);
    await sharedPreferences!.remove(AppConstants.SEARCH_ADDRESS);
    return true;
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String email, String password) async {
    try {
      await sharedPreferences!.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences!.setString(AppConstants.USER_EMAIL, email);
    } catch (e) {
      throw e;
    }
  }

  String getUserNumber() {
    return sharedPreferences!.getString(AppConstants.USER_EMAIL) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences!.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences!.remove(AppConstants.USER_PASSWORD);
    return await sharedPreferences!.remove(AppConstants.USER_EMAIL);
  }

  Future<void> saveUserAddressId(String Id) async {
    try {
      await sharedPreferences!.setString(AppConstants.SAVE_ADDRESS_ID, Id);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> clearUserAddressId() async {
    return await sharedPreferences!.remove(AppConstants.SAVE_ADDRESS_ID);
  }

  String getUserAddressId() {
    return sharedPreferences!.getString(AppConstants.SAVE_ADDRESS_ID) ?? "";
  }
}
