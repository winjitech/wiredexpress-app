import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/coupon_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
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
          if (totalPointsDiscount > 0)
            SwitchListTile(
              inactiveThumbColor: ColorResources.getTextColor(context),
              inactiveTrackColor: ColorResources.getTextFieldFillColor(context),
              activeColor: ColorResources.getPrimaryColor(context).withOpacity(1),
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
                    style: AppTextStyles.h5(context),
                  ),
                ],
              ),
            ),
          Text(
            getTranslated('promo_code', context),
            style: AppTextStyles.h4(context),),
          SizedBox(height: 10.h),

          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: couponController,
                  hintText: getTranslated('enter_promo_code', context),
                  fill: true,
                  fillColor: ColorResources.getTextFieldFillColor(context),
                  inputType: TextInputType.text,
                ),
              ),
              SizedBox(width: 15.w),

              InkWell(
                borderRadius: BorderRadius.circular(15.r),
                onTap: () {
                  FocusScope.of(context).unfocus();

                  if (couponController.text.isNotEmpty &&
                      (!couponProvider.applyCouponLoading! ||
                          !couponProvider.removeCouponLoading!)) {

                    if (couponDiscountAmount < 1) {
                      couponProvider
                          .applyCoupon(couponController.text, totalOrderPrice)
                          .then((discount) {
                        if (discount > 0) {
                          showCustomSnackBar(
                            '${getTranslated('you_got', context)} '
                                '$currency$discount '
                                '${getTranslated('discount', context)}',
                            context,
                            isError: false,
                          );
                        } else {
                          showCustomSnackBar(
                            getTranslated('invalid_code_or', context),
                            context,
                          );
                        }
                      });
                    } else {
                      couponProvider.removeCouponData(true);
                    }

                  } else if (couponController.text.isEmpty) {
                    showCustomSnackBar(
                      getTranslated('enter_a_Coupon_code', context),
                      context,
                    );
                  }
                },
                child: Container(
                  height: 50.h,
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorResources.getPrimaryColor(context),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: couponProvider.couponDiscountAmount! <= 0
                      ? (!couponProvider.applyCouponLoading! &&
                      !couponProvider.removeCouponLoading!)
                      ? Text(
                    getTranslated('apply', context),
                    style: AppTextStyles.h5(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                      : SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Icon(
                    Icons.clear_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      );
    });
  }
}
