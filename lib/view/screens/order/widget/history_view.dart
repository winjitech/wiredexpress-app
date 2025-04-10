// import 'dart:async';
//
// import 'package:wired_express/data/model/response/cart_model.dart';
// import 'package:wired_express/data/model/response/order_details_model.dart';
// import 'package:wired_express/data/model/response/order_model.dart';
// import 'package:wired_express/helper/price_converter.dart';
// import 'package:wired_express/localization/language_constrants.dart';
// import 'package:flutter/material.dart';
// import 'package:wired_express/provider/order_provider.dart';
// import 'package:wired_express/provider/splash_provider.dart';
// import 'package:wired_express/provider/theme_provider.dart';
// import 'package:wired_express/utill/Images.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:wired_express/utill/dimensions.dart';
// // import 'package:wired_express/view/screens/order/widget/order_cancel_dialog.dart';
// import 'package:wired_express/view/screens/order/widget/order_shimmer.dart';
// import 'package:provider/provider.dart';
// import 'package:wired_express/utill/routes.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:wired_express/view/base/custom_button.dart';
// import 'package:wired_express/view/base/no_data_screen.dart';
// import 'package:wired_express/view/screens/checkout/checkout_screen.dart';
// import 'package:wired_express/view/screens/order/order_details_screen.dart';
// import 'package:wired_express/view/screens/track/order_tracking_screen.dart';
//
// class HistoryView extends StatefulWidget {
//   @override
//   _HistoryViewState createState() => _HistoryViewState();
// }
//
// class _HistoryViewState extends State<HistoryView> {
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
//       GlobalKey<ScaffoldMessengerState>();
//   ScrollController scrollController = new ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     Timer(Duration(seconds: 1), () async {
//       Provider.of<OrderProvider>(context, listen: false)
//           .getHistoryOrdersList(context, '1');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
//         key: _scaffoldKey,
//         body: Consumer<OrderProvider>(builder: (context, orderProvider, child) {
//           int ordersLength = orderProvider.historyOrderList!.length;
//           int totalSize = orderProvider.totalHistorySize ?? 0;
//
//           return orderProvider.historyOrderIsLoading
//               ? OrderShimmer()
//               : ordersLength == 0
//                   ? Center(child: NoDataScreen(isOrder: true))
//                   : Column(children: [
//                       Expanded(
//                           child: Scrollbar(
//                               child: SingleChildScrollView(
//                                   controller: scrollController,
//                                   physics: BouncingScrollPhysics(),
//                                   padding: EdgeInsets.all(
//                                       Dimensions.PADDING_SIZE_SMALL),
//                                   child: Row(children: [
//                                     Expanded(
//                                         child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                           ListView.builder(
//                                               padding: EdgeInsets.all(Dimensions
//                                                   .PADDING_SIZE_SMALL),
//                                               itemCount: orderProvider
//                                                   .historyOrderList!.length,
//                                               physics:
//                                                   NeverScrollableScrollPhysics(),
//                                               shrinkWrap: true,
//                                               itemBuilder: (context, index) {
//                                                 OrderModel _historyOrder =
//                                                     orderProvider
//                                                             .historyOrderList![
//                                                         index];
//
//                                                 return Column(children: [
//                                                   GestureDetector(
//                                                       onTap: () async {
//                                                         await orderProvider
//                                                             .getOrderDetails(
//                                                                 _historyOrder.id
//                                                                     .toString(),
//                                                                 context);
//                                                         orderProvider
//                                                             .trackOrder(
//                                                                 _historyOrder.id
//                                                                     .toString(),
//                                                                 _historyOrder,
//                                                                 context,
//                                                                 true)
//                                                             .then((value) => Navigator.push(
//                                                                 context,
//                                                                 MaterialPageRoute(
//                                                                     builder: (BuildContext? context) => OrderDetailsScreen(
//                                                                         orderModel:
//                                                                             _historyOrder,
//                                                                         orderId:
//                                                                             _historyOrder.id!))));
//                                                       },
//                                                       child: Container(
//                                                           height: 150,
//                                                           width:
//                                                               MediaQuery.of(context).size.width,
//                                                           decoration:
//                                                               BoxDecoration(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               10),
//                                                                   boxShadow: [
//                                                                     BoxShadow(
//                                                                       color: Provider.of<ThemeProvider>(context)
//                                                                               .darkTheme
//                                                                           ? Colors
//                                                                               .black
//                                                                               .withOpacity(0.4)
//                                                                           : Colors.grey[300]!,
//                                                                       blurRadius:
//                                                                           5,
//                                                                       spreadRadius:
//                                                                           1,
//                                                                     ),
//                                                                   ],
//                                                                   color: ColorResources
//                                                                       .getScaffoldBackgroundColor(
//                                                                           context)),
//                                                           child: Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .all(10),
//                                                               child: Row(
//                                                                   children: [
//                                                                     Container(
//                                                                         height:
//                                                                             180,
//                                                                         width:
//                                                                             150,
//                                                                         decoration: BoxDecoration(
//                                                                             borderRadius:
//                                                                                 BorderRadius.circular(10),
//                                                                             color: Colors.black12),
//                                                                         child: Padding(
//                                                                             padding: const EdgeInsets.all(5),
//                                                                             child: FadeInImage.assetNetwork(
//                                                                               placeholder: Images.done,
//                                                                               placeholderErrorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
//                                                                                 return Image.asset(Images.done, height: 70, width: 85, fit: BoxFit.cover);
//                                                                               },
//                                                                               imageErrorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
//                                                                                 return Image.asset(Images.done, height: 70, width: 85, fit: BoxFit.cover);
//                                                                               },
//                                                                               image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/'
//                                                                                   '${_historyOrder.details![0].productDetails!.image}',
//                                                                             ))),
//                                                                     SizedBox(
//                                                                         width:
//                                                                             15),
//                                                                     Expanded(
//                                                                         child: Column(
//                                                                             mainAxisAlignment:
//                                                                                 MainAxisAlignment.spaceBetween,
//                                                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                                                             children: [
//                                                                           Text(
//                                                                               '${getTranslated('order_id', context)}:${_historyOrder.id}',
//                                                                               style: TextStyle(color: ColorResources.getScaffoldColor(context), fontWeight: FontWeight.w500, fontSize: 16)),
//                                                                           SizedBox(
//                                                                               height: 1),
//                                                                           _historyOrder.detailsCount == 1
//                                                                               ? Text(
//                                                                                   '${_historyOrder.details![0].productDetails!.name}}',
//                                                                                   maxLines: 1,
//                                                                                   overflow: TextOverflow.ellipsis,
//                                                                                   style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
//                                                                                 )
//                                                                               : Text(
//                                                                                   '${_historyOrder.detailsCount} ${getTranslated('items', context)}',
//                                                                                   style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
//                                                                                 ),
//                                                                           SizedBox(
//                                                                             height:
//                                                                                 1,
//                                                                           ),
//                                                                           _historyOrder.detailsCount == 1
//                                                                               ? Text(
//                                                                                   '${_historyOrder.details![0].variation!.type} | ${_historyOrder.details![0].variation!.price}'.replaceAll('.0', ''),
//                                                                                 )
//                                                                               : SizedBox(),
//                                                                           SizedBox(
//                                                                             height:
//                                                                                 1,
//                                                                           ),
//                                                                           Text(
//                                                                             '${_historyOrder.orderStatus}',
//                                                                             maxLines:
//                                                                                 1,
//                                                                             overflow:
//                                                                                 TextOverflow.ellipsis,
//                                                                             style: TextStyle(
//                                                                                 color: Colors.orange[700],
//                                                                                 fontWeight: FontWeight.w500,
//                                                                                 fontSize: 15),
//                                                                           ),
//                                                                           MaterialButton(
//                                                                               elevation: 0,
//                                                                               minWidth: MediaQuery.of(context).size.width,
//                                                                               color: Colors.grey[200],
//                                                                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
//                                                                               onPressed: () async {
//                                                                                 List<OrderDetailsModel> orderDetails = await orderProvider.getOrderDetails(_historyOrder.id.toString(), context);
//                                                                                 List<CartModel> _cartList = [];
//                                                                                 List<int> _availableList = [];
//                                                                                 orderDetails.forEach((orderDetail) {
//                                                                                   _availableList.add(
//                                                                                     orderDetail.productDetails!.status!,
//                                                                                   );
//                                                                                   //  _availableList.add(DateConverter.isAvailable(
//                                                                                   //    orderDetail.productDetails.availableTimeStarts, orderDetail.productDetails.availableTimeEnds, context,
//                                                                                   // ));
//                                                                                   // _cartList.add(CartModel(
//                                                                                   //     orderDetail.price, PriceConverter.convertWithDiscount(context, orderDetail.price!, orderDetail.discountOnProduct!, 'amount'),
//                                                                                   //     orderDetail.variation, orderDetail.discountOnProduct, orderDetail.quantity,
//                                                                                   //     orderDetail.taxAmount, orderDetail.productDetails!
//                                                                                   // ));
//                                                                                 });
//                                                                                 //print('cart list ////////////////////');
//
//                                                                                 //  print('cart list ////////////////////');
//                                                                                 //  print(jsonEncode(_cartList));
//
//                                                                                 if (_availableList.contains(0)) {
//                                                                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                                                                     content: Text(getTranslated('one_or_more_product_unavailable', context)),
//                                                                                     backgroundColor: Colors.red,
//                                                                                   ));
//                                                                                 } else {
//                                                                                   Navigator.push(
//                                                                                       context,
//                                                                                       MaterialPageRoute(
//                                                                                           builder: (BuildContext? context) => HistoryCheckoutScreen(
//                                                                                                 cartList: _cartList,
//                                                                                                 fromCart: false,
//                                                                                                 amount: _historyOrder.orderAmount,
//                                                                                                 orderType: _historyOrder.orderType,
//                                                                                               )));
//                                                                                 }
//                                                                               },
//                                                                               child: Text(getTranslated('reorder', context), style: TextStyle(color: Colors.black))),
//                                                                           !orderProvider.showCancelled
//                                                                               ? _historyOrder.orderStatus == 'pending'
//                                                                                   ? MaterialButton(
//                                                                                       elevation: 0,
//                                                                                       minWidth: MediaQuery.of(context).size.width,
//                                                                                       color: Colors.black12,
//                                                                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
//                                                                                       onPressed: () {
//                                                                                         showDialog(
//                                                                                             context: context,
//                                                                                             barrierDismissible: false,
//                                                                                             builder: (context) => OrderCancelDialog(
//                                                                                                   orderID: _historyOrder.id.toString(),
//                                                                                                   callback: (String message, bool isSuccess, String orderID) {
//                                                                                                     if (isSuccess) {
//                                                                                                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$message. Order ID: $orderID'), backgroundColor: Colors.green));
//                                                                                                     } else {
//                                                                                                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
//                                                                                                     }
//                                                                                                   },
//                                                                                                 ));
//                                                                                       },
//                                                                                       child: Text(
//                                                                                         getTranslated('cancel_order', context),
//                                                                                         style: TextStyle(color: Colors.black),
//                                                                                       ),
//                                                                                     )
//                                                                                   : SizedBox()
//                                                                               : Center(
//                                                                                   child: Container(
//                                                                               width: MediaQuery.of(context).size.width,
//                                                                                   height: 50,
//                                                                                   margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//                                                                                   alignment: Alignment.center,
//                                                                                   decoration: BoxDecoration(
//                                                                                     border: Border.all(width: 2, color: ColorResources.getScaffoldColor(context)),
//                                                                                     borderRadius: BorderRadius.circular(10),
//                                                                                   ),
//                                                                                   child: Text(getTranslated('order_cancelled', context), style: rubikBold.copyWith(color: ColorResources.getScaffoldColor(context))),
//                                                                                 ))
//                                                                         ]))
//                                                                   ])))),
//                                                   SizedBox(height: 15)
//                                                 ]);
//                                               }),
//                                           // ListView.builder(
//                                           //   padding: EdgeInsets.all(
//                                           //       Dimensions.PADDING_SIZE_SMALL),
//                                           //   itemCount: orderProvider
//                                           //       .historyOrderList!.length,
//                                           //   physics:
//                                           //       NeverScrollableScrollPhysics(),
//                                           //   shrinkWrap: true,
//                                           //   itemBuilder: (context, index) {
//                                           //     OrderModel _historyOrder =
//                                           //         orderProvider
//                                           //             .historyOrderList![index];
//                                           //
//                                           //     return Column(
//                                           //       children: [
//                                           //         Container(
//                                           //           padding: EdgeInsets.all(
//                                           //               Dimensions
//                                           //                   .PADDING_SIZE_SMALL),
//                                           //           margin: EdgeInsets.only(
//                                           //               bottom: Dimensions
//                                           //                   .PADDING_SIZE_SMALL),
//                                           //           decoration: BoxDecoration(
//                                           //             color: ColorResources
//                                           //                 .getScaffoldBackgroundColor(
//                                           //                     context),
//                                           //             boxShadow: [
//                                           //               BoxShadow(
//                                           //                 color: Provider.of<
//                                           //                                 ThemeProvider>(
//                                           //                             context)
//                                           //                         .darkTheme
//                                           //                     ? Colors.black
//                                           //                         .withOpacity(
//                                           //                             0.4)
//                                           //                     : Colors
//                                           //                         .grey[300]!,
//                                           //                 blurRadius: 5,
//                                           //                 spreadRadius: 1,
//                                           //               )
//                                           //             ],
//                                           //             borderRadius:
//                                           //                 BorderRadius.circular(
//                                           //                     10),
//                                           //           ),
//                                           //           child: Column(children: [
//                                           //             Row(children: [
//                                           //               SizedBox(
//                                           //                   width: Dimensions
//                                           //                       .PADDING_SIZE_SMALL),
//                                           //               Expanded(
//                                           //                 child: Column(
//                                           //                     crossAxisAlignment:
//                                           //                         CrossAxisAlignment
//                                           //                             .start,
//                                           //                     children: [
//                                           //                       Row(children: [
//                                           //                         Text(
//                                           //                             '${getTranslated('order_id', context)}:',
//                                           //                             style: rubikRegular.copyWith(
//                                           //                                 color: ColorResources.getTextColor(
//                                           //                                     context),
//                                           //                                 fontSize:
//                                           //                                     Dimensions.FONT_SIZE_SMALL)),
//                                           //                         SizedBox(
//                                           //                             width: Dimensions
//                                           //                                 .PADDING_SIZE_EXTRA_SMALL),
//                                           //                         Text(
//                                           //                             _historyOrder
//                                           //                                 .id
//                                           //                                 .toString(),
//                                           //                             style: rubikMedium.copyWith(
//                                           //                                 color: ColorResources.getTextColor(
//                                           //                                     context),
//                                           //                                 fontSize:
//                                           //                                     Dimensions.FONT_SIZE_SMALL)),
//                                           //                       ]),
//                                           //                       SizedBox(
//                                           //                           height: Dimensions
//                                           //                               .PADDING_SIZE_EXTRA_SMALL),
//                                           //                       Text(
//                                           //                         '${_historyOrder.detailsCount} ${getTranslated(_historyOrder.detailsCount! > 1 ? 'items' : 'item', context)}',
//                                           //                         style: rubikRegular
//                                           //                             .copyWith(
//                                           //                           color: Provider.of<ThemeProvider>(context,
//                                           //                                       listen:
//                                           //                                           false)
//                                           //                                   .darkTheme
//                                           //                               ? ColorResources
//                                           //                                   .DISABLE_COLOR
//                                           //                               : ColorResources
//                                           //                                   .COLOR_GREY,
//                                           //                         ),
//                                           //                       ),
//                                           //                       SizedBox(
//                                           //                           height: Dimensions
//                                           //                               .PADDING_SIZE_EXTRA_SMALL),
//                                           //                       Row(children: [
//                                           //                         Icon(
//                                           //                             Icons
//                                           //                                 .check_circle,
//                                           //                             color: ColorResources
//                                           //                                 .getPrimaryColor(
//                                           //                                     context),
//                                           //                             size: 15),
//                                           //                         SizedBox(
//                                           //                             width: Dimensions
//                                           //                                 .PADDING_SIZE_EXTRA_SMALL),
//                                           //                         Text(
//                                           //                           '${_historyOrder.orderStatus![0].toUpperCase()}${_historyOrder.orderStatus!.substring(1).replaceAll('_', ' ')}',
//                                           //                           style: rubikRegular
//                                           //                               .copyWith(
//                                           //                                   color:
//                                           //                                       ColorResources.getPrimaryColor(context)),
//                                           //                         ),
//                                           //                       ]),
//                                           //                     ]),
//                                           //               ),
//                                           //             ]),
//                                           //             SizedBox(
//                                           //                 height: Dimensions
//                                           //                     .PADDING_SIZE_LARGE),
//                                           //             SizedBox(
//                                           //               height: 50,
//                                           //               child: Row(children: [
//                                           //                 Expanded(
//                                           //                     child: TextButton(
//                                           //                   style: TextButton
//                                           //                       .styleFrom(
//                                           //                     shape:
//                                           //                         RoundedRectangleBorder(
//                                           //                       borderRadius:
//                                           //                           BorderRadius
//                                           //                               .circular(
//                                           //                                   10),
//                                           //                       side: BorderSide(
//                                           //                           width: 2,
//                                           //                           color: Provider.of<ThemeProvider>(context,
//                                           //                                       listen:
//                                           //                                           false)
//                                           //                                   .darkTheme
//                                           //                               ? Colors
//                                           //                                   .white
//                                           //                               : ColorResources
//                                           //                                   .DISABLE_COLOR),
//                                           //                     ),
//                                           //                     minimumSize:
//                                           //                         Size(1, 50),
//                                           //                     padding:
//                                           //                         EdgeInsets
//                                           //                             .all(0),
//                                           //                   ),
//                                           //                   onPressed:
//                                           //                       () async {
//                                           //                     await orderProvider
//                                           //                         .getOrderDetails(
//                                           //                             _historyOrder
//                                           //                                 .id
//                                           //                                 .toString(),
//                                           //                             context);
//                                           //                     orderProvider
//                                           //                         .trackOrder(
//                                           //                             _historyOrder
//                                           //                                 .id
//                                           //                                 .toString(),
//                                           //                             _historyOrder,
//                                           //                             context,
//                                           //                             true)
//                                           //                         .then((value) => Navigator.push(
//                                           //                             context,
//                                           //                             MaterialPageRoute(
//                                           //                                 builder: (BuildContext? context) => OrderDetailsScreen(
//                                           //                                     orderModel: _historyOrder,
//                                           //                                     orderId: _historyOrder.id!))));
//                                           //                     // await Provider.of<OrderProvider>(context, listen: false).trackOrder(widget.orderId.toString(), widget.orderModel!, context, true) ;
//                                           //
//                                           //                     // Navigator.push(context, MaterialPageRoute(builder: (BuildContext? context)=>
//                                           //                     //     OrderDetailsScreen(orderModel: _historyOrder, orderId: _historyOrder.id!)));
//                                           //                     // Navigator.pushNamed(
//                                           //                     //   context,
//                                           //                     //   Routes.getOrderDetailsRoute(_historyOrder.id!),
//                                           //                     //   arguments: OrderDetailsScreen(orderModel: _historyOrder, orderId: _historyOrder.id!),
//                                           //                     // );
//                                           //                   },
//                                           //                   child: Text(
//                                           //                       getTranslated(
//                                           //                           'details',
//                                           //                           context),
//                                           //                       style: Theme.of(
//                                           //                               context)
//                                           //                           .textTheme
//                                           //                           .headline3!
//                                           //                           .copyWith(
//                                           //                             color: Provider.of<ThemeProvider>(context, listen: false).darkTheme
//                                           //                                 ? Colors
//                                           //                                     .white
//                                           //                                 : ColorResources
//                                           //                                     .DISABLE_COLOR,
//                                           //                             fontSize:
//                                           //                                 Dimensions
//                                           //                                     .FONT_SIZE_LARGE,
//                                           //                           )),
//                                           //                 )),
//                                           //                 SizedBox(width: 20),
//                                           //                 Expanded(
//                                           //                     child:
//                                           //                         CustomButton(
//                                           //                   text:
//                                           //                       getTranslated(
//                                           //                           'reorder',
//                                           //                           context),
//                                           //                   onTap: () async {
//                                           //                     List<OrderDetailsModel>
//                                           //                         orderDetails =
//                                           //                         await orderProvider.getOrderDetails(
//                                           //                             _historyOrder
//                                           //                                 .id
//                                           //                                 .toString(),
//                                           //                             context);
//                                           //                     List<CartModel>
//                                           //                         _cartList =
//                                           //                         [];
//                                           //                     List<int>
//                                           //                         _availableList =
//                                           //                         [];
//                                           //                     orderDetails.forEach(
//                                           //                         (orderDetail) {
//                                           //                       _availableList
//                                           //                           .add(
//                                           //                         orderDetail
//                                           //                             .productDetails!
//                                           //                             .status!,
//                                           //                       );
//                                           //                       //  _availableList.add(DateConverter.isAvailable(
//                                           //                       //    orderDetail.productDetails.availableTimeStarts, orderDetail.productDetails.availableTimeEnds, context,
//                                           //                       // ));
//                                           //                       // _cartList.add(CartModel(
//                                           //                       //     orderDetail.price, PriceConverter.convertWithDiscount(context, orderDetail.price!, orderDetail.discountOnProduct!, 'amount'),
//                                           //                       //     orderDetail.variation, orderDetail.discountOnProduct, orderDetail.quantity,
//                                           //                       //     orderDetail.taxAmount, orderDetail.productDetails!
//                                           //                       // ));
//                                           //                     });
//                                           //                     //print('cart list ////////////////////');
//                                           //
//                                           //                     //  print('cart list ////////////////////');
//                                           //                     //  print(jsonEncode(_cartList));
//                                           //
//                                           //                     if (_availableList
//                                           //                         .contains(
//                                           //                             0)) {
//                                           //                       ScaffoldMessenger.of(
//                                           //                               context)
//                                           //                           .showSnackBar(
//                                           //                               SnackBar(
//                                           //                         content: Text(
//                                           //                             getTranslated(
//                                           //                                 'one_or_more_product_unavailable',
//                                           //                                 context)),
//                                           //                         backgroundColor:
//                                           //                             Colors
//                                           //                                 .red,
//                                           //                       ));
//                                           //                     } else {
//                                           //                       Navigator.push(
//                                           //                           context,
//                                           //                           MaterialPageRoute(
//                                           //                             builder: (BuildContext?
//                                           //                                     context) =>
//                                           //                                 HistoryCheckoutScreen(
//                                           //                               cartList:
//                                           //                                   _cartList,
//                                           //                               fromCart:
//                                           //                                   false,
//                                           //                               amount:
//                                           //                                   _historyOrder.orderAmount,
//                                           //                               orderType:
//                                           //                                   _historyOrder.orderType,
//                                           //                             ),
//                                           //                           ));
//                                           //                       // Navigator.pushNamed(
//                                           //                       //   context,
//                                           //                       //   Routes.getCheckoutRoute(_historyOrder.orderAmount!, 'reorder', _historyOrder.orderType!),
//                                           //                       //   arguments: CheckoutScreen(
//                                           //                       //     cartList: _cartList,
//                                           //                       //     fromCart: false,
//                                           //                       //     amount: _historyOrder.orderAmount,
//                                           //                       //     orderType: _historyOrder.orderType,
//                                           //                       //   ),
//                                           //                       // );
//                                           //                     }
//                                           //                   },
//                                           //                 )),
//                                           //               ]),
//                                           //             ),
//                                           //           ]),
//                                           //         ),
//                                           //         SizedBox(
//                                           //           height: 5,
//                                           //         )
//                                           //       ],
//                                           //     );
//                                           //   },
//                                           // ),
//                                           // Text('$ordersLength $totalSize'),
//
//                                           orderProvider
//                                                   .bottomHistoryOrderLoading
//                                               ? Column(
//                                                   children: [
//                                                     SizedBox(height: 10),
//                                                     CustomCircularIndicator(color:ColorResources.getScaffoldColor(context))
//                                                   ],
//                                                 )
//                                               : ordersLength < totalSize
//                                                   ? Center(
//                                                       child: GestureDetector(
//                                                           onTap: () {
//                                                             String offset =
//                                                                 orderProvider
//                                                                         .historyOrderOffset ??
//                                                                     '';
//                                                             int offsetInt =
//                                                                 int.parse(
//                                                                         offset) +
//                                                                     1;
//                                                             print(
//                                                                 '$offset -- $offsetInt');
//                                                             orderProvider
//                                                                 .showBottomHistoryOrderLoader();
//                                                             orderProvider
//                                                                 .getHistoryOrdersList(
//                                                               context,
//                                                               offsetInt
//                                                                   .toString(),
//                                                             );
//                                                           },
//                                                           child: Text(
//                                                               '${getTranslated('load_more', context)}...',
//                                                               style: TextStyle(
//                                                                   color: ColorResources
//                                                                       .getScaffoldColor(context)))))
//                                                   : SizedBox()
//                                         ]))
//                                   ])))),
//                       SizedBox(height: 15)
//                     ]);
//         }));
//   }
//
//   void _callback(bool isSuccess, String status) async {
//     if (isSuccess) {
//       Provider.of<OrderProvider>(context, listen: false).clearHistoryOffset();
//       Provider.of<OrderProvider>(context, listen: false)
//           .getHistoryOrdersList(context, '1')
//           .then((value) {
//         showDialog(
//             context: context,
//             builder: (_) => AlertDialog(
//                 title: Text('Status Updated!',
//                     style: TextStyle(
//                         fontSize: 13, fontWeight: FontWeight.normal))));
//       });
//     } else {
//       showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//               title: Text('Error occurred, try again later..',
//                   style:
//                       TextStyle(fontSize: 13, fontWeight: FontWeight.normal))));
//     }
//   }
// }

