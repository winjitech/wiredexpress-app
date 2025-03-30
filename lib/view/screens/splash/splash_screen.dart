// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:lacrostini_app/localization/language_constrants.dart';
// import 'package:lacrostini_app/provider/auth_provider.dart';
// import 'package:lacrostini_app/provider/cart_provider.dart';
// import 'package:lacrostini_app/provider/profile_provider.dart';
// import 'package:lacrostini_app/provider/search_provider.dart';
// import 'package:lacrostini_app/provider/splash_provider.dart';
// import 'package:lacrostini_app/provider/wishlist_provider.dart';
// import 'package:lacrostini_app/utill/images.dart';
// import 'package:lacrostini_app/utill/routes.dart';
// import 'package:lacrostini_app/view/screens/auth/login_screen.dart';
// import 'package:lacrostini_app/view/screens/search/search_notification.dart';
// import 'package:provider/provider.dart';
// import 'package:lacrostini_app/view/screens/splash/update_app_screen.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// class SplashScreen extends StatefulWidget {
//   final String? route_id;
//   SplashScreen({this.route_id,});
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   GlobalKey<ScaffoldMessengerState>? _globalKey = GlobalKey();
//  // StreamSubscription<ConnectivityResult>? _onConnectivityChanged;
//
//   String? searchedItem;
//   int? appVersion = 1;
//   int? _updateVersion;
//   String? configAppVersion;
//
//   @override
//   void initState() {
//     super.initState();
//
//      searchedItem = widget.route_id;
//
//     bool _firstTime = true;
//     // _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//     //   if(!_firstTime) {
//     //     bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
//     //     isNotConnected ? SizedBox() : _globalKey!.currentState!.hideCurrentSnackBar();
//     //     _globalKey!.currentState!.showSnackBar(SnackBar(
//     //       backgroundColor: isNotConnected ? Colors.red : Colors.green,
//     //       duration: Duration(seconds: isNotConnected ? 6000 : 3),
//     //       content: Text(
//     //         isNotConnected ? getTranslated('no_connection', _globalKey!.currentContext!) : getTranslated('connected', _globalKey!.currentContext!),
//     //         textAlign: TextAlign.center,
//     //       ),
//     //     ));
//     //     if(!isNotConnected) {
//     //       _route();
//     //     }
//     //   }
//     //   _firstTime = false;
//     // });
//
//     Provider.of<ProfileProvider>(context,listen: false).getUserInfo(context);
//     Provider.of<SplashProvider>(context, listen: false).initSharedData();
//     Provider.of<CartProvider>(context, listen: false).getCartData();
//     _route();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//    // _onConnectivityChanged!.cancel();
//   }
//
//   void _route() {
//     Provider.of<SplashProvider>(context, listen: false).initConfig(_globalKey!).then((bool isSuccess) {
//       if (isSuccess) {
//         Timer(Duration(seconds: 1), () async {
//         //  isPhoneOTP = Provider.of<SplashProvider>(context, listen: false).configModel!.phoneOTP;
//
//           if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()!) {
//             if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel == null) {
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()));
//             }
//             _updateVersion = Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.updateVersion;
//             configAppVersion = Provider.of<SplashProvider>(context, listen: false).configModel!.appVersion;
//
//           // _updateVersion == 1 means user didnt make the update but this doesnt mean that his app version is not update
//             // configAppVersion > appVersion means that the current version on play store is larger that the user's current version
//           if(_updateVersion == 1 && int.parse(configAppVersion!) > appVersion!){
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> UpdateAppScreen()));
//           } else {
//             Provider.of<SplashProvider>(context, listen: false).appUpdated(
//                 '0',
//                 Provider.of<AuthProvider>(context, listen: false).getUserToken()!);
//           }
//
//               Provider.of<AuthProvider>(context, listen: false).updateToken();
//               await Provider.of<WishListProvider>(context, listen: false).initWishList(context);
//
//               if(widget.route_id == '0') {
//                 Navigator.pushReplacementNamed(context, Routes.getMainRoute());
//               } else if(widget.route_id == 'chat') {
//                // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> ServicesDeliveryManChatScreen()));
//               }
//
//               else {
//                 if(searchedItem != '') {
//                    Provider.of<SearchProvider>(context, listen: false).searchProduct(searchedItem!, context);
//                   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> SearchNotification(searchString: searchedItem,)));
//                 } else {
//                   Navigator.pushReplacementNamed(context, Routes.getMainRoute());
//                 }
//               //  Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchResultScreen()));
//
//               //  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> Test(id: widget.route_id)));
//               }
//
//             } else {
//
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()));
//              // Navigator.pushReplacementNamed(context, ResponsiveHelper.isMobile(context) ? Routes.getLanguageRoute('splash') : Routes.getMainRoute());
//             }
//           }
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String _language = getTranslated('set_language', context);
//
//     return Scaffold(
//       key: _globalKey,
//       backgroundColor: Theme.of(context).primaryColor,
//       body: Center(
//         child: Consumer<SplashProvider>(builder: (context, splash, child) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//
//               Image.asset(Images.logo_a, height: 180),
//               // _language == '1'?
//               // Container(
//               //   decoration: BoxDecoration(
//               //       image: DecorationImage(
//               //         image: AssetImage(
//               //             "assets/image/logo_slogan.png"),
//               //         fit: BoxFit.cover,
//               //       )),
//               //   width: 230.0,
//               //   height: 30,
//               //
//               // ): SizedBox(),
//               SizedBox(height: 30),
//
//             /*  Text(
//                '${widget.route_id}',
//                 style: TextStyle(
//                   color: Colors.white
//                 ),
//               ),
//
//              */
//
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }
