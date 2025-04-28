import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/order_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/Custom_button.dart';
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
            builder: (context, placeOrderProvider, orderProvider, index) {
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                              itemCount: placeOrderProvider
                                                  .runningOrderList!.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                OrderModel order =
                                                    placeOrderProvider
                                                            .runningOrderList![
                                                        index];
                                                Color scheduledColor =
                                                    order.deliveryType ==
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
                                                        await orderProvider
                                                            .getOrderDetails(
                                                                order.id
                                                                    .toString(),
                                                                context);
                                                        orderProvider
                                                            .trackOrder(
                                                                order.id
                                                                    .toString(),
                                                                order,
                                                                context,
                                                                true)
                                                            .then((value) => Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext? context) => OrderDetailsScreen(
                                                                        orderModel:
                                                                            order,
                                                                        orderId:
                                                                            order.id!))));
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
                                                                      color: ColorResources
                                                                          .getBoxShadow(
                                                                              context),
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
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        height:
                                                                            120,
                                                                        width:
                                                                            120,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        imageUrl:
                                                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${order.details![0].productDetails!.image}',
                                                                        cacheKey:
                                                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${order.details![0].productDetails!.image}',
                                                                      ),
                                                                    ),
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
                                                                                  '${getTranslated('order_id', context)}:${order.id}',
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: TextStyle(color: ColorResources.getTextColor(context), fontWeight: FontWeight.w500, fontSize: 16),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Icon(
                                                                                order.deliveryType == "scheduled" ? Icons.schedule : Icons.local_shipping,
                                                                                color: scheduledColor,
                                                                                size: 20,
                                                                              ),
                                                                              const SizedBox(width: 5),
                                                                              Expanded(
                                                                                child: Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      getTranslated(order.deliveryType == "scheduled" ? 'scheduled' : 'immediate', context),
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
                                                                          order.detailsCount == 1
                                                                              ? Text('${order.details![0].productDetails!.name}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: ColorResources.getTextColor(context).withOpacity(0.5), fontWeight: FontWeight.w500, fontSize: 15))
                                                                              : Text('${order.detailsCount} ${getTranslated('items', context)}', style: TextStyle(color: ColorResources.getTextColor(context).withOpacity(0.5), fontWeight: FontWeight.w500, fontSize: 15)),
                                                                          SizedBox(
                                                                              height: 2),
                                                                          Text(
                                                                            '${Helpers.formatTextStatus(order.orderStatus!)}',
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: Helpers.statusColor(context, order.orderStatus!),
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 15),
                                                                          ),

                                                                          if (order.orderStatus == "out_for_delivery" ||
                                                                              order.orderStatus == "processing")
                                                                          CustomButton(
                                                                            text:
                                                                                getTranslated('track_order', context),
                                                                            height:
                                                                                35,
                                                                            textSize:
                                                                                16,
                                                                            onTap:
                                                                                () {
                                                                              orderProvider.trackOrder(order.id.toString(), order, context, true);
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => OrderTrackingScreen(
                                                                                    orderID: order.id.toString(),
                                                                                    track: order,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),

                                                                          !orderProvider.showCancelled
                                                                              ? order.orderStatus == 'pending'
                                                                                  ? CustomButton(
                                                                                      text: getTranslated('cancel_order', context),
                                                                                      height: 35,
                                                                                      textSize: 16,
                                                                                      backgroundColor: Colors.transparent,
                                                                                      textColor: Colors.red,
                                                                                      borderColor: Colors.red,
                                                                                      onTap: () => showDialog(
                                                                                          context: context,
                                                                                          barrierDismissible: false,
                                                                                          builder: (context) => OrderCancelDialog(
                                                                                                orderID: order.id.toString(),
                                                                                                callback: (String message, bool isSuccess, String orderID) {
                                                                                                  if (isSuccess) {
                                                                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$message. Order ID: $orderID'), backgroundColor: Colors.green));
                                                                                                  } else {
                                                                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
                                                                                                  }
                                                                                                },
                                                                                              )),
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
                                                                                )),
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
