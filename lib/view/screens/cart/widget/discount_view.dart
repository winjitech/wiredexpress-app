import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/coupon_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';

class DiscountView extends StatelessWidget {
  final double couponDiscountAmount, totalOrderPrice, totalPointsDiscount;

  const DiscountView(
      {super.key,
      required this.couponDiscountAmount,
      required this.totalOrderPrice,
      required this.totalPointsDiscount});

  @override
  Widget build(BuildContext context) {
    final TextEditingController couponController = TextEditingController();

    return Consumer2<SplashProvider, CouponProvider>(
        builder: (context, splashProvider, couponProvider, child) {
      String currency = splashProvider.configModel!.currencySymbol ?? '\$';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          if (totalPointsDiscount > 0)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: couponProvider.useLoyaltyPoints!,
              onChanged: (bool isActive) {
                if (couponProvider.useLoyaltyPoints == true) {
                  couponProvider.removeUseLoyaltyPoints();
                } else {
                  couponProvider.applyUseLoyaltyPoints(totalPointsDiscount);
                }
              },
              title: Row(
                children: [
                  Text(
                    getTranslated('want_use_loyalty_points', context),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: ColorResources.getTextColor(context),
                    ),
                  ),
                ],
              ),
              activeColor:
                  ColorResources.getPrimaryColor(context).withOpacity(1),
            ),
          SizedBox(height: 15),
          Text(getTranslated('promo_code', context),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: ColorResources.getTextColor(context))),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hintText: getTranslated('enter_promo_code', context),
                  controller: couponController,
                  fillColor: ColorResources.getTextFieldFillColor(context),
                  inputType: TextInputType.text,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              MaterialButton(
                height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (couponController.text.isNotEmpty &&
                      (!couponProvider.applyCouponLoading! ||
                          !couponProvider.removeCouponLoading!)) {
                    print('couponDiscountAmount 1=> $couponDiscountAmount');
                    if (couponDiscountAmount < 1) {
                      print('couponDiscountAmount 2=> $couponDiscountAmount');
                      couponProvider
                          .applyCoupon(couponController.text, totalOrderPrice)
                          .then((discount) {
                        if (discount > 0) {
                          showCustomSnackBar(
                              '${getTranslated('you_got', context)} ${getTranslated('description', context) == "Description" ? currency : currency}$discount ${getTranslated('discount', context)}',
                              context,
                              isError: false);
                        } else {
                          showCustomSnackBar(
                              getTranslated('invalid_code_or', context),
                              context);
                        }
                      });
                    } else {
                      print('couponDiscountAmount 3=> $couponDiscountAmount');
                      couponProvider.removeCouponData(true);
                    }
                  } else if (couponController.text.isEmpty) {
                    showCustomSnackBar(
                        getTranslated('enter_a_Coupon_code', context), context);
                  }
                },
                color: ColorResources.getPrimaryColor(context),
                child: couponProvider.couponDiscountAmount! <= 0
                    ? !couponProvider.applyCouponLoading! ||
                            !couponProvider.removeCouponLoading!
                        ? Text(getTranslated('apply', context),
                            style: rubikMedium.copyWith(
                                color: ColorResources.getCardColor(context)))
                        : CustomCircularIndicator(
                            color: ColorResources.getCardColor(context))
                    : Icon(Icons.clear,
                        color: ColorResources.getCardColor(context)),
              ),
            ],
          ),
          SizedBox(height: 15),
        ],
      );
    });
  }
}
