// import 'dart:collection';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:lacrostini_app/data/model/response/cart_model.dart';
// import 'package:lacrostini_app/localization/language_constrants.dart';
// import 'package:lacrostini_app/provider/auth_provider.dart';
// import 'package:lacrostini_app/provider/location_provider.dart';
// import 'package:lacrostini_app/provider/order_provider.dart';
// import 'package:lacrostini_app/provider/profile_provider.dart';
// import 'package:lacrostini_app/provider/splash_provider.dart';
// import 'package:lacrostini_app/utill/color_resources.dart';
// import 'package:lacrostini_app/utill/dimensions.dart';
// import 'package:lacrostini_app/utill/styles.dart';
// import 'package:lacrostini_app/view/base/custom_app_bar.dart';
// import 'package:lacrostini_app/view/base/custom_button.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:lacrostini_app/view/screens/address/address_screen.dart';
// import 'package:lacrostini_app/view/screens/dashboard/dashboard_screen.dart';
// import 'package:provider/provider.dart';
//
// class SetAddressScreen extends StatefulWidget {
//
//   @override
//   _SetAddressScreenState createState() => _SetAddressScreenState();
// }
//
// class _SetAddressScreenState extends State<SetAddressScreen> {
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
//       GlobalKey<ScaffoldMessengerState>();
//   final TextEditingController _noteController = TextEditingController();
//   GoogleMapController? _mapController;
//
//   bool _loading = true;
//   Set<Marker> _markers = HashSet<Marker>();
//   bool? _isLoggedIn;
//   List<CartModel>? _cartList;
//
//   bool _isCashActive = true;
//   bool _isDigitalActive = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _isLoggedIn =
//         Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
//     if (_isLoggedIn!) {
//       if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel ==
//           null) {
//         Provider.of<ProfileProvider>(context, listen: false)
//             .getUserInfo(context);
//       }
//       Provider.of<LocationProvider>(context, listen: false)
//           .initAddressList(context);
//       Provider.of<OrderProvider>(context, listen: false).clearPrevData();
//       _cartList = [];
//       // widget.fromCart!
//       //     ? _cartList!.addAll(
//       //     Provider.of<CartProvider>(context, listen: false).cartList)
//       //     : _cartList!.addAll(widget.cartList!);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: CustomAppBar(title: "Select Address"),
//       body: Consumer<OrderProvider>(
//         builder: (context, order, child) {
//           return Consumer<LocationProvider>(
//             builder: (context, address, child) {
//               return SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   getTranslated('delivery_address', context),
//                                   style: rubikMedium.copyWith(
//                                     fontSize: Dimensions.FONT_SIZE_LARGE,
//                                   ),
//                                 ),
//                                 Expanded(child: SizedBox()),
//                                 TextButton.icon(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (BuildContext context) =>
//                                             AddressScreen(),
//                                       ),
//                                     );
//                                   },
//                                   icon: Icon(Icons.add),
//                                   label: Text(
//                                     getTranslated('add', context),
//                                     style: rubikRegular,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 20),
//                             SizedBox(
//                               height: 200,
//                               child: address.addressList != null
//                                   ? address.addressList!.length > 0
//                                       ? ListView.builder(
//                                           physics:
//                                               NeverScrollableScrollPhysics(),
//                                           scrollDirection: Axis.vertical,
//                                           padding: EdgeInsets.only(
//                                             left: Dimensions.PADDING_SIZE_LARGE,
//                                           ),
//                                           itemCount:
//                                               address.addressList!.length,
//                                           itemBuilder: (context, index) {
//                                             return Padding(
//                                               padding: const EdgeInsets.all(5),
//                                               child: InkWell(
//                                                 onTap: () {
//                                                   order.setAddressIndex(index);
//                                                 },
//                                                 child: Container(
//                                                   width: 200,
//                                                   decoration: BoxDecoration(
//                                                     color: index ==
//                                                             order.addressIndex
//                                                         ? Colors.white
//                                                         : ColorResources
//                                                             .getBackgroundColor(
//                                                                 context),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                     border: index ==
//                                                             order.addressIndex
//                                                         ? Border.all(
//                                                             color: Theme.of(
//                                                                     context)
//                                                                 .primaryColor,
//                                                             width: 2,
//                                                           )
//                                                         : null,
//                                                   ),
//                                                   child: Row(
//                                                     children: [
//                                                       Padding(
//                                                         padding: EdgeInsets
//                                                             .symmetric(
//                                                           horizontal: Dimensions
//                                                               .PADDING_SIZE_EXTRA_SMALL,
//                                                         ),
//                                                         child: Icon(
//                                                           address
//                                                                       .addressList![
//                                                                           index]
//                                                                       .addressType ==
//                                                                   'Home'
//                                                               ? Icons
//                                                                   .home_outlined
//                                                               : address
//                                                                           .addressList![
//                                                                               index]
//                                                                           .addressType ==
//                                                                       'Workplace'
//                                                                   ? Icons
//                                                                       .work_outline
//                                                                   : Icons
//                                                                       .list_alt_outlined,
//                                                           color: index ==
//                                                                   order
//                                                                       .addressIndex
//                                                               ? Theme.of(
//                                                                       context)
//                                                                   .primaryColor
//                                                               : Theme.of(
//                                                                       context)
//                                                                   .textTheme
//                                                                   .bodyText1!
//                                                                   .color,
//                                                           size: 30,
//                                                         ),
//                                                       ),
//                                                       Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           Text(
//                                                             address
//                                                                 .addressList![
//                                                                     index]
//                                                                 .addressType!,
//                                                             style: rubikRegular
//                                                                 .copyWith(
//                                                               fontSize: Dimensions
//                                                                   .FONT_SIZE_SMALL,
//                                                               color: ColorResources
//                                                                   .getGreyBunkerColor(
//                                                                       context),
//                                                             ),
//                                                           ),
//                                                           Text(
//                                                             address
//                                                                 .addressList![
//                                                                     index]
//                                                                 .address!,
//                                                             style: rubikRegular,
//                                                             maxLines: 1,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       index ==
//                                                               order.addressIndex
//                                                           ? Align(
//                                                               alignment:
//                                                                   Alignment
//                                                                       .topRight,
//                                                               child: Icon(
//                                                                 Icons
//                                                                     .check_circle,
//                                                                 color: Theme.of(
//                                                                         context)
//                                                                     .primaryColor,
//                                                               ),
//                                                             )
//                                                           : SizedBox(),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         )
//                                       : Center(
//                                           child: Text(
//                                             getTranslated(
//                                               'no_address_available',
//                                               context,
//                                             ),
//                                           ),
//                                         )
//                                   : Center(
//                                       child: CircularProgressIndicator(
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                           Theme.of(context).primaryColor,
//                                         ),
//                                       ),
//                                     ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                           width: MediaQuery.of(context).size.width,
//                           alignment: Alignment.center,
//                           padding:
//                               EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//                           child: Builder(
//                             builder: (context) => CustomButton(
//                                 text: 'Confirm Address',
//                                 onTap: () {
//                                   if ((address.addressList == null ||
//                                       address.addressList!.length == 0 ||
//                                       order.addressIndex < 0)) {
//                                     ScaffoldMessenger.of(context)
//                                         .showSnackBar(SnackBar(
//                                       content: Text(getTranslated(
//                                           'select_an_address', context)),
//                                       backgroundColor: Colors.red,
//                                     ));
//                                   } else {
//                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext? context)=> DashboardScreen(pageIndex: 0)));
//
//                                   }
//                                 }),
//                           )),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
