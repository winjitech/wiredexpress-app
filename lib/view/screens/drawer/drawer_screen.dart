import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/address_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';
import 'package:wired_express/view/screens/categories/categories_screen.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:wired_express/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:wired_express/view/screens/support/support_screen.dart';
import 'package:wired_express/view/screens/terms/terms_screen.dart';
import 'package:wired_express/view/screens/track/order_tracking_screen.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () async {});
  }

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;

    final address =
        Provider.of<LocationProvider>(context, listen: false).addressList;

    return SafeArea(child:
        Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
      int? id = Provider.of<CustomAuthProvider>(context, listen: false)
          .getUserAddressId();

      return Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 45),
                if (_isLoggedIn)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      profileProvider.userInfoModel != null &&
                          profileProvider.userInfoModel!.image == null
                          ? const SizedBox(
                              height: 70,
                              width: 70,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${profileProvider.userInfoModel!.image}',
                                      ),
                                      fit: BoxFit.cover)),
                              height: 70,
                              width: 70,
                            ),
                      const SizedBox(height: 20),
                      profileProvider.userInfoModel!.fName != null &&
                              profileProvider.userInfoModel!.lName != null
                          ? Text(
                              '${profileProvider.userInfoModel!.fName!} ${profileProvider.userInfoModel!.lName!}' ??
                                  '',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500))
                          : const SizedBox(),
                      const SizedBox(height: 5),
                      Consumer<CustomAuthProvider>(
                        builder: (context, custom, child) {
                          try {
                            if (address == null || address.isEmpty ||id == 0 ) {
                              return const SizedBox();
                            }
                            AddressModel matchedAddress = address.firstWhere(
                              (element) => element.id == id,
                            );

                            if (matchedAddress != null) {
                              return Text(
                                matchedAddress.address.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              );
                            } else {
                              return const SizedBox();
                            }
                          } catch (e) {
                            return const SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                if (!_isLoggedIn)
                  Text(getTranslated('guest', context),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                const Divider(color: Colors.white, thickness: 1),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DashboardScreen(pageIndex: 0)));
                    },
                    child: Text(getTranslated('shopping', context),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500))),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CategoriesScreen()));
                    },
                    child: Text(getTranslated('categories', context),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500))),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DashboardScreen(pageIndex: 1)));
                    },
                    child: Text(getTranslated('my_cart', context),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500))),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DashboardScreen(pageIndex: 3)));
                    },
                    child: Text(getTranslated('wishlist', context),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500))),
                TextButton(
                    onPressed: () {
                      final placeOrder = Provider.of<PlaceOrderProvider>(
                          context,
                          listen: false);
                      placeOrder.runningOrderList == null ||
                              placeOrder.runningOrderList!.isEmpty
                          ? showCustomSnackBar(
                              getTranslated('no_running_orders_yet', context),
                              context)
                          : placeOrder.runningOrderList![0].deliveryMan == null
                              ? showCustomSnackBar(
                                  getTranslated('cant_track', context), context)
                              : Provider.of<OrderProvider>(context, listen: false)
                                  .addDirections(
                                      LatLng(
                                          double.parse(placeOrder
                                              .runningOrderList![0]
                                              .deliveryMan!
                                              .latitude!),
                                          double.parse(placeOrder
                                              .runningOrderList![0]
                                              .deliveryMan!
                                              .longitude!)),
                                      LatLng(
                                          double.parse(placeOrder
                                              .runningOrderList![0]
                                              .deliveryAddress!
                                              .latitude!),
                                          double.parse(placeOrder.runningOrderList![0].deliveryAddress!.longitude!)))
                                  .then((value) => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => OrderTrackingScreen(orderID: Provider.of<PlaceOrderProvider>(context, listen: false).runningOrderList![0].id!.toString(), track: Provider.of<PlaceOrderProvider>(context, listen: false).runningOrderList![0]))));
                    },
                    child: Text(getTranslated('track_order', context),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500))),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SupportScreen()));
                    },
                    child: Text(getTranslated('help_and_support', context),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500))),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TermsScreen()));
                    },
                    child: const Text('FAQ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500))),
                const SizedBox(height: 10),
                const Divider(color: Colors.white, thickness: 1),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: () {
                      _isLoggedIn
                          ? showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => SignOutConfirmationDialog())
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginScreen()));
                    },
                    child: Text(
                        getTranslated(
                            _isLoggedIn ? 'logout' : 'login', context),
                        style: TextStyle(
                            color: _isLoggedIn
                                ? Colors.white
                                : ColorResources.getPrimaryColor(context),
                            fontSize: 20,
                            fontWeight: FontWeight.w500)))
              ]));
    }));
  }
}
