import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/address_bottom_sheet.dart';

class ChooseDeliveryAddressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer4<CartProvider, LocationProvider, SplashProvider,
            CustomAuthProvider>(
        builder: (context, cartProvider, locationProvider, splashProvider,
                authProvider, child) =>
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: ColorResources.getScaffoldBackgroundColor(context),
                    boxShadow: [
                      BoxShadow(
                          color: ColorResources.getBoxShadow(context),

                          blurRadius: 2,
                          spreadRadius: 1)
                    ]),
                height: 50,
                child: GestureDetector(
                  onTap: () => showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context) => AddressBottomSheet()),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text(
                          getTranslated(
                              ("cart" != 'take_away' &&
                                      (locationProvider.addressList == null ||
                                          locationProvider
                                                  .addressList!.length ==
                                              0 ||
                                          authProvider.getUserAddressId() == 0))
                                  ? 'select_delivery_location'
                                  : 'change_delivery_location',
                              context),
                          style: TextStyle(
                              color: ColorResources.getTextColor(context)
                                  .withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Icon(
                          ("cart" != 'take_away' &&
                                  (locationProvider.addressList == null ||
                                      locationProvider.addressList!.length ==
                                          0 ||
                                      authProvider.getUserAddressId() == 0))
                              ? Icons.not_listed_location_outlined
                              : Icons.published_with_changes_sharp,
                          color: ColorResources.getTextColor(context)
                              .withOpacity(0.8),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
