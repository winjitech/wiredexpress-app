import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  useMaterial3: false,
  // fontFamily: AppConstants.fontFamily,
  primaryColor: Color(0xFFe84e1D).withOpacity(1),
  focusColor: Color(0xFFf2c4b1).withOpacity(0.8),
  hintColor: const Color(0xFFbebebe),
  // backgroundColor: Colors.black,
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
    foregroundColor: Colors.white,
    textStyle: TextStyle(color: Colors.white),
  )),
  // secondaryHeaderColor: const Color(0xFF009f67),
  // disabledColor: const Color(0xffa2a7ad),
  // brightness: Brightness.dark,
  // cardColor: const Color(0xFF30313C),
  // textButtonTheme: TextButtonThemeData(
  //     style: TextButton.styleFrom(foregroundColor: const Color(0xFF218743))),
  // colorScheme: const ColorScheme.dark(
  //         primary: Color(0xFF218743),
  //         tertiary: Color(0xff6165D7),
  //         tertiaryContainer: Color(0xff171DB6),
  //         secondary: Color(0xFFFF8200))
  //     .copyWith(background: const Color(0xFF191A26))
  //     .copyWith(error: const Color(0xFFdd3135)),
);
