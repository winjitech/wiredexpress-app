import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:provider/provider.dart';

class ConnectionChecker {
  static void checkApi(BuildContext? context, ApiResponse apiResponse) {
    if(apiResponse.error is! String && apiResponse.error.errors[0].message == 'Unauthenticated.') {
      Provider.of<SplashProvider>(context!, listen: false).removeSharedData();
      Navigator.pop(context);
      // Navigator.pushNamedAndRemoveUntil(context, Routes.getLoginRoute(), (route) => false);
    }else {
    }
  }
}