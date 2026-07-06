import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/coupon_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/provider/contractor_request_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:open_file/open_file.dart';
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
    return text
        .replaceAllMapped(RegExp(r"-?\d+(\.\d+)?"), (match) {
      final double num = double.tryParse(match.group(0) ?? '0') ?? 0;

      return num % 1 == 0 ? num.toInt().toString() : num.toStringAsFixed(2);
    })
        .replaceAllMapped(
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
        status == 'waiting_acceptance' ||
        status == 'out_for_delivery' ||
        status == 'requested' ||
        status == 'under_review' ||
        status == 'contacted') {
      return const Color(0xFFD5967F);
    }

    if (status == 'accepted' ||
        status == 'on_the_way' ||
        status == 'destination_arrived' ||
        status == 'items_received' ||
        status == 'in_progress' ||
        status == 'pickedup' ||
        status == 'shipped' ||
        status == 'arrived_to_scrap_yard' ||
        status == 'available' ||
        status == 'arrived') {
      return ColorResources.getPrimaryColor(context);
    }

    if (status == 'finished' ||
        status == 'released' ||
        status == 'paid' ||
        status == 'approved' ||
        status == 'delivered' ||
        status == 'confirmed' ||
        status == 'completed') {
      return Colors.green;
    }

    if (status == 'canceled' ||
        status == 'cancelled' ||
        status == 'not_released' ||
        status == 'timeout' ||
        status == 'unpaid' ||
        status == 'unavailable' ||
        status == 'rejected') {
      return Colors.red;
    }

    return Colors.grey;
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


  static Future<void> downloadPdf(String fileName, String url) async {
    try {
      final directory = await getExternalStorageDirectory();

      final appDir = Directory('${directory!.path}/Documents');
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }

      final savePath = '${appDir.path}/$fileName';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);

        print('PDF downloaded and saved to: $savePath');

        OpenFile.open(savePath);
      } else {
        throw Exception('Failed to download PDF');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static void chooseContractorRequestFile(
      ContractorRequestProvider ticketProvider,
      ) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      ticketProvider.saveContractorRequestFile(
        File(result.files.single.path!),
        result.files.single.name,
      );
    }
  }

}
