import 'package:flutter/material.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static double _scale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 360) return 0.85;
    if (width < 400) return 0.9;
    return 1.0;
  }

  static TextStyle h1(BuildContext context, {double? fontSize}) =>
      GoogleFonts.rubik(
        fontSize: (fontSize ?? 24.sp) * _scale(context),
        fontWeight: FontWeight.w500,
        color: ColorResources.getTextColor(context),
      );

  static TextStyle h2(BuildContext context, {double? fontSize}) =>
      GoogleFonts.rubik(
        fontSize: (fontSize ?? 18.sp) * _scale(context),
        fontWeight: FontWeight.w700,
        color: ColorResources.getTextColor(context),
      );

  static TextStyle h3(BuildContext context, {double? fontSize}) =>
      GoogleFonts.rubik(
        fontSize: (fontSize ?? 18.sp) * _scale(context),
        fontWeight: FontWeight.w500,
        color: ColorResources.getTextColor(context),
      );

  static TextStyle h4(BuildContext context, {double? fontSize}) =>
      GoogleFonts.rubik(
        fontSize: (fontSize ?? 16.sp) * _scale(context),
        fontWeight: FontWeight.w500,
        color: ColorResources.getTextColor(context),
      );

  static TextStyle h5(BuildContext context, {double? fontSize}) =>
      GoogleFonts.rubik(
        fontSize: (fontSize ?? 16.sp) * _scale(context),
        fontWeight: FontWeight.w400,
        color: ColorResources.getTextColor(context),
      );

  static TextStyle h6(BuildContext context, {double? fontSize}) =>
      GoogleFonts.rubik(
        fontSize: (fontSize ?? 14.sp) * _scale(context),
        fontWeight: FontWeight.w500,
        color: ColorResources.getTextColor(context),
      );

  static TextStyle h7(BuildContext context, {double? fontSize}) =>
      GoogleFonts.rubik(
        fontSize: (fontSize ?? 14.sp) * _scale(context),
        fontWeight: FontWeight.w400,
        color: ColorResources.getTextColor(context),
      );

  static TextStyle h8(BuildContext context, {double? fontSize}) =>
      GoogleFonts.rubik(
        fontSize: (fontSize ?? 12.sp) * _scale(context),
        fontWeight: FontWeight.w400,
        color: ColorResources.getTextColor(context),
      );

  static TextStyle h9(BuildContext context, {double? fontSize}) =>
      GoogleFonts.rubik(
        fontSize: (fontSize ?? 10.sp) * _scale(context),
        fontWeight: FontWeight.w400,
        color: ColorResources.getTextColor(context),
      );
}
