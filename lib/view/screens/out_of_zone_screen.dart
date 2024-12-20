import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/view/base/address_bottom_sheet.dart';
import 'package:wired_express/view/screens/address/add_new_address_screen.dart';
import 'package:wired_express/view/screens/address/address_screen.dart';
import 'package:wired_express/view/screens/auth/sign_with_phone_screen.dart';
import 'package:wired_express/view/screens/auth/verify_phone_code_screen.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/theme/dark_theme.dart';
import 'package:wired_express/theme/light_theme.dart';
import 'package:provider/provider.dart';

class OutOfZoneScreen extends StatefulWidget {
  @override
  _OutOfZoneScreenState createState() => _OutOfZoneScreenState();
}

class _OutOfZoneScreenState extends State<OutOfZoneScreen> {
  @override
  void initState() {
    super.initState();

    // Timer(Duration(seconds: 1), () {
    //   print("-------------------------------------");
    //   final location = Provider.of<LocationProvider>(context, listen: false);
    //   location.getZone(
    //       context,
    //       location
    //           .addressList![Provider.of<OrderProvider>(context, listen: false)
    //               .addressIndex]!
    //           .latitude!,
    //       location
    //           .addressList![Provider.of<OrderProvider>(context, listen: false)
    //               .addressIndex]!
    //           .longitude!);
    //   print("-------------------------------------");
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
        body: SafeArea(
          child: Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
            return Scrollbar(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Image.asset(
                          // Images.welcome_logo,
                          Images.logo,
                          height: MediaQuery.of(context).size.height / 4.5,
                          fit: BoxFit.scaleDown,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Welcome To Lacrostini App',
                          style: TextStyle(
                            fontSize: 22,
                            color: ColorResources.getTextColor(context),
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'We regret to inform you that your current location falls outside the designated delivery zone. Kindly consider moving closer to the delivery area and attempting your request again.',
                          style: TextStyle(
                            fontSize: 18,
                            color: ColorResources.getTextColor(context),
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                              color: ColorResources.getTextColor(context),
                              thickness: 1,
                            )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'OR ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorResources.getTextColor(context),
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Expanded(
                                child: Divider(
                              color: ColorResources.getTextColor(context),
                              thickness: 1,
                            )),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Provider.of<OrderProvider>(context, listen: false)
                            //             .addressIndex ==
                            //         null
                            //     ? Text(
                            //         locationProvider.addressList![0].id
                            //             .toString(),
                            //         style: TextStyle(color: Colors.white),
                            //       )
                            //     : Text(
                            //         locationProvider
                            //             .addressList![
                            //                 Provider.of<OrderProvider>(context,
                            //                         listen: false)
                            //                     .addressIndex]
                            //             .id
                            //             .toString(),
                            //         style: TextStyle(color: Colors.white),
                            //       ),
                            Padding(
                                padding: const EdgeInsets.all(15),
                                child: locationProvider.addressList == null
                                    ? TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      AddNewAddressScreen()));
                                        },
                                        child: Text(
                                          "Add new address",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: ColorResources
                                                  .getPrimaryColor(context)),
                                        ))
                                    : locationProvider.addressList!.length > 1
                                        ? TextButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AddressBottomSheet(fromOutAreaScreen: true,);
                                                },
                                              );
                                            },
                                            child: Text(
                                              'Choose another address',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: ColorResources
                                                      .getPrimaryColor(
                                                          context)),
                                            ))
                                        : TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          AddNewAddressScreen()));
                                            },
                                            child: Text(
                                              "Add another address",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: ColorResources
                                                      .getPrimaryColor(
                                                          context)),
                                            ))),
                          ],
                        ),
                        locationProvider.outOfArea == true
                            ? SizedBox()
                            : Column(
                                children: [
                                  Text(
                                    "now you in the zone delivery area ...go to dash board",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                      ],
                    )),
              ),
            );
          }),
        ));
  }
}
