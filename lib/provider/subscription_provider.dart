import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/data/model/response/subscription_model.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/user_subscription_model.dart';
import 'package:wired_express/data/repository/subscription_repo.dart';

class SubscriptionProvider extends ChangeNotifier {
  final SubscriptionRepo? subscriptionRepo;
  SubscriptionProvider({@required this.subscriptionRepo});

  List<SubscriptionPlanModel>? _subscriptionPlanList;
  List<SubscriptionPlanModel>? get subscriptionPlanList =>
      _subscriptionPlanList;
  bool? _subscriptionPlanListLoading = false;
  bool? get subscriptionPlanListLoading => _subscriptionPlanListLoading;

  Future<ResponseModel> getSubscriptionPlans(BuildContext? context) async {
    _subscriptionPlanListLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    ApiResponse apiResponse = await subscriptionRepo!.getSubscriptionPlans();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _subscriptionPlanList = [];

      apiResponse.response!.data!.forEach((item) {
        SubscriptionPlanModel itemModel = SubscriptionPlanModel.fromJson(item);
        _subscriptionPlanList!.add(itemModel);
      });
      _responseModel = ResponseModel(true, 'successful');
      _subscriptionPlanListLoading = false;
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
      _subscriptionPlanListLoading = false;
      notifyListeners();
    }
    notifyListeners();
    return _responseModel;
  }

  bool _subscribeUserLoading = false;
  bool get subscribeUserLoading => _subscribeUserLoading;
  String? _approveUrl;
  String? get approveUrl => _approveUrl;

  Future<ResponseModel> subscribeUser(
      BuildContext? context, UserSubscriptionPlanModel userSubscription) async {
    _subscribeUserLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    ApiResponse apiResponse =
        await subscriptionRepo!.subscribeUser(userSubscription);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _approveUrl = apiResponse.response!.data!['approve_url'];
      print("_approveUrl == ${_approveUrl}");
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

  bool _subscriptionDetailsLoading = false;
  bool get subscriptionDetailsLoading => _subscriptionDetailsLoading;
  String? _subscriptionStatus;
  String? get subscriptionStatus => _subscriptionStatus;

  Future<ResponseModel> subscriptionDetails(
      BuildContext? context, String id) async {
    _subscriptionDetailsLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    ApiResponse apiResponse = await subscriptionRepo!.subscriptionDetails(id);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _subscriptionStatus = apiResponse.response!.data!['status'];
      print("status == ${_subscriptionStatus}");
      _responseModel = ResponseModel(true, 'successful');
      _subscriptionDetailsLoading = false;
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
      _subscriptionDetailsLoading = false;
      notifyListeners();
    }
    notifyListeners();
    return _responseModel;
  }

  bool _cancelSubscriptionLoading = false;
  bool get cancelSubscriptionLoading => _cancelSubscriptionLoading;

  Future<ResponseModel> cancelSubscription(
      BuildContext? context, String id) async {
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
