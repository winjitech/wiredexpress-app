import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
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
                                                OrderModel order = orderProvider
                                                    .historyOrderList![index];
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
                                                          // height: 150,
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
                                                                        color: ColorResources.getBoxShadow(context),

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
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        height:
                                                                            100,
                                                                        width:
                                                                            100,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        imageUrl:
                                                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${order.details![0].productDetails!.image}',
                                                                        cacheKey:
                                                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${order.details![0].productDetails!.image}',
                                                                      ),
                                                                    ),
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
                                                                              '${getTranslated('order_id', context)}:${order.id}',
                                                                              style: TextStyle(color:ColorResources.getTextColor(context), fontWeight: FontWeight.w500, fontSize: 16)),
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
                                                                              ? Text(
                                                                                  '${order.details![0].productDetails!.name}',
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: TextStyle(color: ColorResources.getTextColor(context).withOpacity(0.5), fontWeight: FontWeight.w500, fontSize: 15),
                                                                                )
                                                                              : Text(
                                                                                  '${order.detailsCount} ${getTranslated('items', context)}',
                                                                                  style: TextStyle(color: ColorResources.getTextColor(context).withOpacity(0.5), fontWeight: FontWeight.w500, fontSize: 15),
                                                                                ),
                                                                          SizedBox(
                                                                            height:
                                                                                1,
                                                                          ),
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
                                                                          !orderProvider.showCancelled
                                                                              ? order.orderStatus == 'pending'
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
                                                                                                orderID: order.id.toString(),
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
                                                    CustomCircularIndicator(
                                                        color: ColorResources
                                                            .getScaffoldColor(
                                                                context))
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
                                                                      .getScaffoldColor(
                                                                          context)))))
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
