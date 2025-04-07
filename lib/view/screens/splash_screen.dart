// import 'dart:async';
// import 'package:wired_express/provider/auth_provider.dart';
// import 'package:wired_express/provider/cart_provider.dart';
// import 'package:wired_express/provider/location_provider.dart';
// import 'package:wired_express/provider/splash_provider.dart';
// import 'package:wired_express/view/screens/address/add_new_address_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:wired_express/provider/wishlist_provider.dart';
// import 'package:wired_express/utill/Images.dart';
// import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// class SplashScreen extends StatefulWidget {
//   // final String? route_id;
//   // SplashScreen({this.route_id,});
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
//   StreamSubscription<ConnectivityResult>? _onConnectivityChanged;
//   bool? _isLoggedIn;
//
//   @override
//   void initState() {
//     super.initState();
//     // Timer(Duration(seconds: 1), () async {
//     //   Provider.of<LocationProvider>(context, listen: false)
//     //       .initAddressList(context);
//     //   print(
//     //       "      ${Provider.of<LocationProvider>(context, listen: false).addressList}");
//     // });
//     bool _firstTime = true;
//     _onConnectivityChanged = Connectivity()
//         .onConnectivityChanged
//         .listen((ConnectivityResult result) {
//       if (!_firstTime) {
//         bool isNotConnected = result != ConnectivityResult.wifi &&
//             result != ConnectivityResult.mobile;
//         isNotConnected
//             ? SizedBox()
//             : _globalKey.currentState!.hideCurrentSnackBar();
//         _globalKey.currentState!.showSnackBar(SnackBar(
//           backgroundColor: isNotConnected ? Colors.red : Colors.green,
//           duration: Duration(seconds: isNotConnected ? 6000 : 3),
//           content: Text(
//             isNotConnected ? 'No connection' : 'Connected',
//             textAlign: TextAlign.center,
//           ),
//         ));
//         if (!isNotConnected) {
//           _route();
//         }
//       }
//
//       _firstTime = false;
//     });
//
//     Timer(Duration(seconds: 1), () {
//       _route();
//     });
//
//     _checkPermission();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//
//     _onConnectivityChanged!.cancel();
//   }
//
//   void _checkPermission() async {
//     LocationPermission permission;
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.deniedForever) {
//         return Future.error('Location permission is not Allowed by the user');
//       }
//     } else {}
//   }
//
//   void _route() async{
//
//     final bool _isLoggedIn =
//         Provider.of<AuthProvider>(context, listen: false).isLoggedIn()!;
//     Provider.of<SplashProvider>(context, listen: false)
//         .initConfig(_globalKey)
//         .then((bool isSuccess) async {
//       if (isSuccess) {
//         // Provider.of<LocationProvider>(context, listen: false)
//         //     .initAddressList(context);
//         // print(
//         //     "------------------------------------------------------------------------");
//         // print(
//         //     " address List  one => ${Provider.of<LocationProvider>(context, listen: false).addressList}");
//         // print(
//         //     "------------------------------------------------------------------------");
//
//         Provider.of<CartProvider>(context, listen: false)
//             .initCartListProductIds(context);
//
//         Provider.of<WishListProvider>(context, listen: false)
//             .initWishListProductIds(context, true);
//         if (_isLoggedIn ) {
//           Provider.of<CartProvider>(context, listen: false).initCartList(context);
//           final location = await Provider.of<LocationProvider>(context, listen: false) ;
//              await  location.initAddressList(context).then((value) =>
//              location.addressList!.isEmpty? Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (BuildContext? context) => AddNewAddressScreen()))
//             : Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext? context) =>
//                     DashboardScreen(pageIndex: 0))).then((value) => location.getZone(context,location.addressList![0].latitude.toString(), location.addressList![0].longitude.toString())));
//           print("------------------------------------------------------------------------");
//           print(" address List  two => ${Provider.of<LocationProvider>(context, listen: false).addressList!.length}");
//           print("------------------------------------------------------------------------");
//           // print(
//           //     "------------------------------------------------------------------------");
//           // print(
//           //     " address List  three => ${Provider.of<LocationProvider>(context, listen: false).addressList}");
//           // print(
//           //     "------------------------------------------------------------------------");
//           // Navigator.push(
//           //     context,
//           //     MaterialPageRoute(
//           //         builder: (BuildContext? context) => SetAddressScreen()));
//         } else {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (BuildContext? context) =>
//                       DashboardScreen(pageIndex: 0)));
//         }
//
//         // }
//         // );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext? context) {
//     return Scaffold(
//         key: _globalKey,
//         backgroundColor: Theme.of(context!).primaryColor,
//         body: Consumer<SplashProvider>(builder: (context, splash, child) {
//           return Center(
//               child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset(Images.welcome_logo, height: 175),
//             ],
//           ));
//         }));
//   }
//
// }
import 'dart:async';
import 'dart:developer';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/banner_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/set_menu_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/view/screens/address/add_new_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/view/screens/language/choose_language_screen.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  // final String? route_id;
  // SplashScreen({this.route_id,});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult>? _onConnectivityChanged;
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    // Timer(Duration(seconds: 1), () async {
    //   Provider.of<LocationProvider>(context, listen: false)
    //       .initAddressList(context);
    //   print(
    //       "      ${Provider.of<LocationProvider>(context, listen: false).addressList}");
    // });
    bool _firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? SizedBox()
            : _globalKey.currentState!.hideCurrentSnackBar();
        _globalKey.currentState!.showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'No connection' : 'Connected',
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }

      _firstTime = false;
    });

    Timer(Duration(seconds: 1), () {
      _route();
    });

    _checkPermission();
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged!.cancel();
  }

  void _checkPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permission is not Allowed by the user');
      }
    } else {}
  }

  void _route() async {
    final bool _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(_globalKey)
        .then((bool isSuccess) async {
      if (isSuccess) {
        // Provider.of<LocationProvider>(context, listen: false)
        //     .initAddressList(context);
        // print(
        //     "------------------------------------------------------------------------");
        // print(
        //     " address List  one => ${Provider.of<LocationProvider>(context, listen: false).addressList}");
        // print(
        //     "------------------------------------------------------------------------");

        Provider.of<CartProvider>(context, listen: false)
            .initCartListProductIds(context);

        Provider.of<WishListProvider>(context, listen: false)
            .initWishListProductIds(context, true);
        if (_isLoggedIn) {
          Provider.of<CartProvider>(context, listen: false)
              .initCartList(context);
          Provider.of<ProfileProvider>(context, listen: false)
              .getUserInfo(context);
          await Provider.of<WishListProvider>(context, listen: false)
              .initWishListProductIds(context);
          await Provider.of<CartProvider>(context, listen: false)
              .initCartList(context);

          await Provider.of<CartProvider>(context, listen: false)
              .initCartListProductIds(context);
          await Provider.of<CategoryProvider>(context, listen: false)
              .getCategoryListFull(context, false);
          await Provider.of<CategoryProvider>(context, listen: false)
              .getCategoryList(context, false);
          await Provider.of<SetMenuProvider>(context, listen: false)
              .getSetMenuList(context, false);
          await Provider.of<BannerProvider>(context, listen: false)
              .getBannerList(context, false);
          await Provider.of<CategoryProvider>(context, listen: false)
              .getCategoryFeaturedList(context, false);

          final location =
              await Provider.of<LocationProvider>(context, listen: false);
          await location.initAddressList(context).then((value) async {
            if (location.addressList!.isEmpty) {
              location.initAddressList(context).then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext? context) => AddNewAddressScreen(
                            fromSplash: true,
                          ))));
            } else {
              // await location.getZone(
              //     context,
              //     location.addressList![0].latitude.toString(),
              //     location.addressList![0].longitude.toString());
              // location.outOfArea == true
              //     ? Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (BuildContext? context) =>
              //                 OutOfZoneScreen()))
              //     :

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext? context) =>
                          DashboardScreen(pageIndex: 0)));
              log("TOKEN = ${Provider.of<CustomAuthProvider>(context, listen: false).getUserToken()!}");
            }
          });
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ChooseLanguageScreen()));
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (BuildContext? context) => OnBoardingScreen()));
        }

        // }
        // );
      }
    });
  }

  // Colors.white
  @override
  Widget build(BuildContext? context) {
    return Scaffold(
        backgroundColor: Colors.black,
        key: _globalKey,
        body: Consumer<SplashProvider>(builder: (context, splash, child) {
          return Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Image.asset(Images.logo, height: 175),
            ],
          ));
        }));
    // return Scaffold(
    //     backgroundColor: ColorResources.getPrimaryColor(context!),
    //     key: _globalKey,
    //     body: Consumer<SplashProvider>(builder: (context, splash, child) {
    //       return Center(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Image.asset(
    //                   Images.logo_3,
    //                   // Images.welcome_logo,
    //
    //                   height: 175),
    //             ],
    //           ));
    //     }));
  }
}
