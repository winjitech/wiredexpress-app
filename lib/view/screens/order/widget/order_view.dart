
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
    Timer(Duration(seconds: 0), () async {
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
