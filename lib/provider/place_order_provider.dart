import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wired_express/data/model/body/place_order_body.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/base/error_response.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/order_model.dart';
import 'package:wired_express/data/repository/place_order_repo.dart';
import 'package:wired_express/helper/api_checker.dart';

class PlaceOrderProvider extends ChangeNotifier {
  final PlaceOrderRepo? placeOrderRepo;
  PlaceOrderProvider({@required this.placeOrderRepo});

  double? _amount;
  String? _orderType;
  bool? _fromCart;
  List<CartModel>? _cartList;
  int? _deliveryId;
  int? get deliveryId => _deliveryId;
  double? get amount => _amount;
  String? get orderType => _orderType;
  bool? get fromCart => _fromCart;
  List<CartModel>? get cartList => _cartList;

  void orderDetails({
    required int deliveryId,
    required double amount,
    required String orderType,
    required bool fromCart,
    required List<CartModel> cartList,
  }) {
    _amount = amount;
    _deliveryId = deliveryId;
    _orderType = orderType;
    _fromCart = fromCart;
    _cartList = cartList;
    notifyListeners();
  }

  String? _email;
  String? _name;
  String? _phone;
  String? _country;
  String? _street;
  String? _postCode;

  String? get email => _email;
  String? get name => _name;
  String? get phone => _phone;
  String? get country => _country;
  String? get street => _street;
  String? get postCode => _postCode;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  void setCountry(String value) {
    _country = value;
    notifyListeners();
  }

  void setStreet(String value) {
    _street = value;
    notifyListeners();
  }

  void setPostCode(String value) {
    _postCode = value;
    notifyListeners();
  }

  String? _paymentName;
  String? _paymentNumber;
  String? _paymentDate;
  String? _paymentCode;

  String? get paymentName => _paymentName;
  String? get paymentNumber => _paymentNumber;
  String? get paymentDate => _paymentDate;
  String? get paymentCode => _paymentCode;

  void creditCardDetails({
    String? paymentName,
    String? paymentNumber,
    String? paymentDate,
    String? paymentCode,
  }) {
    _paymentName = paymentName;
    _paymentNumber = paymentNumber;
    _paymentDate = paymentDate;
    _paymentCode = paymentCode;
    notifyListeners();
  }

  bool? _isLoading = false;
  bool? get isLoading => _isLoading;
  Future<void> placeOrder(PlaceOrderBody placeOrderBody) async {
    _isLoading = true;
    notifyListeners();
    print('Order Body=> ${placeOrderBody.toJson()}');
    print("address id 1 => ${placeOrderBody.deliveryAddressId!}");

    ApiResponse apiResponse = await placeOrderRepo!.placeOrder(placeOrderBody);
    print("address id 2 => ${placeOrderBody.deliveryAddressId!}");

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      print("address id 3 => ${placeOrderBody.deliveryAddressId!}");

      String orderID = apiResponse.response!.data['order_id'].toString();
      print('-------- Order placed successfully $orderID ----------');
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message!;
      }
    }
    notifyListeners();
  }

  List<OrderModel>? _runningOrderList;
  List<OrderModel>? get runningOrderList => _runningOrderList;

  Future<void> getRunningOrderList(BuildContext? context) async {
    ApiResponse apiResponse = await placeOrderRepo!.getRunningOrdersList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      print('orderList --');
      _runningOrderList = [];
      apiResponse.response!.data!.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);

        _runningOrderList!.add(orderModel);
        print('orderList /--');
        print(jsonEncode(_runningOrderList));
      });
    } else {
      // ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  /// HISTORY ORDERS
  /// START HISTORY LIST
  ///HISTORY
  int? _totalHistorySize;
  int? get totalHistorySize => _totalHistorySize;

  String? _historyOrderOffset;
  String? get historyOrderOffset => _historyOrderOffset;

  List<OrderModel>? _historyOrderList = [];
  List<OrderModel>? get historyOrderList => _historyOrderList;

  List<String> _historyOffsetList = [];

  bool _historyOrderIsLoading = false;
  bool get historyOrderIsLoading => _historyOrderIsLoading;

  bool _bottomHistoryOrderLoading = false;
  bool get bottomHistoryOrderLoading => _bottomHistoryOrderLoading;
  Future<void> getHistoryOrdersList(BuildContext context, String offset) async {
    print('test 1 ---');
    if (offset == '1') {
      _historyOrderIsLoading = true;
    }
    if (!_historyOffsetList.contains(offset)) {
      print('test 2 ---');
      _historyOffsetList.add(offset);
      ApiResponse apiResponse =
          await placeOrderRepo!.getHistoryOrdersList(offset);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _bottomHistoryOrderLoading = false;

        if (offset == '1') {
          _historyOrderList = [];
        }
        _totalHistorySize =
            OrdersItems.fromJson(apiResponse.response!.data).totalSize;
        _historyOrderList!
            .addAll(OrdersItems.fromJson(apiResponse.response!.data).orders!);
        print(jsonEncode('history -- ${_historyOrderList}'));
        _historyOrderOffset =
            OrdersItems.fromJson(apiResponse.response!.data).offset;
        _historyOrderIsLoading = false;
      } else {
        _bottomHistoryOrderLoading = false;
        _historyOrderIsLoading = false;
        print('error message -- ${apiResponse.error.toString()}');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(apiResponse.error.toString())));
      }
    } else {
      if (_historyOrderIsLoading) {
        _bottomHistoryOrderLoading = false;
        _historyOrderIsLoading = false;
        //notifyListeners();
      }
    }
    notifyListeners();
  }
}
