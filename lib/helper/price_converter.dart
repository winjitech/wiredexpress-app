import 'package:flutter/material.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/localization/language_constrants.dart';

class PriceConverter {
  static String convertPrice(BuildContext? context, double? price,
      {double? discount, String? discountType, int asFixed = 2}) {
    if (discount != null && discountType != null) {
      if (discountType == 'amount') {
        price = price! - discount;
      } else if (discountType == 'percent') {
        price = price! - ((discount / 100) * price);
      }
    }
    return '${Helpers.formatTextWithNum((price)!.toStringAsFixed(asFixed).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'))} ';

    //   return '${getTranslated('description', context!) == "Description" ? 'LE' : 'ج.م'} '
    //       '${(price)!.toStringAsFixed(asFixed).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  static double convertWithDiscount(BuildContext? context, double price,
      double discount, String discountType) {
    if (discountType == 'amount') {
      price = price - discount;
    } else if (discountType == 'percent') {
      price = price - ((discount / 100) * price);
    }
    return price;
  }

  static double calculation(
      double amount, double discount, String type, int quantity) {
    double calculatedAmount = 0;
    if (type == 'amount') {
      calculatedAmount = discount * quantity;
    } else if (type == 'percent') {
      calculatedAmount = (discount / 100) * (amount * quantity);
    }
    return calculatedAmount;
  }

  static String percentageCalculation(BuildContext? context, String price,
      String discount, String discountType) {
    return '$discount${discountType == 'percent' ? '%' : getTranslated('description', context!) == "Description" ? 'LE' : 'ج.م'} OFF';
  }
}
