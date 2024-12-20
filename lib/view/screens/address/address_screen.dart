import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/no_data_screen.dart';
import 'package:wired_express/view/base/not_logged_in_screen.dart';
import 'package:wired_express/view/screens/address/add_new_address_screen.dart';
import 'package:wired_express/view/screens/address/widget/address_widget.dart';
import 'package:wired_express/view/screens/address/widget/permission_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();

    print('test 1');
    Timer(Duration(seconds: 0), () {
      print('test 2');
      Provider.of<LocationProvider>(context, listen: false)
          .getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    if (_isLoggedIn) {
      Provider.of<LocationProvider>(context, listen: false)
          .initAddressList(context);
    }

    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      appBar: CustomAppBar(title: getTranslated('address', context)),
      floatingActionButton: _isLoggedIn
          ? FloatingActionButton(
              child: Icon(Icons.add,
                  color: ColorResources.getScaffoldBackgroundColor(context)),
              backgroundColor: ColorResources.SCAFFOLD_COLOR,
              onPressed: () => _checkPermission(
                  context,
                  Routes.getAddAddressRoute(
                      'address', 'add', '', '', '', '', '', '', 0, 0)),
            )
          : null,
      body: _isLoggedIn
          ? Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
                return locationProvider.addressList != null
                    ? locationProvider.addressList!.length > 0
                        ? RefreshIndicator(
                            onRefresh: () async {
                              await Provider.of<LocationProvider>(context,
                                      listen: false)
                                  .initAddressList(context);
                            },
                            backgroundColor:
                                ColorResources.getPrimaryColor(context),
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                child: Center(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.all(10),
                                        itemCount: locationProvider
                                            .addressList!.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              AddressWidget(
                                                addressModel: locationProvider
                                                    .addressList![index],
                                                index: index,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              )
                                            ],
                                          );
                                        }),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : NoDataScreen()
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)));
              },
            )
          : NotLoggedInScreen(),
    );
  }

  void _checkPermission(BuildContext context, String navigateTo) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar(getTranslated('you_have_to_allow', context), context);
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => PermissionDialog());
    } else {
      print(
          'latitude=> ${Provider.of<LocationProvider>(context, listen: false).position.latitude}');

      Provider.of<LocationProvider>(context, listen: false)
          .updateInitialPosition(LatLng(
              Provider.of<LocationProvider>(context, listen: false)
                  .position
                  .latitude,
              Provider.of<LocationProvider>(context, listen: false)
                  .position
                  .longitude));
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => AddNewAddressScreen()));
    }
  }
}
