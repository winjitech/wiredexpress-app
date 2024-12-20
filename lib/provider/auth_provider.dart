import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/base/error_response.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/data/model/response/signup_model.dart';
import 'package:wired_express/data/repository/auth_repo.dart';
import 'package:wired_express/helper/api_checker.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/screens/address/add_new_address_screen.dart';
import 'package:wired_express/view/screens/auth/verify_phone_code_screen.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class CustomAuthProvider with ChangeNotifier {
  final AuthRepo? authRepo;

  CustomAuthProvider({@required this.authRepo});

  // for registration section
  bool? _isLoading = false;

  bool? get isLoading => _isLoading;
  String? _registrationErrorMessage = '';

  bool? _passIsLoading = false;
  bool? get passIsLoading => _passIsLoading;

  bool? _deletionIsLoading = false;
  bool? get deletionIsLoading => _deletionIsLoading;

  String? get registrationErrorMessage => _registrationErrorMessage;

  updateRegistrationErrorMessage(String? message) {
    _registrationErrorMessage = message;
    notifyListeners();
  }

  void saveRegistrationData(SignUpModel signUpModel) async {}
  Future<ResponseModel> registration(SignUpModel signUpModel) async {
    _isLoading = true;
    _registrationErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.registration(signUpModel);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      saveUserNumberAndPassword(signUpModel.email, signUpModel.password);
      Map map = apiResponse.response!.data;
      String? token = map["token"];
      authRepo!.saveUserToken(token!);
      await authRepo!.updateToken();
      responseModel = ResponseModel(true, 'successful');
    } else {
      String? errorMessage;
      if (apiResponse.error is String?) {
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.errors![0].message;
      }
      print(errorMessage);
      _registrationErrorMessage = errorMessage;
      responseModel = ResponseModel(false, errorMessage!);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  // for login section
  String? _loginErrorMessage = '';

  String? get loginErrorMessage => _loginErrorMessage;

  String? _signErrorMessage = '';
  String? get signErrorMessage => _signErrorMessage;

  Future<ResponseModel> login(
      BuildContext context, String? email, String? password) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse =
    await authRepo!.login(email: email, password: password);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? token = map["token"];
      authRepo!.saveUserToken(token!);
      await authRepo!.updateToken();
      responseModel = ResponseModel(true, 'successful');
    } else {
      String? errorMessage;
      if (apiResponse.error is String?) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      print(errorMessage);
      _loginErrorMessage = errorMessage;
      showCustomSnackBar(getTranslated('unauthorized', context), context);

      responseModel = ResponseModel(false, errorMessage!);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  //TODO- refactor code

  // for forgot password
  bool? _isForgotPasswordLoading = false;
  bool? get isForgotPasswordLoading => _isForgotPasswordLoading;

  Future<ResponseModel> forgetPassword(String? email) async {
    _isForgotPasswordLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.forgetPassword(email!);
    _isForgotPasswordLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      String? errorMessage;
      if (apiResponse.error is String?) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(false, errorMessage!);
    }
    return responseModel;
  }

  Future<void> updateToken() async {
    ApiResponse apiResponse = await authRepo!.updateToken();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
    } else {
      String? errorMessage;
      if (apiResponse.error is String?) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      print(errorMessage);
    }
  }

  Future<ResponseModel> verifyToken(String? email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
    await authRepo!.verifyToken(email!, _verificationCode!);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      String? errorMessage;
      if (apiResponse.error is String?) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(false, errorMessage!);
    }
    return responseModel;
  }

  Future<ResponseModel> resetPassword(
      String? resetToken, String? password, String? confirmPassword) async {
    _isForgotPasswordLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
    await authRepo!.resetPassword(resetToken!, password!, confirmPassword!);
    _isForgotPasswordLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      String? errorMessage;
      if (apiResponse.error is String?) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(false, errorMessage!);
    }
    return responseModel;
  }

  // for phone verification
  bool? _isPhoneNumberVerificationButtonLoading = false;

  bool? get isPhoneNumberVerificationButtonLoading =>
      _isPhoneNumberVerificationButtonLoading;
  String? _verificationMsg = '';

  String? get verificationMessage => _verificationMsg;
  String? _email = '';

  String? get email => _email;

  updateEmail(String? email) {
    _email = email;
    notifyListeners();
  }

  void clearVerificationMessage() {
    _verificationMsg = '';
  }

  Future<ResponseModel> checkEmail(String? email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.checkEmail(email!);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response!.data["token"]);
    } else {
      String? errorMessage;
      if (apiResponse.error is String?) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(false, errorMessage!);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyEmail(String? email) async {
    _isPhoneNumberVerificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse =
    await authRepo!.verifyEmail(email!, _verificationCode!);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      String? errorMessage;
      if (apiResponse.error is String?) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(false, errorMessage!);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<void> checkPassword(
      {String? token, String? password, Function? callback}) async {
    _passIsLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.checkPassword(token!, password!);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _passIsLoading = false;
      callback!(true);
    } else {
      _passIsLoading = false;
      callback!(false);
      //   ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<bool?> clearUserEmailAndPassword() async {
    return authRepo!.clearUserNumberAndPassword();
  }

  // for verification Code
  String? _verificationCode = '';

  String? get verificationCode => _verificationCode;
  bool? _isEnableVerificationCode = false;

  bool? get isEnableVerificationCode => _isEnableVerificationCode;

  updateVerificationCode(String? query) {
    if (query!.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }

  // for Remember Me Section

  bool? _isActiveRememberMe = false;

  bool? get isActiveRememberMe => _isActiveRememberMe;

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe!;
    notifyListeners();
  }

  bool? isLoggedIn() {
    return authRepo!.isLoggedIn();
  }

  Future<bool?> clearSharedData() async {
    _isLoading = true;
    notifyListeners();
    bool? _isSuccess = await authRepo!.clearSharedData();
    _isLoading = false;
    notifyListeners();
    return _isSuccess;
  }

  void saveUserNumberAndPassword(String? email, String? password) {
    authRepo!.saveUserNumberAndPassword(email!, password!);
  }

  String? getUserNumber() {
    return authRepo!.getUserNumber() ?? "";
  }

  String? getUserPassword() {
    return authRepo!.getUserPassword() ?? "";
  }

  Future<bool?> clearUserNumberAndPassword() async {
    return authRepo!.clearUserNumberAndPassword();
  }

  String? getUserToken() {
    return authRepo!.getUserToken();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  String? _verificationId;
  String? get verificationId => _verificationId;
  String? _error;
  String? get error => _error;
  Future<void> verifyPhoneNumber(
      BuildContext context, String phoneNumber) async {
    _isLoading = true;
    try {
      _isLoading = true;
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
          _user = _firebaseAuth.currentUser;

          notifyListeners();
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            showCustomSnackBar(
                getTranslated('invalid_phone', context), context);
            _isLoading = false;

            _error = 'Invalid Phone Number';
          } else {
            print("${e.message}");
            _isLoading = false;

            showCustomSnackBar(
                getTranslated('phone_not_auth', context), context);
          }
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _isLoading = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      VerifyPhoneCodeScreen(phone: phoneNumber)));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print(e.toString());
      showCustomSnackBar(
          getTranslated('something_went_wrong', context), context);
    }
  }

  void deleteVerificationId() {
    _verificationId = '';
  }

  String? _firebaseToken;
  String? get firebaseToken => _firebaseToken;

  Future<void> signInWithVerificationID(
      BuildContext context, String verificationId, String smsCode) async {
    _isLoading = true;
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      UserCredential userCredential =
      await _firebaseAuth.signInWithCredential(credential);
      _user = _firebaseAuth.currentUser;
      String? firebaseToken = await userCredential.user!.getIdToken();
      _firebaseToken = firebaseToken;
      log('firebaseToken=> ${firebaseToken}');
      // print('firebaseToken=> ${firebaseToken}');
      print('done');

      await Provider.of<CustomAuthProvider>(context, listen: false)
          .loginByPhone(
          context,
          Provider.of<CustomAuthProvider>(context, listen: false)
              .firebaseToken);
      //     .then((value) async {
      //   final location = Provider.of<LocationProvider>(context, listen: false);
      //
      //   await location.initAddressList(context).then((value) =>
      //       location.addressList!.isEmpty
      //           ? Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (BuildContext? context) =>
      //                       AddNewAddressScreen(fromSplash: true)))
      //           : Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (BuildContext? context) =>
      //                       DashboardScreen(pageIndex: 0))));
      //   _isLoading = false;
      // });
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      print('Error: $e');
      showCustomSnackBar(getTranslated('check_correct_code', context), context);
    }
  }

  Future<ResponseModel> loginByPhone(
      BuildContext context, String? firebaseToken) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse =
    await authRepo!.loginByPhone(firebaseToken: firebaseToken);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? token = map["token"];
      print('phone token=> ${token}');
      authRepo!.saveUserToken(token!);
      await authRepo!.updateToken().then((value) async {
        final location = Provider.of<LocationProvider>(context, listen: false);

        await location.initAddressList(context).then((value) =>
        location.addressList!.isEmpty
            ? Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext? context) =>
                    AddNewAddressScreen(fromSplash: true)))
            : Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext? context) =>
                    DashboardScreen(pageIndex: 0))));
        _isLoading = false;
      });
      responseModel = ResponseModel(true, 'successful');
    } else {
      String? errorMessage;
      if (apiResponse.error is String?) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      print(errorMessage);
      _loginErrorMessage = errorMessage;
      responseModel = ResponseModel(false, errorMessage!);
      showCustomSnackBar(
          getTranslated('error_try_again_later', context), context);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> signByPhone(
      String fName, String lName, String phone) async {
    _isLoading = true;
    _signErrorMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.signByPhone(fName, lName, phone);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? token = map["token"];
      authRepo!.saveUserToken(token!);
      await authRepo!.updateToken();
      responseModel = ResponseModel(true, 'successful');
    } else {
      String? errorMessage;
      if (apiResponse.error is String?) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      print(errorMessage);
      _signErrorMessage = errorMessage;
      responseModel = ResponseModel(false, errorMessage!);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  void saveUserAddressId(String? Id) {
    authRepo!.saveUserAddressId(Id!);
    notifyListeners();
  }

  Future<bool?> clearUserAddressId() async {
    return authRepo!.clearUserAddressId();
  }

  String? getUserAddressId() {
    return authRepo!.getUserAddressId();
  }

  String? _confirmPasswordErrorText;
  String? get confirmPasswordErrorText => _confirmPasswordErrorText;
  bool? _confirmPasswordErrorTextShow;
  bool? get confirmPasswordErrorTextShow => _confirmPasswordErrorTextShow;
  bool? _confirmPasswordSection;
  bool? get confirmPasswordSection => _confirmPasswordSection;
  void hideConfirmPasswordSection() {
    _confirmPasswordSection = false;
    notifyListeners();
  }

  void hideConfirmPasswordErrorText() {
    _confirmPasswordErrorTextShow = false;
    notifyListeners();
  }

  void showConfirmPasswordSection() {
    _confirmPasswordSection = true;
    notifyListeners();
  }

  void showConfirmPasswordErrorText(String error) {
    _confirmPasswordErrorText = error;
    _confirmPasswordErrorTextShow = true;
    notifyListeners();
  }

  bool? _deleteAccountLoading = false;
  bool? get deleteAccountLoading => _deleteAccountLoading;

  Future<ResponseModel> deleteAccount(
      BuildContext context, String token) async {
    ResponseModel responseModel;
    _deleteAccountLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.deleteAccount(token);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel = ResponseModel(true, "true");
      _deleteAccountLoading = false;
    } else {
      responseModel = ResponseModel(false, "false");

      _deleteAccountLoading = false;
      // ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return responseModel;
  }
}
// Notifying id token listeners about user ( rC6s3cvUjZedpB1Hu4yGNzNJcWy1 ).
