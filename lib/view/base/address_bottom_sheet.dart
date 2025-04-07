
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/address_model.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/screens/address/address_screen.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/color_resources.dart';

class AddressBottomSheet extends StatefulWidget {
  final bool? fromOutAreaScreen;

  const AddressBottomSheet({Key? key, this.fromOutAreaScreen})
      : super(key: key);

  @override
  State<AddressBottomSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 0), () {
      String? id = Provider.of<CustomAuthProvider>(context, listen: false)
          .getUserAddressId();
      print("--------------${id}");
      if (id != null) {
        final locationProvider =
            Provider.of<LocationProvider>(context, listen: false);
        int addressIndex = locationProvider.addressList
                ?.indexWhere((address) => address.id.toString() == id) ??
            -1;
        if (addressIndex >= 0) {
          Provider.of<OrderProvider>(context, listen: false)
              .setAddressIndex(addressIndex);
        }
      } else {
        final locationProvider =
            Provider.of<LocationProvider>(context, listen: false);
        locationProvider.initAddressList(context);
        locationProvider.addressList;
        if ((locationProvider.addressList == null ||
            locationProvider.addressList!.length == 0 ||
            Provider.of<OrderProvider>(context, listen: false).addressIndex <
                0)) {
          Provider.of<OrderProvider>(context, listen: false).setAddressIndex(0);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            color: ColorResources.getScaffoldBackgroundColor(context),
          ),
          padding: const EdgeInsets.all(35),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  getTranslated('select_delivery_location', context),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: ColorResources.getTextColor(context),
                  ),
                ),
                const SizedBox(height: 16),
                Consumer2<OrderProvider, LocationProvider>(
                  builder: (context, orderProvider, locationProvider, _) {
                    return locationProvider.addressList != null
                        ? locationProvider.addressList!.length > 0
                            ? Column(
                                children: [
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        locationProvider.addressList!.length,
                                    itemBuilder: (context, index) {
                                      final addressModel =
                                          locationProvider.addressList![index];
                                      return Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: ColorResources
                                                  .getBackgroundColor(context),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: index ==
                                                      orderProvider.addressIndex
                                                  ? Border.all(
                                                      color: ColorResources
                                                          .getScaffoldColor(context),
                                                      width: 2,
                                                    )
                                                  : null,
                                            ),
                                            child: MaterialButton(
                                              minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              onPressed: () {
                                                orderProvider
                                                    .setAddressIndex(index);
                                                final selectedAddress =
                                                locationProvider.addressList![
                                                orderProvider.addressIndex];
                                                Provider.of<CustomAuthProvider>(context, listen: false)
                                                    .saveUserAddressId(selectedAddress.id.toString());
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      getAddressIcon(
                                                          addressModel
                                                              .addressType),
                                                      color: index ==
                                                              orderProvider
                                                                  .addressIndex
                                                          ? ColorResources
                                                              .getScaffoldColor(context)
                                                          : ColorResources
                                                              .getHintColor(
                                                                  context),
                                                      size: 30,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Container(
                                                      width: 220,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            addressModel
                                                                .addressType!,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: ColorResources
                                                                  .getHintColor(
                                                                      context),
                                                            ),
                                                          ),
                                                          Text(
                                                            addressModel
                                                                .address!,
                                                            style: TextStyle(
                                                              color: ColorResources
                                                                  .getTextColor(
                                                                      context),
                                                              fontSize: 14,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    index ==
                                                            orderProvider
                                                                .addressIndex
                                                        ?  Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color: ColorResources
                                                                  .getScaffoldColor(context),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  CustomButton(
                                    text: getTranslated('confirm', context),
                                    onTap: () {
                                      final selectedAddress =
                                          locationProvider.addressList![
                                              orderProvider.addressIndex];
                                      locationProvider
                                          .getZone(
                                        context,
                                        selectedAddress.latitude!,
                                        selectedAddress.longitude!,
                                      )
                                          .then((value) {
                                        if (locationProvider.outOfArea ==
                                                false &&
                                            widget.fromOutAreaScreen == true) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  DashboardScreen(pageIndex: 0),
                                            ),
                                          );

                                          Provider.of<CustomAuthProvider>(context, listen: false)
                                              .saveUserAddressId(selectedAddress.id.toString());
                                          print('selectedAddress.id ${selectedAddress.id}');
                                        } else {
                                          Provider.of<CustomAuthProvider>(context, listen: false)
                                              .saveUserAddressId(selectedAddress.id.toString());
                                          print('selectedAddress.id ${selectedAddress.id}');
                                          Navigator.pop(context);
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AddressScreen(),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          getTranslated('add', context),
                                          style: TextStyle(
                                            color: ColorResources
                                                .getGreyBunkerColor(context),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Icon(
                                          Icons.add,
                                          color:
                                              ColorResources.getGreyBunkerColor(
                                                  context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(25),
                                      child: Text(
                                        getTranslated(
                                            'no_address_available', context),
                                        style: TextStyle(
                                            color: ColorResources.getTextColor(
                                                    context)
                                                .withOpacity(0.8),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AddressScreen(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            getTranslated('add', context),
                                            style: TextStyle(
                                                color: ColorResources
                                                    .getGreyBunkerColor(
                                                        context),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(width: 10),
                                          Icon(
                                            Icons.add,
                                            color: ColorResources
                                                .getGreyBunkerColor(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                        :  CustomCircularIndicator(color:ColorResources.getScaffoldColor(context));
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData getAddressIcon(String? addressType) {
    switch (addressType) {
      case 'Home':
        return Icons.home_outlined;
      case 'Workplace':
        return Icons.work_outline;
      default:
        return Icons.list_alt_outlined;
    }
  }
}
