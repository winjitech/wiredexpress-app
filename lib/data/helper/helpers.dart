import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/coupon_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/utill/color_resources.dart';

class Helpers {
  static double applyDiscount(CouponModel coupon, double orderAmount) {
    double? _discount = 0.0;
    if (coupon.minPurchase != null && coupon.minPurchase! < orderAmount) {
      if (coupon.discountType == 'percent') {
        if (coupon.maxDiscount != null) {
          _discount =
              (coupon.discount! * orderAmount / 100) < coupon.maxDiscount!
                  ? (coupon.discount! * orderAmount / 100)
                  : coupon.maxDiscount;
        } else {
          _discount = coupon.discount! * orderAmount / 100;
        }
      } else {
        _discount = coupon.discount;
      }
    } else {
      _discount = 0.0;
    }
    return _discount!;
  }

  static String formatTextWithNum(String text) {
    return text.replaceAllMapped(
      RegExp(r"-?\d+(\.\d+)?"),
      (match) {
        String numberStr = match.group(0)!;
        if (numberStr.endsWith(".00")) {
          return numberStr.split('.')[0];
        } else if (numberStr.endsWith(".0")) {
          return numberStr.split('.')[0];
        } else if (numberStr.contains('.')) {
          double num = double.parse(numberStr);
          return num.toStringAsFixed(2);
        } else {
          return numberStr;
        }
      },
    ).replaceAllMapped(
      RegExp(r"(?:^| )(\w)"),
      (match) => match.group(0)!.toUpperCase(),
    );
  }

  static String formatTextStatus(String text) {
    return text.replaceAll("_", " ").replaceAllMapped(
          RegExp(r"(?:^| )(\w)"),
          (match) => match.group(0)!.toUpperCase(),
        );
  }

  static Color? statusColor(BuildContext context, String status) {
    if (status == 'pending' ||
        status == 'waiting_acceptance' || status == 'out_for_delivery' ||
        status == 'requested') {
      return Color(0xFFD5967F);
    }
    if (status == 'accepted' ||
        status == 'on_the_way' ||

        status == 'destination_arrived' ||
        status == 'items_received' ||
        status == "in_progress" ||
        status == "pickedup" ||
        status == 'shipped' ||
        status == 'arrived_to_scrap_yard' ||
        status == 'available') {
      return ColorResources.getPrimaryColor(context);
    }
    if (status == 'arrived') {
      return ColorResources.getPrimaryColor(context);
    }

    if (status == 'finished' ||
        status == 'released' ||
        status == "paid" ||
        status == 'approved' ||
        status == 'delivered' ||
        status == 'confirmed') {
      return Colors.green;
    }
    if (status == 'canceled' ||
        status == 'not_released' ||
        status == "timeout" ||
        status == 'unpaid' ||
        status == 'unavailable' ||
        status == 'rejected') {
      return Colors.red;
    }
  }

  static Color? selectColor(String color) {
    if (color == 'black' || color == 'Black') {
      return Colors.black;
    }
    if (color == 'white' || color == 'White') {
      return Colors.white;
    }
    if (color == 'red' || color == 'Red') {
      return Colors.red;
    }
    if (color == 'green' || color == 'Green') {
      return Colors.green[700];
    }
    if (color == 'grey' || color == 'Grey') {
      return Colors.grey[700];
    }
  }
}