import 'dart:async';

import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/order_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/screens/order/widget/order_cancel_dialog.dart';
import 'package:wired_express/view/screens/order/widget/order_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/no_data_screen.dart';
import 'package:wired_express/view/screens/order/order_details_screen.dart';

class HistoryView extends StatefulWidget {
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 0), () async {
      Provider.of<OrderProvider>(context, listen: false)
          .getHistoryOrdersList(context, '1');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
        key: _scaffoldKey,
        body: Consumer<OrderProvider>(builder: (context, orderProvider, child) {
          int ordersLength = orderProvider.historyOrderList!.length;
          int totalSize = orderProvider.totalHistorySize ?? 0;

          return orderProvider.historyOrderIsLoading
              ? OrderShimmer()
              : ordersLength == 0
                  ? Center(child: NoDataScreen(isOrder: true))
                  : Column(children: [
                      Expanded(
                          child: Scrollbar(
                              child: SingleChildScrollView(
                                  controller: scrollController,
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL),
                                  child: Row(children: [
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          ListView.builder(
                                              padding: EdgeInsets.all(Dimensions
                                                  .PADDING_SIZE_SMALL),
                                              itemCount: orderProvider
                                                  .historyOrderList!.length,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                OrderModel _historyOrder =
                                                orderProvider
                                                    .historyOrderList![
                                                index];
                                                Color scheduledColor = _historyOrder.deliveryType == 'scheduled'
                                                    ? ColorResources.getSecondaryColor(
                                                    context)
                                                    : ColorResources.getPrimaryColor(
                                                    context);

                                                return Column(children: [
                                                  GestureDetector(
                                                      onTap: () async {
                                                        await orderProvider
                                                            .getOrderDetails(
                                                            _historyOrder.id
                                                                .toString(),
                                                            context);
                                                        orderProvider
                                                            .trackOrder(
                                                            _historyOrder.id
                                                                .toString(),
                                                            _historyOrder,
                                                            context,
                                                            true)
                                                            .then((value) => Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext? context) => OrderDetailsScreen(
                                                                    orderModel:
                                                                    _historyOrder,
                                                                    orderId:
                                                                    _historyOrder.id!))));
                                                      },
                                                      child: Container(
                                                        // height: 150,
                                                          width:
                                                          MediaQuery.of(context).size.width,
                                                          decoration:
                                                          BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Provider.of<ThemeProvider>(context).darkTheme
                                                                        ? Colors.black.withOpacity(
                                                                        0.4)
                                                                        : Colors.grey[
                                                                    300]!,
                                                                    blurRadius:
                                                                    5,
                                                                    spreadRadius:
                                                                    1)
                                                              ],
                                                              color: ColorResources
                                                                  .getScaffoldBackgroundColor(
                                                                  context)),
                                                          child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                              child: Row(
                                                                  children: [
                                                                    Container(
                                                                        height:
                                                                        100,
                                                                        width:
                                                                        100,
                                                                        decoration: BoxDecoration(
                                                                            border: Border.all(width: 1.0, color: Colors.black12),
                                                                            borderRadius:
                                                                            BorderRadius.circular(10),
                                                                            color: Colors.white),
                                                                        child: Padding(
                                                                            padding: const EdgeInsets.all(5),
                                                                            child: FadeInImage.assetNetwork(
                                                                              placeholder: Images.loading,
                                                                              placeholderErrorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                                                                                return Image.asset(Images.loading, height: 70, width: 85, fit: BoxFit.cover);
                                                                              },
                                                                              imageErrorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                                                                                return Image.asset(Images.loading, height: 70, width: 85, fit: BoxFit.cover);
                                                                              },
                                                                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/'
                                                                                  '${_historyOrder.details![0].productDetails!.image}',
                                                                            ))),
                                                                    SizedBox(
                                                                        width:
                                                                        15),
                                                                    Expanded(
                                                                        child: Column(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                  '${getTranslated('order_id', context)}:${_historyOrder.id}',
                                                                                  style: TextStyle(color: ColorResources.getScaffoldColor(context), fontWeight: FontWeight.w500, fontSize: 16)),
                                                                              Row(
                                                                                children: [
                                                                                  Icon(
                                                                                    _historyOrder.deliveryType == "scheduled"
                                                                                        ? Icons.schedule
                                                                                        : Icons
                                                                                        .local_shipping,
                                                                                    color: scheduledColor,
                                                                                    size: 20,
                                                                                  ),
                                                                                  const SizedBox(width: 5),
                                                                                  Expanded(
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          getTranslated(
                                                                                              _historyOrder.deliveryType == "scheduled"
                                                                                                  ? 'scheduled'
                                                                                                  : 'immediate',
                                                                                              context),
                                                                                          maxLines: 1,
                                                                                          overflow:
                                                                                          TextOverflow
                                                                                              .ellipsis,
                                                                                          style: TextStyle(
                                                                                            color:
                                                                                            scheduledColor,
                                                                                            fontWeight:
                                                                                            FontWeight
                                                                                                .w500,
                                                                                            fontSize: 15,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(height: 2),
                                                                              SizedBox(
                                                                                  height: 1),
                                                                              _historyOrder.detailsCount == 1
                                                                                  ? Text(
                                                                                '${_historyOrder.details![0].productDetails!.name}',
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
                                                                              )
                                                                                  : Text(
                                                                                '${_historyOrder.detailsCount} ${getTranslated('items', context)}',
                                                                                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),
                                                                              ),

                                                                              SizedBox(
                                                                                height:
                                                                                1,
                                                                              ),
                                                                              Text(
                                                                                '${Helpers.formatTextStatus(_historyOrder.orderStatus!)}',
                                                                                maxLines:
                                                                                1,
                                                                                overflow:
                                                                                TextOverflow.ellipsis,
                                                                                style: TextStyle(
                                                                                    color:Helpers.statusColor(context , _historyOrder.orderStatus!),
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: 15),
                                                                              ),

                                                                              !orderProvider.showCancelled
                                                                                  ? _historyOrder.orderStatus == 'pending'
                                                                                  ? MaterialButton(
                                                                                  elevation: 0,
                                                                                  minWidth: MediaQuery.of(context).size.width,
                                                                                  color: Colors.black12,
                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                                                  onPressed: () {
                                                                                    showDialog(
                                                                                        context: context,
                                                                                        barrierDismissible: false,
                                                                                        builder: (context) => OrderCancelDialog(
                                                                                            orderID: _historyOrder.id.toString(),
                                                                                            callback: (String message, bool isSuccess, String orderID) {
                                                                                              if (isSuccess) {
                                                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$message. Order ID: $orderID'), backgroundColor: Colors.green));
                                                                                              } else {
                                                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
                                                                                              }
                                                                                            }));
                                                                                  },
                                                                                  child: Text(
                                                                                    getTranslated('cancel_order', context),
                                                                                    style: TextStyle(color: Colors.black),
                                                                                  ))
                                                                                  : SizedBox()
                                                                                  : Center(
                                                                                  child: Container(
                                                                                    width: MediaQuery.of(context).size.width,
                                                                                    height: 50,
                                                                                    margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                                                                    alignment: Alignment.center,
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(width: 2, color: ColorResources.getScaffoldColor(context)),
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                    ),
                                                                                    child: Text(getTranslated('order_cancelled', context), style: rubikBold.copyWith(color: ColorResources.getScaffoldColor(context))),
                                                                                  ))
                                                                            ]))
                                                                  ])))),
                                                  SizedBox(height: 15)
                                                ]);
                                              }),
                                          orderProvider
                                                  .bottomHistoryOrderLoading
                                              ? Column(
                                                  children: [
                                                    SizedBox(height: 10),
                                                    CustomCircularIndicator(color:ColorResources.getScaffoldColor(context))
                                                  ],
                                                )
                                              : ordersLength < totalSize
                                                  ? Center(
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            String offset =
                                                                orderProvider
                                                                        .historyOrderOffset ??
                                                                    '';
                                                            int offsetInt =
                                                                int.parse(
                                                                        offset) +
                                                                    1;
                                                            print(
                                                                '$offset -- $offsetInt');
                                                            orderProvider
                                                                .showBottomHistoryOrderLoader();
                                                            orderProvider
                                                                .getHistoryOrdersList(
                                                              context,
                                                              offsetInt
                                                                  .toString(),
                                                            );
                                                          },
                                                          child: Text(
                                                              '${getTranslated('load_more', context)}...',
                                                              style: TextStyle(
                                                                  color: ColorResources
                                                                      .getScaffoldColor(context)))))
                                                  : SizedBox()
                                        ]))
                                  ])))),
                      SizedBox(height: 15)
                    ]);
        }));
  }

  // void _callback(bool isSuccess, String status) async {
  //   if (isSuccess) {
  //     Provider.of<OrderProvider>(context, listen: false).clearHistoryOffset();
  //     Provider.of<OrderProvider>(context, listen: false)
  //         .getHistoryOrdersList(context, '1')
  //         .then((value) {
  //       showDialog(
  //           context: context,
  //           builder: (_) => AlertDialog(
  //               title: Text('Status Updated!',
  //                   style: TextStyle(
  //                       fontSize: 13, fontWeight: FontWeight.normal))));
  //     });
  //   } else {
  //     showDialog(
  //         context: context,
  //         builder: (_) => AlertDialog(
  //             title: Text('Error occurred, try again later..',
  //                 style:
  //                     TextStyle(fontSize: 13, fontWeight: FontWeight.normal))));
  //   }
  // }
}
