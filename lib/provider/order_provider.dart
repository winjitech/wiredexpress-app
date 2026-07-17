import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wired_express/data/model/body/place_order_body.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/base/error_response.dart';
import 'package:wired_express/data/model/response/config_model.dart';
import 'package:wired_express/data/model/response/delivery_man_model.dart';
import 'package:wired_express/data/model/response/installment_calculation_result.dart';
import 'package:wired_express/data/model/response/installment_plan_model.dart';

import 'package:wired_express/data/model/response/order_details_model.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/data/model/response/order_model.dart';
import 'package:wired_express/data/model/response/working_hours_model.dart';
import 'package:wired_express/data/repository/order_repo.dart';
import 'package:wired_express/view/screens/track/directions.dart';
import 'package:wired_express/data/model/response/delivery_coordinate_history_model.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepo? orderRepo;
  OrderProvider({@required this.orderRepo});

  int _paymentMethodIndex = 0;
  OrderModel? _trackModel;
  OrderModel? get trackModel => _trackModel;
  ResponseModel? _responseModel;

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
  bool _showCancelled = false;
  bool get showCancelled => _showCancelled;
  DeliveryManModel? get deliveryManModel => _deliveryManModel;
  String get orderType => _orderType;
  int get branchIndex => _branchIndex;

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
    } else {}
    notifyListeners();
    return _orderDetails!;
  }

  Future<void> getDeliveryManData(String orderID, BuildContext? context) async {
    ApiResponse apiResponse = await orderRepo!.getDeliveryManData(orderID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _deliveryManModel = DeliveryManModel.fromJson(apiResponse.response!.data);
    } else {}
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

  void clearPrevData() {
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
    notifyListeners();
  }

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
      ApiResponse apiResponse =
          await orderRepo!.getLastDeliveryCoordinates(orderId);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
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

  bool? _isScheduledOrder = false;
  bool? get isScheduledOrder => _isScheduledOrder;

  void setScheduledOrder(bool value) {
    _isScheduledOrder = value;
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
  WorkingHourRangeModel? _selectedOpeningHour;

  WorkingHourRangeModel? get selectedOpeningHour => _selectedOpeningHour;

  void setSelectedTime(WorkingHourRangeModel slot) {
    _selectedOpeningHour = slot;
    notifyListeners();
  }

  void clearSelectedTime() {
    _selectedOpeningHour = null;
    notifyListeners();
  }

  InstallmentPlanModel? _selectedInstallmentPlan;
  InstallmentPlanModel? get selectedInstallmentPlan => _selectedInstallmentPlan;

  void setSelectedInstallmentPlan(InstallmentPlanModel value) {
    if (_selectedInstallmentPlan?.months == value.months) return;

    _selectedInstallmentPlan = value;
    _selectedInterestRate = null;

    notifyListeners();
  }

  void clearSelectedInstallmentPlan() {
    _selectedInstallmentPlan = null;
    notifyListeners();
  }
  InterestRateModel? _selectedInterestRate;

  InterestRateModel? get selectedInterestRate => _selectedInterestRate;

  void setSelectedInterestRate(InterestRateModel value) {
    _selectedInterestRate = value;
    notifyListeners();
  }
  final TextEditingController downPaymentController =
      TextEditingController(text: '0');
  final FocusNode downPaymentFocus = FocusNode();
  bool _calculatingInstallmentLoading = false;
  bool get calculatingInstallmentLoading => _calculatingInstallmentLoading;

  InstallmentCalculationResultModel? _installmentResult;
  InstallmentCalculationResultModel? get installmentResult =>
      _installmentResult;
  Future<void> calculateInstallment({
    required double amount,
    required double downPayment,
  }) async {
    _calculatingInstallmentLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    final plan = _selectedInstallmentPlan!;

    final double financedAmount = amount - downPayment;

    final double rate =
    (_selectedInterestRate?.rate ?? 0).toDouble();
    final double total = financedAmount + (financedAmount * rate / 100);

    final double monthly = total / plan.months!;
    if (downPayment >= amount) {
      _monthlyPayment = 0;
      notifyListeners();
      return;
    }
    _installmentResult = InstallmentCalculationResultModel(
      amount: amount,
      downPayment: downPayment,
      financedAmount: financedAmount,
      interestRate: rate,
      months: plan.months!,
      totalAmount: total,
      monthlyPayment: monthly,
    );
    _monthlyPayment = monthly;
    _downPayment = downPayment;
    _calculatingInstallmentLoading = false;
    notifyListeners();
  }

  bool _useInstallment = false;
  bool get useInstallment => _useInstallment;

  double _monthlyPayment = 0;
  double get monthlyPayment => _monthlyPayment;

  double _downPayment = 0;
  double get downPayment => _downPayment;
  void setUseInstallment(bool value) {
    _useInstallment = value;

    if (!value) {
      _selectedInstallmentPlan = null;
      _monthlyPayment = 0;
      _downPayment = 0;
      downPaymentController.text = "0";
      _installmentResult = null;
    }

    notifyListeners();
  }

  String? _installmentError;
  String? get installmentError => _installmentError;

  bool validateInstallment({
    required double orderAmount,
    required String downPaymentText,
  }) {
    _installmentError = null;

    if (!_useInstallment) {
      notifyListeners();
      return true;
    }

    if (_selectedInstallmentPlan == null) {
      _installmentError = "select_installment_plan";
      notifyListeners();
      return false;
    }
    if (_selectedInterestRate == null) {
      _installmentError = "select_interest_rate";
      notifyListeners();
      return false;
    }
    if (downPaymentText.trim().isEmpty) {
      _installmentError = "enter_down_payment";
      notifyListeners();
      return false;
    }

    final downPayment = double.tryParse(downPaymentText);

    if (downPayment == null) {
      _installmentError = "invalid_down_payment";
      notifyListeners();
      return false;
    }

    if (downPayment < 0) {
      _installmentError = "invalid_down_payment";
      notifyListeners();
      return false;
    }

    if (downPayment >= orderAmount) {
      _installmentError = "down_payment_greater_than_order";
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }
}
