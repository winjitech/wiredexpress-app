import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';

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
    return '${Provider.of<SplashProvider>(context!, listen: false).configModel!.currencySymbol ?? '\$'}${Helpers.formatTextWithNum((price)!.toStringAsFixed(asFixed).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'))} ';
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

  static double convertPercentageToAmount(double price, double percentage) {
    return (percentage / 100) * price;
  }

  static TiredPricingModel? getMatchedTieredPricingModel(BuildContext context,
      List<TiredPricingModel> tieredPricing, int quantity) {
    bool isHaveBulkOrderDiscounts = false;
    final authProvider =
        Provider.of<CustomAuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final userInfo = profileProvider.userInfoModel;

    if (authProvider.isLoggedIn()! &&
        userInfo != null &&
        userInfo.bulkOrderDiscounts == 1) {
      isHaveBulkOrderDiscounts = true;
    }

    TiredPricingModel? matchedPricing;

    for (var pricing in tieredPricing) {
      if (pricing.minQuantity! <= quantity) {
        if (!isHaveBulkOrderDiscounts && pricing.planId != null) {
          continue;
        }

        if (matchedPricing == null ||
            pricing.minQuantity! > matchedPricing.minQuantity!) {
          matchedPricing = pricing;
        } else if (pricing.minQuantity! == matchedPricing.minQuantity!) {
          if (isHaveBulkOrderDiscounts &&
              userInfo != null &&
              pricing.planId == userInfo.userSubscription!.planId) {
            matchedPricing = pricing;
          }
        }
      }
    }

    if (matchedPricing != null) {
      print('Matched Pricing Model: minQuantity=${matchedPricing.minQuantity}, '
          'discountPrice=${matchedPricing.discountPrice}');
    }

    return matchedPricing;
  }

  static double? getProductFinalPrice(BuildContext context,
      List<TiredPricingModel> tieredPricing, double? price, int quantity) {
    double basePrice = price ?? 0.0;

    TiredPricingModel? matchedPricing =
        getMatchedTieredPricingModel(context, tieredPricing, quantity);

    if (matchedPricing != null) {
      print('Matched Pricing: minQuantity=${matchedPricing.minQuantity}, '
          'discountPrice=${matchedPricing.discountPrice}');
    }

    double? finalPrice = matchedPricing != null
        ? basePrice - double.parse(matchedPricing.discountPrice ?? '0.0')
        : basePrice;

    print("finalPrice == $finalPrice");
    return finalPrice;
  }

  static double? getProductFinalPriceWithTieredPricing(
      TiredPricingModel? tieredPricing, double? price) {
    double basePrice = price ?? 0.0;

    print('Matched Pricing: minQuantity=${tieredPricing!.minQuantity}, '
        'discountPrice=${tieredPricing.discountPrice}');

    double? finalPrice = tieredPricing != null
        ? basePrice - double.parse(tieredPricing.discountPrice ?? '0.0')
        : basePrice;

    print("final price provider == $finalPrice");
    return finalPrice ?? 0.0;
  }
}
