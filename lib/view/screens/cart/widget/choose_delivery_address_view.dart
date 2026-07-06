import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/address_bottom_sheet.dart';

class ChooseDeliveryAddressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer4<CartProvider, LocationProvider, SplashProvider,
        CustomAuthProvider>(
      builder: (context, cartProvider, locationProvider, splashProvider,
              authProvider, child) =>
          GestureDetector(
        onTap: () => showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) => AddressBottomSheet()),
        child: Container(
          padding: EdgeInsets.all(15.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: ColorResources.getCardColor(context),
          ),
          child: Row(
            children: [
              Text(
                getTranslated(
                  ("cart" != 'take_away' &&
                          (locationProvider.addressList == null ||
                              locationProvider.addressList!.isEmpty ||
                              authProvider.getUserAddressId() == 0))
                      ? 'select_delivery_location'
                      : 'change_delivery_location',
                  context,
                ),
                style: AppTextStyles.h4(context).copyWith(
                  color: ColorResources.getTextColor(context).withOpacity(0.8),
                ),
              ),
              const Spacer(),
              Icon(
                ("cart" != 'take_away' &&
                        (locationProvider.addressList == null ||
                            locationProvider.addressList!.isEmpty ||
                            authProvider.getUserAddressId() == 0))
                    ? Icons.not_listed_location_outlined
                    : Icons.published_with_changes_sharp,
                color: ColorResources.getTextColor(context).withOpacity(0.8),
              )
            ],
          ),
        ),
      ),
    );
  }
}
