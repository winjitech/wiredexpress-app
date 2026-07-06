import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/contractor_request_model.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/data/repository/contractor_request_repo.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/utill/app_constants.dart';

import 'package:flutter/foundation.dart';
import 'package:async/src/delegate/stream.dart';
import 'package:http/http.dart' as http;

class ContractorRequestProvider extends ChangeNotifier {
  final ContractorRequestRepo? repo;
  ContractorRequestProvider({@required this.repo});
  String? _selectedRequestType;
  String? get selectedRequestType => _selectedRequestType;
  final List<String> requestTypes = [
    'request_quote',
    'bulk_order',
    'contact_sales',
  ];

  // 'quote',
  // 'bulk_order',
  // 'contact_sales',
  void setRequestType(String type) {
    _selectedRequestType = type;
    notifyListeners();
  }

  List<ContractorRequestModel>? _contractorRequestList;
  List<ContractorRequestModel>? get contractorRequestList =>
      _contractorRequestList;
  bool? _contractorRequestListLoading = false;
  bool? get contractorRequestListLoading => _contractorRequestListLoading;

  Future<ResponseModel> getContractorRequests(
    BuildContext? context, {
    bool? loading = true,
  }) async {
    if (loading!) {
      _contractorRequestListLoading = true;
    }
    notifyListeners();
    ResponseModel _responseModel;
    ApiResponse apiResponse = await repo!.getContractorRequests();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _contractorRequestList = [];

      apiResponse.response!.data!.forEach((item) {
        ContractorRequestModel itemModel =
            ContractorRequestModel.fromJson(item);
        _contractorRequestList!.add(itemModel);
      });
      _responseModel = ResponseModel(true, 'successful');
      _contractorRequestListLoading = false;
      notifyListeners();
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      _responseModel = ResponseModel(false, _errorMessage);
      _contractorRequestListLoading = false;
      notifyListeners();
    }
    notifyListeners();
    return _responseModel;
  }

  File? _contractorRequestFile;
  File? get contractorRequestFile => _contractorRequestFile;
  String? _contractorRequestFileName;
  String? get contractorRequestFileName => _contractorRequestFileName;

  void saveContractorRequestFile(File file, String name) {
    _contractorRequestFile = file;
    _contractorRequestFileName = name;
    notifyListeners();
  }

  void clearContractorRequestFile() {
    _contractorRequestFile = null;
    _contractorRequestFileName = null;
    notifyListeners();
  }

  bool? _saveContractorRequestLoading = false;
  bool? get saveContractorRequestLoading => _saveContractorRequestLoading;
  bool? _hideSaveContractorRequestButton = false;
  bool? get hideSaveContractorRequestButton => _hideSaveContractorRequestButton;
  Future<ResponseModel> saveContractorRequest(
      BuildContext context, ContractorRequestModel contractorRequest) async {
    _hideSaveContractorRequestButton = true;
    _saveContractorRequestLoading = true;
    notifyListeners();
    ResponseModel responseModel;

    try {
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.saveContractorRequestUrl}'),
      );

      request.headers.addAll({
        'Authorization':
            'Bearer ${Provider.of<CustomAuthProvider>(context, listen: false).getUserToken()!}'
      });

      if (_contractorRequestFile != null) {
        request.files.add(http.MultipartFile(
          'attachment',
          http.ByteStream(_contractorRequestFile!.openRead()),
          await _contractorRequestFile!.length(),
          filename: _contractorRequestFile!.path.split('/').last,
        ));
      }

      request.fields.addAll({
        '_method': 'post',
        'type': contractorRequest.type!,
        'message_or_items': contractorRequest.messageOrItems!,
      });

      http.StreamedResponse response = await request.send();

      _saveContractorRequestLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        print('Success: ContractorRequest submitted.');
        _hideSaveContractorRequestButton = false;
        responseModel = ResponseModel(true, "true");
      } else {
        String responseBody = await response.stream.bytesToString();
        print(
            'Error: Failed to submit ContractorRequest. Status: ${response.statusCode}');
        print('Response Body: $responseBody');

        _hideSaveContractorRequestButton = false;
        responseModel = ResponseModel(false, responseBody);
      }
    } catch (error, stackTrace) {
      print('Exception occurred: $error');
      print('Stack Trace: $stackTrace');

      _saveContractorRequestLoading = false;
      _hideSaveContractorRequestButton = false;
      responseModel = ResponseModel(false, error.toString());
    }

    notifyListeners();
    return responseModel;
  }

  bool? _cancelContractorRequestLoading = false;
  bool? get cancelContractorRequestLoading => _cancelContractorRequestLoading;

  Future<ResponseModel> cancelContractorRequest(
      BuildContext? context, int contractorRequestId) async {
    _cancelContractorRequestLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    ApiResponse apiResponse =
        await repo!.cancelContractorRequest(contractorRequestId);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _responseModel = ResponseModel(true, 'successful');
      _cancelContractorRequestLoading = false;
      notifyListeners();
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      // ApiChecker.checkApi(context, apiResponse);

      _responseModel = ResponseModel(false, _errorMessage);
      _cancelContractorRequestLoading = false;
      notifyListeners();
    }

    notifyListeners();
    return _responseModel;
  }
}
