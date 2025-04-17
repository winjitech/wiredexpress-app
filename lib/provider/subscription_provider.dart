import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/data/model/response/subscription_model.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/repository/subscription_repo.dart';

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionRepo? subscriptionRepo;
  SubscriptionProvider({@required this.subscriptionRepo});

  List<SubscriptionModel>? _subscriptionList;
  List<SubscriptionModel>? get subscriptionList => _subscriptionList;
  bool? _subscriptionListLoading = false;
  bool? get subscriptionListLoading => _subscriptionListLoading;

  Future<ResponseModel> getSubscriptionPlans(BuildContext? context) async {
    _subscriptionListLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    ApiResponse apiResponse = await subscriptionRepo!.getSubscriptionPlans();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _subscriptionList = [];

      apiResponse.response!.data!.forEach((item) {
        SubscriptionModel itemModel = SubscriptionModel.fromJson(item);
        _subscriptionList!.add(itemModel);
      });
      _responseModel = ResponseModel(true, 'successful');
      _subscriptionListLoading = false;
      notifyListeners();
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      _responseModel = ResponseModel(false, _errorMessage);
      _subscriptionListLoading = false;
      notifyListeners();
    }
    notifyListeners();
    return _responseModel;
  }

  bool _subscribeUserLoading = false;
  bool get subscribeUserLoading => _subscribeUserLoading;

  Future<ResponseModel> subscribeUser(BuildContext? context, int planId) async {
    _subscribeUserLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    ApiResponse apiResponse = await subscriptionRepo!.subscribeUser(planId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _responseModel = ResponseModel(true, 'successful');
      _subscribeUserLoading = false;
      notifyListeners();
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);

      _responseModel = ResponseModel(false, _errorMessage);
      _subscribeUserLoading = false;
      notifyListeners();
    }
    notifyListeners();
    return _responseModel;
  }

  bool _cancelSubscriptionLoading = false;
  bool get cancelSubscriptionLoading => _cancelSubscriptionLoading;

  Future<ResponseModel> cancelSubscription(
      BuildContext? context, int id) async {
    _cancelSubscriptionLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    ApiResponse apiResponse = await subscriptionRepo!.cancelSubscription(id);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _responseModel = ResponseModel(true, 'successful');
      _cancelSubscriptionLoading = false;
      notifyListeners();
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);

      _responseModel = ResponseModel(false, _errorMessage);
      _cancelSubscriptionLoading = false;
      notifyListeners();
    }
    notifyListeners();
    return _responseModel;
  }
}
