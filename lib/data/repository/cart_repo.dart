import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/data/datasource/remote/dio/dio_client.dart';
import 'package:wired_express/data/datasource/remote/exception/api_error_handler.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo {
  final SharedPreferences? sharedPreferences;
  final DioClient? dioClient;
  CartRepo({@required this.sharedPreferences, @required this.dioClient});

  Future<ApiResponse> cartList() async {
    try {
      final response = await dioClient!.get(AppConstants.cartListUrl);
      print('test 1');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('test 2 $e');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addCartList(CartModel cart) async {
    print('cart=> ${cart.toJson()}');
    try {
      Response response = await dioClient!.post(
        AppConstants.addToCartUrl,
        data: cart.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeCartList(int cartId) async {
    try {
      final response = await dioClient!
          .delete('${AppConstants.removeFromCartUrl}?cart_id=$cartId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getCartProductIds() async {
    try {
      final response =
          await dioClient!.get(AppConstants.cartListIdsUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  List<CartModel>? getCartList() {
    List<String>? carts = [];
    if (sharedPreferences!.containsKey(AppConstants.cartList)) {
      carts = sharedPreferences!.getStringList(AppConstants.cartList);
    }
    List<CartModel> cartList = [];
    carts!
        .forEach((cart) => cartList.add(CartModel.fromJson(jsonDecode(cart))));
    return cartList;
  }

  void addToCartList(List<CartModel> cartProductList) {
    List<String> carts = [];
    cartProductList.forEach((cartModel) => carts.add(jsonEncode(cartModel)));
    sharedPreferences!.setStringList(AppConstants.cartList, carts);
  }
}
