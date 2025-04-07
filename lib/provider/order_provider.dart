import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wired_express/data/model/body/place_order_body.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/base/error_response.dart';
import 'package:wired_express/data/model/response/delivery_man_model.dart';
import 'package:wired_express/data/model/response/order_details_model.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/data/model/response/order_model.dart';
import 'package:wired_express/data/repository/order_repo.dart';
import 'package:wired_express/helper/api_checker.dart';
import 'package:wired_express/view/screens/track/directions.dart';
import 'package:wired_express/data/model/response/delivery_coordinate_history_model.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepo? orderRepo;
  OrderProvider({@required this.orderRepo});

  int _paymentMethodIndex = 0;
  OrderModel? _trackModel;
  OrderModel? get trackModel => _trackModel;
  ResponseModel? _responseModel;
  int _addressIndex = -1;

  DeliveryManModel? _deliveryManModel;
  String _orderType = 'delivery';
  int _branchIndex = 0;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<OrderModel>? _runningOrderList;
  List<OrderModel>? get runningOrderList => _runningOrderList;
  List<OrderDetailsModel>? _orderDetails;
  List<OrderDetailsModel>? get orderDetails => _orderDetails;
  int get paymentMethodIndex => _paymentMethodIndex;
  ResponseModel? get responseModel => _responseModel;
  int get addressIndex => _addressIndex;
  bool _showCancelled = false;
  bool get showCancelled => _showCancelled;
  DeliveryManModel? get deliveryManModel => _deliveryManModel;
  String get orderType => _orderType;
  int get branchIndex => _branchIndex;

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

  ///end history

  Future<void> getOrderList(BuildContext? context) async {
    ApiResponse apiResponse = await orderRepo!.getOrderList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      print('orderList --');
      _runningOrderList = [];
      _historyOrderList = [];
      apiResponse.response!.data!.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        if (orderModel.orderStatus == 'pending' ||
            orderModel.orderStatus == 'processing' ||
            orderModel.orderStatus == 'out_for_delivery' ||
            orderModel.orderStatus == 'confirmed') {
          _runningOrderList!.add(orderModel);
          print('orderList /--');
          print(jsonEncode(_runningOrderList));
        } else if (orderModel.orderStatus == 'delivered') {
          _historyOrderList!.add(orderModel);
        }
      });
    } else {
      // ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<List<OrderDetailsModel>> getOrderDetails(
      String orderID, BuildContext? context) async {
    _orderDetails = null;
    _isLoading = true;
    _showCancelled = false;

    ApiResponse apiResponse = await orderRepo!.getOrderDetails(orderID);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response!.data!.forEach((orderDetail) =>
          _orderDetails!.add(OrderDetailsModel.fromJson(orderDetail)));
    } else {
      //  ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _orderDetails!;
  }

  Future<void> getDeliveryManData(String orderID, BuildContext? context) async {
    ApiResponse apiResponse = await orderRepo!.getDeliveryManData(orderID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _deliveryManModel = DeliveryManModel.fromJson(apiResponse.response!.data);
    } else {
      // ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void setPaymentMethod(int index) {
    _paymentMethodIndex = index;
    notifyListeners();
  }

  Future<ResponseModel> trackOrder(String orderID, OrderModel orderModel,
      BuildContext? context, bool fromTracking) async {
    _trackModel = null;
    _responseModel = null;
    if (!fromTracking) {
      _orderDetails = null;
    }
    _showCancelled = false;
    if (orderModel.id != null) {
      _isLoading = true;
      notifyListeners();
      ApiResponse apiResponse = await orderRepo!.trackOrder(orderID);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _isLoading = false;
        _trackModel = OrderModel.fromJson(apiResponse.response!.data);
        _responseModel =
            ResponseModel(true, apiResponse.response!.data.toString());
        print("2 => $_responseModel");
      } else {
        _responseModel =
            ResponseModel(false, apiResponse.error.errors[0].message);
        print("3 => $_responseModel");
        //  ApiChecker.checkApi(context, apiResponse);
      }

      _isLoading = false;
      notifyListeners();
    } else {
      _trackModel = orderModel;
      _responseModel = ResponseModel(true, 'Successful');
    }
    return _responseModel!;
  }

  Future<void> placeOrder(
      PlaceOrderBody placeOrderBody, Function callback) async {
    _isLoading = true;
    notifyListeners();
    print('Order Body=> ${placeOrderBody.toJson()}');
    print("address id 1 => ${placeOrderBody.deliveryAddressId!}");

    ApiResponse apiResponse = await orderRepo!.placeOrder(placeOrderBody);
    print("address id 2 => ${placeOrderBody.deliveryAddressId!}");

    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      print("address id 3 => ${placeOrderBody.deliveryAddressId!}");

      String message = apiResponse.response!.data['message'];
      String orderID = apiResponse.response!.data['order_id'].toString();
      callback(true, message, orderID, placeOrderBody.deliveryAddressId!);
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
      callback(false, errorMessage, '-1', -1);
    }
    notifyListeners();
  }

  void stopLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setAddressIndex(int index) {
    _addressIndex = index;
    notifyListeners();
  }

  void clearPrevData() {
    _addressIndex = -1;
    _branchIndex = 0;
    _paymentMethodIndex = 0;
  }

  void cancelOrder(String orderID, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo!.cancelOrder(orderID);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      OrderModel? orderModel;
      // _runningOrderList!.forEach((order) {
      //   if (order.id.toString() == orderID) {
      //     orderModel = order;
      //   }
      // });
      // _runningOrderList!.remove(orderModel);
      _showCancelled = false;
      callback(apiResponse.response!.data['message'], true, orderID);
    } else {
      print(apiResponse.error.errors[0].message);
      callback(apiResponse.error.errors[0].message, false, '-1');
    }
    notifyListeners();
  }

  Future<void> updatePaymentMethod(String orderID, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo!.updatePaymentMethod(orderID);
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      int? orderIndex;
      for (int index = 0; index < _runningOrderList!.length; index++) {
        if (_runningOrderList![index].id.toString() == orderID) {
          orderIndex = index;
          break;
        }
      }
      if (orderIndex != null) {
        _runningOrderList![orderIndex].paymentMethod = 'cash_on_delivery';
      }
      _trackModel!.paymentMethod = 'cash_on_delivery';
      callback(apiResponse.response!.data['message'], true);
    } else {
      print(apiResponse.error.errors[0].message);
      callback(apiResponse.error.errors[0].message, false);
    }
    notifyListeners();
  }

  void setOrderType(String type, {bool notify = true}) {
    _orderType = type;
    if (notify) {
      notifyListeners();
    }
  }

  void setBranchIndex(int index) {
    _branchIndex = index;
    _addressIndex = -1;
    notifyListeners();
  }

  //// HISTORY
  Future<void> getHistoryOrdersList(BuildContext context, String offset) async {
    print('test 1 ---');
    if (offset == '1') {
      _historyOrderIsLoading = true;
    }
    if (!_historyOffsetList.contains(offset)) {
      print('test 2 ---');
      _historyOffsetList.add(offset);
      ApiResponse apiResponse = await orderRepo!.getHistoryOrdersList(offset);

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

  void clearHistoryOffset() {
    _historyOffsetList.clear();
    _historyOrderList!.clear();
    notifyListeners();
  }

  void showBottomHistoryOrderLoader() {
    _bottomHistoryOrderLoading = true;
    notifyListeners();
  }

  //////////   MAP ROUTES ////////////
  Directions? _info;
  Directions? get info => _info;

  Future<dynamic> addDirections(LatLng origin, LatLng destination) async {
    var directions = await orderRepo!.getDirections(origin, destination);
    _info = directions;
    notifyListeners();
    return directions;
  }

  Timer? _timer;
  Timer? get timer => _timer;
  void cancelTimer() {
    _timer?.cancel();
  }

  // bool _lastDeliveryCoordinatesLoading = false;
  // bool get lastDeliveryCoordinatesLoading => _lastDeliveryCoordinatesLoading;
  // DeliveryCoordinateHistoryModel? _lastDeliveryCoordinates;
  // DeliveryCoordinateHistoryModel? get lastDeliveryCoordinates =>
  //     _lastDeliveryCoordinates;
  //
  // Future<ResponseModel> getLastDeliveryCoordinates(
  //     BuildContext? context, String orderId) async {
  //   _lastDeliveryCoordinatesLoading = true;
  //   notifyListeners();
  //   ResponseModel _responseModel;
  //   ApiResponse apiResponse =
  //       await orderRepo!.getLastDeliveryCoordinates(orderId);
  //   if (apiResponse.response != null &&
  //       apiResponse.response!.statusCode == 200) {
  //     _lastDeliveryCoordinates =
  //         DeliveryCoordinateHistoryModel.fromJson(apiResponse.response!.data);
  //
  //     _responseModel = ResponseModel(true, 'successful');
  //     _lastDeliveryCoordinatesLoading = false;
  //     notifyListeners();
  //   } else {
  //     String _errorMessage;
  //     if (apiResponse.error is String) {
  //       _errorMessage = apiResponse.error.toString();
  //     } else {
  //       _errorMessage = apiResponse.error.errors[0].message;
  //     }
  //     print(_errorMessage);
  //     _responseModel = ResponseModel(false, _errorMessage);
  //     _lastDeliveryCoordinatesLoading = false;
  //     notifyListeners();
  //   }
  //   notifyListeners();
  //   return _responseModel;
  // }
  bool _lastDeliveryCoordinatesLoading = false;
  bool get lastDeliveryCoordinatesLoading => _lastDeliveryCoordinatesLoading;

  DeliveryCoordinateHistoryModel? _lastDeliveryCoordinates;
  DeliveryCoordinateHistoryModel? get lastDeliveryCoordinates =>
      _lastDeliveryCoordinates;

  Future<ResponseModel> getLastDeliveryCoordinates(
      BuildContext? context, String orderId) async {
    _lastDeliveryCoordinatesLoading = true;
    notifyListeners();

    ResponseModel _responseModel;

    try {
      ApiResponse apiResponse = await orderRepo!.getLastDeliveryCoordinates(orderId);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        print("apiResponse.response!.data == ${apiResponse.response!.data}");
        DeliveryCoordinateHistoryModel newData =
        DeliveryCoordinateHistoryModel.fromJson(apiResponse.response!.data);


        if (_lastDeliveryCoordinates?.lastUpdate != newData.lastUpdate) {
          _lastDeliveryCoordinates = newData;
          notifyListeners();
        }


        print("newData === ${newData.toJson()}");
        _responseModel = ResponseModel(true, 'successful');
      } else {
        String _errorMessage;
        if (apiResponse.error is String) {
          _errorMessage = apiResponse.error.toString();
        } else {
          _errorMessage = apiResponse.error.errors[0].message;
        }
        print(_errorMessage);
        _responseModel = ResponseModel(false, _errorMessage);
      }
    } catch (e) {
      print(e.toString());
      _responseModel = ResponseModel(false, e.toString());
    }

    _lastDeliveryCoordinatesLoading = false;
    notifyListeners();

    return _responseModel;
  }

  int? _selectedScheduledValue;
  int? get selectedScheduledValue => _selectedScheduledValue;

  void setSelectScheduledValue(int selectedScheduledValue) {
    _selectedScheduledValue = selectedScheduledValue;
    notifyListeners();
  }

  void clearSelectScheduledValue() {
    _selectedScheduledValue = null;
    notifyListeners();
  }

  DateTime? _selectedDeliveryDate;
  DateTime? get selectedDeliveryDate => _selectedDeliveryDate;

  void setSelectDeliveryDate(DateTime selectedDeliveryDate) {
    _selectedDeliveryDate = selectedDeliveryDate;
    notifyListeners();
  }

  void clearSelectDeliveryDate() {
    _selectedDeliveryDate = null;
    notifyListeners();
  }
}
