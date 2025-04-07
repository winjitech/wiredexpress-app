// import 'package:flutter/material.dart';
// import 'package:sign_button/sign_button.dart';
// import 'package:wired_express/provider/splash_provider.dart';
// import 'package:wired_express/provider/theme_provider.dart';
// import 'package:wired_express/theme/dark_theme.dart';
// import 'package:wired_express/theme/light_theme.dart';
// import 'package:provider/provider.dart';
// import 'package:wired_express/data/model/response/cart_model.dart';
// import 'package:wired_express/data/model/response/order_details_model.dart';
// import 'package:wired_express/data/model/response/order_model.dart';
// import 'package:wired_express/helper/price_converter.dart';
// import 'package:wired_express/localization/language_constrants.dart';
// import 'package:wired_express/provider/order_provider.dart';
// import 'package:wired_express/provider/theme_provider.dart';
// import 'package:wired_express/utill/Images.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:wired_express/utill/dimensions.dart';
// import 'package:wired_express/utill/routes.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:wired_express/view/base/custom_button.dart';
// import 'package:wired_express/view/base/no_data_screen.dart';
// import 'package:wired_express/view/screens/checkout/checkout_screen.dart';
// import 'package:wired_express/view/screens/order/order_details_screen.dart';
// import 'package:wired_express/view/screens/order/widget/order_shimmer.dart';
// import 'package:provider/provider.dart';
// import 'package:wired_express/view/screens/track/order_tracking_screen.dart';
//
// class OrderView extends StatelessWidget {
//   final bool? isRunning;
//   OrderView({@required this.isRunning});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
//       body: Consumer<OrderProvider>(
//         builder: (context, order, index) {
//           List<OrderModel>? orderList;
//           if (order.runningOrderList != null) {
//             orderList = isRunning!
//                 ? order.runningOrderList!.reversed.toList()
//                 : order.historyOrderList!.reversed.toList();
//           }
//
//           return orderList != null
//               ? orderList.length > 0
//                   ? RefreshIndicator(
//                       onRefresh: () async {
//                         await Provider.of<OrderProvider>(context, listen: false)
//                             .getOrderList(context);
//                       },
//                       backgroundColor: ColorResources.getPrimaryColor(context),
//                       child: Scrollbar(
//                         child: SingleChildScrollView(
//                           physics: AlwaysScrollableScrollPhysics(),
//                           child: Center(
//                             child: SizedBox(
//                         width: MediaQuery.of(context).size.width,
//                               child: Column(
//                                 children: [
//                                   ListView.builder(
//                                       padding: EdgeInsets.all(
//                                           Dimensions.PADDING_SIZE_SMALL),
//                                       itemCount: orderList.length,
//                                       physics: NeverScrollableScrollPhysics(),
//                                       shrinkWrap: true,
//                                       itemBuilder: (context, index) {
//                                         return Container(
//                                             height: 150,
//                                             padding: EdgeInsets.all(
//                                                 Dimensions.PADDING_SIZE_SMALL),
//                                             margin: EdgeInsets.only(
//                                                 bottom: Dimensions
//                                                     .PADDING_SIZE_SMALL),
//                                             decoration: BoxDecoration(
//                                               color: ColorResources
//                                                   .getScaffoldBackgroundColor(
//                                                       context),
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color:
//                                                       Provider.of<ThemeProvider>(
//                                                                   context,
//                                                                   listen: false)
//                                                               .darkTheme
//                                                           ? Colors.black
//                                                               .withOpacity(0.4)
//                                                           : Colors.grey[300]!,
//                                                   blurRadius: 5,
//                                                   spreadRadius: 1,
//                                                 )
//                                               ],
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             child: Row(children: [
//                                               ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                   child:
//                                                       FadeInImage.assetNetwork(
//                                                           placeholder: Images
//                                                               .placeholder_image,
//                                                           image:
//                                                               '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/'
//                                                               '${order.orderDetails![index].productDetails!.image}',
//                                                           height: 70,
//                                                           width: 80,
//                                                           fit: BoxFit.cover)),
//                                               Text(
//                                                   '${orderList![index].detailsCount} ${getTranslated(orderList[index].detailsCount! > 1 ? 'items' : 'item', context)}')
//                                             ]));
//                                       }),
//                                   ListView.builder(
//                                     padding: EdgeInsets.all(
//                                         Dimensions.PADDING_SIZE_SMALL),
//                                     itemCount: orderList.length,
//                                     physics: NeverScrollableScrollPhysics(),
//                                     shrinkWrap: true,
//                                     itemBuilder: (context, index) {
//                                       return Container(
//                                         padding: EdgeInsets.all(
//                                             Dimensions.PADDING_SIZE_SMALL),
//                                         margin: EdgeInsets.only(
//                                             bottom:
//                                                 Dimensions.PADDING_SIZE_SMALL),
//                                         decoration: BoxDecoration(
//                                           color: ColorResources
//                                               .getScaffoldBackgroundColor(
//                                                   context),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Provider.of<ThemeProvider>(
//                                                           context)
//                                                       .darkTheme
//                                                   ? Colors.black
//                                                       .withOpacity(0.4)
//                                                   : Colors.grey[300]!,
//                                               blurRadius: 5,
//                                               spreadRadius: 1,
//                                             )
//                                           ],
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         child: Column(children: [
//                                           Row(children: [
//                                             SizedBox(
//                                                 width: Dimensions
//                                                     .PADDING_SIZE_SMALL),
//                                             Expanded(
//                                               child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Row(children: [
//                                                       Text('Order ID:',
//                                                           style: rubikRegular.copyWith(
//                                                               color: ColorResources
//                                                                   .getTextColor(
//                                                                       context),
//                                                               fontSize: Dimensions
//                                                                   .FONT_SIZE_SMALL)),
//                                                       SizedBox(
//                                                           width: Dimensions
//                                                               .PADDING_SIZE_EXTRA_SMALL),
//                                                       Text(
//                                                           orderList![index]
//                                                               .id
//                                                               .toString(),
//                                                           style: rubikMedium.copyWith(
//                                                               color: ColorResources
//                                                                   .getTextColor(
//                                                                       context),
//                                                               fontSize: Dimensions
//                                                                   .FONT_SIZE_SMALL)),
//                                                     ]),
//                                                     SizedBox(
//                                                         height: Dimensions
//                                                             .PADDING_SIZE_EXTRA_SMALL),
//                                                     Text(
//                                                       '${orderList[index].detailsCount} ${getTranslated(orderList[index].detailsCount! > 1 ? 'items' : 'item', context)}',
//                                                       style:
//                                                           rubikRegular.copyWith(
//                                                         color: Provider.of<
//                                                                         ThemeProvider>(
//                                                                     context,
//                                                                     listen:
//                                                                         false)
//                                                                 .darkTheme
//                                                             ? ColorResources
//                                                                 .DISABLE_COLOR
//                                                             : ColorResources
//                                                                 .COLOR_GREY,
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                         height: Dimensions
//                                                             .PADDING_SIZE_EXTRA_SMALL),
//                                                     Row(children: [
//                                                       Icon(Icons.check_circle,
//                                                           color: ColorResources
//                                                               .getPrimaryColor(
//                                                                   context),
//                                                           size: 15),
//                                                       SizedBox(
//                                                           width: Dimensions
//                                                               .PADDING_SIZE_EXTRA_SMALL),
//                                                       Text(
//                                                         '${orderList[index].orderStatus![0].toUpperCase()}${orderList[index].orderStatus!.substring(1).replaceAll('_', ' ')}',
//                                                         style: rubikRegular
//                                                             .copyWith(
//                                                           color: ColorResources
//                                                               .getPrimaryColor(
//                                                                   context),
//                                                         ),
//                                                       ),
//                                                     ]),
//                                                   ]),
//                                             ),
//                                           ]),
//                                           SizedBox(
//                                               height: Dimensions
//                                                   .PADDING_SIZE_LARGE),
//                                           SizedBox(
//                                             height: 50,
//                                             child: Row(children: [
//                                               Expanded(
//                                                   child: TextButton(
//                                                 style: TextButton.styleFrom(
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                     side: BorderSide(
//                                                         width: 2,
//                                                         color: Provider.of<
//                                                                         ThemeProvider>(
//                                                                     context,
//                                                                     listen:
//                                                                         false)
//                                                                 .darkTheme
//                                                             ? Colors.white
//                                                             : ColorResources
//                                                                 .DISABLE_COLOR),
//                                                   ),
//                                                   minimumSize: Size(1, 50),
//                                                   padding: EdgeInsets.all(0),
//                                                 ),
//                                                 onPressed: () async {
//                                                   await order.getOrderDetails(
//                                                       orderList![index]
//                                                           .id
//                                                           .toString(),
//                                                       context);
//                                                   order
//                                                       .trackOrder(
//                                                           orderList![index]
//                                                               .id
//                                                               .toString(),
//                                                           orderList[index],
//                                                           context,
//                                                           true)
//                                                       .then((value) => Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                               builder: (BuildContext?
//                                                                       context) =>
//                                                                   OrderDetailsScreen(
//                                                                       orderModel:
//                                                                           orderList![
//                                                                               index],
//                                                                       orderId: orderList[
//                                                                               index]
//                                                                           .id!))));
//
//                                                   // Navigator.pushNamed(
//                                                   //   context,
//                                                   //   Routes.getOrderDetailsRoute(orderList![index].id!),
//                                                   //   arguments: OrderDetailsScreen(orderModel: orderList[index], orderId: orderList[index].id!),
//                                                   // );
//                                                 },
//                                                 child: Text(
//                                                     getTranslated(
//                                                         'details', context),
//                                                     style: Theme.of(context)
//                                                         .textTheme
//                                                         .headline3!
//                                                         .copyWith(
//                                                           color: Provider.of<
//                                                                           ThemeProvider>(
//                                                                       context,
//                                                                       listen:
//                                                                           false)
//                                                                   .darkTheme
//                                                               ? Colors.white
//                                                               : ColorResources
//                                                                   .DISABLE_COLOR,
//                                                           fontSize: Dimensions
//                                                               .FONT_SIZE_LARGE,
//                                                         )),
//                                               )),
//                                               SizedBox(width: 20),
//                                               Expanded(
//                                                   child: CustomButton(
//                                                 text: getTranslated(
//                                                     isRunning!
//                                                         ? 'track_order'
//                                                         : 'reorder',
//                                                     context),
//                                                 onTap: () async {
//                                                   if (isRunning!) {
//                                                     print('step -1');
//                                                     order
//                                                         .trackOrder(
//                                                             orderList![index]
//                                                                 .id!
//                                                                 .toString(),
//                                                             orderList[index],
//                                                             context,
//                                                             true)
//                                                         .then((value) {
//                                                       print(
//                                                           'step -2 ${orderList![index].id!}');
//                                                       Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                               builder: (BuildContext
//                                                                       context) =>
//                                                                   OrderTrackingScreen(
//                                                                       orderID: orderList![
//                                                                               index]
//                                                                           .id!
//                                                                           .toString())));
//                                                       // Navigator.pushNamed(context, Routes.getOrderTrackingRoute(orderList[index].id!));
//                                                     });
//                                                   } else {
//                                                     List<OrderDetailsModel>
//                                                         orderDetails =
//                                                         await order
//                                                             .getOrderDetails(
//                                                                 orderList![
//                                                                         index]
//                                                                     .id
//                                                                     .toString(),
//                                                                 context);
//                                                     List<CartModel> _cartList =
//                                                         [];
//                                                     List<int> _availableList =
//                                                         [];
//                                                     orderDetails
//                                                         .forEach((orderDetail) {
//                                                       _availableList.add(
//                                                         orderDetail
//                                                             .productDetails!
//                                                             .status!,
//                                                       );
//                                                       //  _availableList.add(DateConverter.isAvailable(
//                                                       //    orderDetail.productDetails.availableTimeStarts, orderDetail.productDetails.availableTimeEnds, context,
//                                                       // ));
//                                                       // _cartList.add(CartModel(
//                                                       //     orderDetail.price,
//                                                       //     PriceConverter
//                                                       //         .convertWithDiscount(
//                                                       //             context,
//                                                       //             orderDetail
//                                                       //                 .price!,
//                                                       //             orderDetail
//                                                       //                 .discountOnProduct!,
//                                                       //             'amount'),
//                                                       //     orderDetail.variation,
//                                                       //     orderDetail
//                                                       //         .discountOnProduct,
//                                                       //     orderDetail.quantity,
//                                                       //     orderDetail.taxAmount,
//                                                       //     orderDetail
//                                                       //         .productDetails!));
//                                                     });
//                                                     //print('cart list ////////////////////');
//
//                                                     //  print('cart list ////////////////////');
//                                                     //  print(jsonEncode(_cartList));
//
//                                                     if (_availableList
//                                                         .contains(0)) {
//                                                       ScaffoldMessenger.of(
//                                                               context)
//                                                           .showSnackBar(
//                                                               SnackBar(
//                                                         content: Text(getTranslated(
//                                                             'one_or_more_product_unavailable',
//                                                             context)),
//                                                         backgroundColor:
//                                                             Colors.red,
//                                                       ));
//                                                     } else {
//                                                       Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                               builder: (BuildContext?
//                                                                       context) =>
//                                                                   CheckoutScreen(
//                                                                     cartList:
//                                                                         _cartList,
//                                                                     fromCart:
//                                                                         false,
//                                                                     amount: orderList![
//                                                                             index]
//                                                                         .orderAmount,
//                                                                     orderType: orderList[
//                                                                             index]
//                                                                         .orderType,
//                                                                   )));
//                                                       // Navigator.pushNamed(
//                                                       //   context,
//                                                       //   Routes.getCheckoutRoute(
//                                                       //       orderList[index]
//                                                       //           .orderAmount!,
//                                                       //       'reorder',
//                                                       //       orderList[index]
//                                                       //           .orderType!),
//                                                       //   arguments: CheckoutScreen(
//                                                       //     cartList: _cartList,
//                                                       //     fromCart: false,
//                                                       //     amount: orderList[index]
//                                                       //         .orderAmount,
//                                                       //     orderType:
//                                                       //         orderList[index]
//                                                       //             .orderType,
//                                                       //   ),
//                                                       // );
//                                                     }
//                                                   }
//                                                 },
//                                               )),
//                                             ]),
//                                           ),
//                                         ]),
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   : NoDataScreen(isOrder: true)
//               : OrderShimmer();
//         },
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/order_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/no_data_screen.dart';
import 'package:wired_express/view/screens/order/order_details_screen.dart';
import 'package:wired_express/view/screens/order/widget/order_cancel_dialog.dart';
import 'package:wired_express/view/screens/order/widget/order_shimmer.dart';
import 'package:wired_express/view/screens/track/order_tracking_screen.dart';

class OrderView extends StatefulWidget {
  final bool? isRunning;
  OrderView({@required this.isRunning});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () async {
      Provider.of<PlaceOrderProvider>(context, listen: false)
          .getRunningOrderList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
        body: Consumer2<PlaceOrderProvider, OrderProvider>(
            builder: (context, placeOrderProvider, order, index) {
          return placeOrderProvider.runningOrderList != null
              ? placeOrderProvider.runningOrderList!.length > 0
                  ? RefreshIndicator(
                      onRefresh: () async {
                        Provider.of<PlaceOrderProvider>(context, listen: false)
                            .getRunningOrderList(context);
                      },
                      backgroundColor: ColorResources.getPrimaryColor(context),
                      child: Scrollbar(
                          child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Center(
                                      child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                              itemCount: placeOrderProvider
                                                  .runningOrderList!.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                OrderModel _running =
                                                placeOrderProvider
                                                    .runningOrderList![
                                                index];
                                                Color scheduledColor =
                                                _running.deliveryType ==
                                                    'scheduled'
                                                    ? ColorResources
                                                    .getSecondaryColor(
                                                    context)
                                                    : ColorResources
                                                    .getPrimaryColor(
                                                    context);
                                                return Column(children: [
                                                  GestureDetector(
                                                      onTap: () async {
                                                        await order
                                                            .getOrderDetails(
                                                            _running.id
                                                                .toString(),
                                                            context);
                                                        order
                                                            .trackOrder(
                                                            _running.id
                                                                .toString(),
                                                            _running,
                                                            context,
                                                            true)
                                                            .then((value) => Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext? context) => OrderDetailsScreen(
                                                                    orderModel:
                                                                    _running,
                                                                    orderId:
                                                                    _running.id!))));
                                                      },
                                                      child: Container(
                                                        // height: 190,
                                                          width: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width,
                                                          decoration:
                                                          BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Provider.of<ThemeProvider>(context)
                                                                      .darkTheme
                                                                      ? Colors
                                                                      .black
                                                                      .withOpacity(0.4)
                                                                      : Colors.grey[300]!,
                                                                  blurRadius:
                                                                  5,
                                                                  spreadRadius:
                                                                  1,
                                                                ),
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
                                                                        120,
                                                                        width:
                                                                        120,
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                            Border.all(width: 1.0, color: Colors.black12),
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            color: Colors.white),
                                                                        child: Padding(
                                                                            padding: const EdgeInsets.all(5),
                                                                            child: FadeInImage.assetNetwork(
                                                                                placeholder: Images.loading,
                                                                                placeholderErrorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                                                                                  return Image.asset(Images.loading_icon, height: 70, width: 85, fit: BoxFit.cover);
                                                                                },
                                                                                imageErrorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) {
                                                                                  return Image.asset(Images.loading_icon, height: 70, width: 85, fit: BoxFit.cover);
                                                                                },
                                                                                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/'
                                                                                    '${_running.details![0].productDetails!.image}'))),
                                                                    SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    Expanded(
                                                                        child: Column(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      '${getTranslated('order_id', context)}:${_running.id}',
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: TextStyle(color: ColorResources.getScaffoldColor(context), fontWeight: FontWeight.w500, fontSize: 16),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Icon(
                                                                                    _running.deliveryType == "scheduled" ? Icons.schedule : Icons.local_shipping,
                                                                                    color: scheduledColor,
                                                                                    size: 20,
                                                                                  ),
                                                                                  const SizedBox(width: 5),
                                                                                  Expanded(
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          getTranslated(_running.deliveryType == "scheduled" ? 'scheduled' : 'immediate', context),
                                                                                          maxLines: 1,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: TextStyle(
                                                                                            color: scheduledColor,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: 15,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                  height: 2),
                                                                              SizedBox(
                                                                                  height: 1),
                                                                              _running.detailsCount == 1
                                                                                  ? Text('${_running.details![0].productDetails!.name}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15))
                                                                                  : Text('${_running.detailsCount} ${getTranslated('items', context)}', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15)),
                                                                              SizedBox(
                                                                                  height: 2),

                                                                              Text(
                                                                                '${Helpers.formatTextStatus(_running.orderStatus!)}',
                                                                                maxLines:
                                                                                1,
                                                                                overflow:
                                                                                TextOverflow.ellipsis,
                                                                                style: TextStyle(
                                                                                    color: Helpers.statusColor(context, _running.orderStatus!),
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: 15),
                                                                              ),
                                                                              if (_running.orderStatus == "out_for_delivery" ||
                                                                                  _running.orderStatus == "processing")
                                                                                TextButton(
                                                                                  style: TextButton.styleFrom(
                                                                                    padding: EdgeInsets.zero,
                                                                                    backgroundColor: ColorResources.getScaffoldColor(context),
                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                                                    minimumSize: Size(MediaQuery.of(context).size.width, 38),
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    order.trackOrder(_running.id.toString(), _running, context, true);
                                                                                    Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) => OrderTrackingScreen(
                                                                                        orderID: _running.id.toString(),
                                                                                        track: _running,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                  },
                                                                                  child: Text(
                                                                                    getTranslated('track_order', context),
                                                                                    style: TextStyle(color: Colors.white),
                                                                                  ),
                                                                                ),
                                                                              // MaterialButton(
                                                                              //   padding:
                                                                              //       EdgeInsets.all(0),
                                                                              //   elevation:
                                                                              //       0,
                                                                              //   minWidth:
                                                                              //       MediaQuery.of(context).size.width,
                                                                              //   color:
                                                                              //       ColorResources.getScaffoldColor(context),
                                                                              //   shape:
                                                                              //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                                              //   onPressed:
                                                                              //       () => _running.deliveryMan == null  ||_running.deliveryMan!.latitude==null? showCustomSnackBar(getTranslated('cant_track', context), context) : Provider.of<OrderProvider>(context, listen: false).addDirections(LatLng(double.parse(_running.deliveryMan!.latitude!), double.parse(_running.deliveryMan!.longitude!)), LatLng(double.parse(_running.deliveryAddress!.latitude!), double.parse(_running.deliveryAddress!.longitude!))).then((value) => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => OrderTrackingScreen(orderID: _running.id.toString(), track: _running)))),
                                                                              //   child:
                                                                              //       Text(
                                                                              //     getTranslated('track_order', context),
                                                                              //     style: TextStyle(color: Colors.white),
                                                                              //   ),
                                                                              // ),
                                                                              !order.showCancelled
                                                                                  ? _running.orderStatus == 'pending'
                                                                                  ? MaterialButton(
                                                                                padding: EdgeInsets.all(0),
                                                                                elevation: 0,
                                                                                minWidth: MediaQuery.of(context).size.width,
                                                                                color: Colors.grey[200],
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                                                                onPressed: () {
                                                                                  showDialog(
                                                                                      context: context,
                                                                                      barrierDismissible: false,
                                                                                      builder: (context) => OrderCancelDialog(
                                                                                        orderID: _running.id.toString(),
                                                                                        callback: (String message, bool isSuccess, String orderID) {
                                                                                          if (isSuccess) {
                                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$message. Order ID: $orderID'), backgroundColor: Colors.green));
                                                                                          } else {
                                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
                                                                                          }
                                                                                        },
                                                                                      ));
                                                                                },
                                                                                child: Text(
                                                                                  getTranslated('cancel_order', context),
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              )
                                                                                  : SizedBox()
                                                                                  : Center(
                                                                                  child: Container(
                                                                                    width: MediaQuery.of(context).size.width,
                                                                                    height: 50,
                                                                                    margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                                                                    alignment: Alignment.center,
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(width: 2, color: ColorResources.getPrimaryColor(context)),
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                    ),
                                                                                    child: Text(getTranslated('order_cancelled', context), style: rubikBold.copyWith(color: ColorResources.getPrimaryColor(context))),
                                                                                  ))
                                                                            ]))
                                                                  ])))),
                                                  SizedBox(height: 15)
                                                ]);
                                              })))))))
                  : NoDataScreen(isOrder: true)
              : OrderShimmer();
        }));
  }
}
