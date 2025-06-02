import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/base/error_response.dart';
import 'package:wired_express/data/model/response/payment_card_model.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/data/repository/payment_repo.dart';
import 'package:wired_express/data/repository/search_repo.dart';
import 'package:wired_express/helper/api_checker.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentProvider with ChangeNotifier {
  final SharedPreferences? sharedPreferences;

  final PaymentRepo? paymentRepo;
  PaymentProvider({@required this.sharedPreferences, this.paymentRepo});

  bool? _getCardsLoading = false;
  bool? get getCardsLoading => _getCardsLoading;
  bool? _addCardLoading = false;
  bool? get addCardLoading => _addCardLoading;

  List<PaymentCardModel>? _paymentCardList;
  List<PaymentCardModel>? get paymentCardList => _paymentCardList;

  bool? _deleteLoading = false;
  bool? get deleteLoading => _deleteLoading;

  bool _showPaymentView = true;
  bool get showPaymentView => _showPaymentView;

  void updatePaymentViewVisibility() {
    _showPaymentView = !_showPaymentView;
    notifyListeners();
  }

  bool? _infoLoading = false;
  bool? get infoLoading => _infoLoading;

  String? _selectedPaymentMethod = 'online';
  String? get selectedPaymentMethod => _selectedPaymentMethod;

  void updatePaymentMethod(String value) {
    _selectedPaymentMethod = value;
    notifyListeners();
  }

  // Future<ResponseModel> getPaymentInfo(BuildContext? context) async {
  //   _infoLoading = true;
  //   notifyListeners();
  //
  //   ResponseModel? _responseModel;
  //   ApiResponse apiResponse = await paymentRepo!.getPaymentInfo();
  //
  //   if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
  //     _paymentCardList = [];
  //     String? linkUrl = apiResponse.response!.data!['link_url'];
  //
  //     List<dynamic> cards = apiResponse.response!.data!['cards'] ?? [];
  //
  //     cards.forEach((card) {
  //       _paymentCardList!.add(PaymentCardModel.fromJson(card));
  //     });
  //
  //     // Set the link_url if needed in your state
  //     _paymentLink = linkUrl; // Assuming you have a _linkUrl variable
  //
  //     // Return a successful response model
  //     _responseModel = ResponseModel(true, 'successful');
  //   } else {
  //     ApiChecker.checkApi(context, apiResponse);
  //     _responseModel = ResponseModel(false, 'Error');
  //   }
  //
  //   // Update loading state and notify listeners
  //   _infoLoading = false;
  //   notifyListeners();
  //
  //   return _responseModel!;
  // }

  Future<ResponseModel> getPaymentCardList(BuildContext? context, int userId) async {
    _getCardsLoading = true;
    notifyListeners();

    ResponseModel? _responseModel;
    ApiResponse apiResponse = await paymentRepo!.getAllCards(userId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _paymentCardList = [];
      apiResponse.response!.data!.forEach(
          (card) => _paymentCardList!.add(PaymentCardModel.fromJson(card)));

      _responseModel = ResponseModel(true, 'successful');
      _getCardsLoading = false;
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
      _responseModel = ResponseModel(false, 'Error');
      _getCardsLoading = false;
      notifyListeners();
    }
    notifyListeners();
    return _responseModel!;
  }

  bool? _loading = false;
  bool? get loading => _loading;
  String? _paymentLink;
  String? get paymentLink => _paymentLink;

  Future<ResponseModel> cardUpdateLink(
      BuildContext? context) async {
    _loading = true;
    notifyListeners();
    ResponseModel _responseModel;
    ApiResponse apiResponse =
        await paymentRepo!.cardUpdateLink();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _paymentLink = apiResponse.response!.data;

      _responseModel = ResponseModel(true, 'successful');
      _loading = false;
      notifyListeners();
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      _responseModel = ResponseModel(false, _errorMessage);
      _loading = false;
      notifyListeners();
      // ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _responseModel;
  }


  Future<ResponseModel> deleteCard(
      BuildContext? context,String cardId, int userId) async {
    _deleteLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    ApiResponse apiResponse = await paymentRepo!.deleteCard(cardId ,userId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _responseModel = ResponseModel(true, 'successful');
      _deleteLoading = false;
      notifyListeners();
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      _responseModel = ResponseModel(false, _errorMessage);
      _deleteLoading = false;
      notifyListeners();
    }
    notifyListeners();
    return _responseModel;
  }
}
