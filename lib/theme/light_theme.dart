import 'package:flutter/material.dart';
import 'package:wired_express/utill/app_constants.dart';

ThemeData light = ThemeData(
  useMaterial3: false,
  // fontFamily: AppConstants.fontFamily,

  primaryColor: Color(0xFFe84e10),
  focusColor: Color(0xFFf2c4b1),
  hintColor: Color(0xFF52575C),
  // backgroundColor: Colors.white,
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
    foregroundColor: Colors.black,
    textStyle: TextStyle(color: Colors.black),
  )),
  // secondaryHeaderColor: Colors.teal,
  // disabledColor: const Color(0xFFBABFC4),
  // brightness: Brightness.light,
  // cardColor: Colors.white,
  // textButtonTheme: TextButtonThemeData(
  //     style: TextButton.styleFrom(foregroundColor: const Color(0xFF1bac4b))),
  // colorScheme: const ColorScheme.light(
  //         primary: Color(0xFF1bac4b),
  //         tertiary: Color(0xff6165D7),
  //         tertiaryContainer: Color(0xff171DB6),
  //         secondary: Color(0xFFFF8200))
  //     .copyWith(background: const Color(0xFFF3F3F3))
  //     .copyWith(error: const Color(0xFFE84D4F)),
);
