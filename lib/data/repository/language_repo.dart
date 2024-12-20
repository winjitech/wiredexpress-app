import 'package:wired_express/data/model/response/language_model.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:flutter/material.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }
}
