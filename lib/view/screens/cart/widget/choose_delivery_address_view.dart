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
            authProvider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: ColorResources.getScaffoldBackgroundColor(context),
              boxShadow: [
                BoxShadow(
                    color: Provider.of<ThemeProvider>(context, listen: false)
                            .darkTheme
                        ? Colors.black.withOpacity(0.4)
                        : Colors.grey[300]!,
                    blurRadius: 2,
                    spreadRadius: 1)
              ]),
          height: 50,
          child: GestureDetector(
            onTap: () => showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) => AddressBottomSheet(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  ("cart" != 'take_away' &&
                          (locationProvider.addressList == null ||
                              locationProvider.addressList!.length == 0 ||
                              authProvider.getUserAddressId() == 0))
                      ? Text(
                          getTranslated('select_delivery_location', context),
                          style: TextStyle(
                              color: Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .darkTheme
                                  ? Colors.white54
                                  : ColorResources.getScaffoldColor(context),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      : Text(
                          getTranslated('change_delivery_location', context),
                          style: TextStyle(
                              color: Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .darkTheme
                                  ? Colors.white54
                                  : ColorResources.getScaffoldColor(context),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                  const Spacer(),
                  ("cart" != 'take_away' &&
                          (locationProvider.addressList == null ||
                              locationProvider.addressList!.length == 0 ||
                              authProvider.getUserAddressId() == 0))
                      ? Icon(
                          Icons.not_listed_location_outlined,
                          color: ColorResources.getScaffoldColor(context),
                        )
                      : Icon(
                          Icons.published_with_changes_sharp,
                          color: ColorResources.getScaffoldColor(context),
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
