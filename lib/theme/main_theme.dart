import 'package:wired_express/utill/dimensions.dart';
import 'package:flutter/material.dart';

ThemeData mainTheme = ThemeData(
  fontFamily: 'Rubik',
  primaryColor: Color(0xFFe84e10),
  brightness: Brightness.light,
  focusColor: Color(0xFFf2c4b1),
  hintColor: Color(0xFF52575C),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
    foregroundColor: Colors.black,
    textStyle: TextStyle(color: Colors.black),
  )),
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
  // textTheme: TextTheme(
  //   button: TextStyle(color: Colors.white),
  //   headline1: TextStyle(
  //       fontWeight: FontWeight.w300, fontSize: Dimensions.FONT_SIZE_DEFAULT),
  //   headline2: TextStyle(
  //   fontSize: Dimensions.FONT_SIZE_DEFAULT),
  //   headline3: TextStyle(
  //       fontWeight: FontWeight.w500, fontSize: Dimensions.FONT_SIZE_DEFAULT),
  //   headline4: TextStyle(
  //       fontWeight: FontWeight.w600, fontSize: Dimensions.FONT_SIZE_DEFAULT),
  //   headline5: TextStyle(
  //       fontWeight: FontWeight.w700, fontSize: Dimensions.FONT_SIZE_DEFAULT),
  //   headline6: TextStyle(
  //       fontWeight: FontWeight.w800, fontSize: Dimensions.FONT_SIZE_DEFAULT),
  //   caption: TextStyle(
  //       fontWeight: FontWeight.w900, fontSize: Dimensions.FONT_SIZE_DEFAULT),
  //   subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
  //   bodyText2: TextStyle(fontSize: 12.0),
  //   bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
  // ),
);
