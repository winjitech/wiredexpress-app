import 'package:flutter/material.dart';
import 'package:wired_express/localization/app_localization.dart';

String getTranslated(String key, BuildContext context) {
  return AppLocalization.of(context).translate(key);
}