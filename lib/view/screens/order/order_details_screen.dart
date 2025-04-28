import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/address_model.dart';
import 'package:wired_express/data/model/response/order_details_model.dart';
import 'package:wired_express/data/model/response/order_model.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/map_widget.dart';
import 'package:wired_express/view/screens/order/widget/order_cancel_dialog.dart';
import 'package:wired_express/view/screens/rare_review/rate_review_screen.dart';
import 'package:wired_express/view/screens/track/order_tracking_screen.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/theme_provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final int? orderId;

  OrderDetailsScreen({@required this.orderModel, @required this.orderId});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffold = GlobalKey();

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 0), () async {
      await Provider.of<LocationProvider>(context, listen: false)
          .initAddressList(context);
      await Provider.of<OrderProvider>(context, listen: false)
          .getOrderDetails(widget.orderId.toString(), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      key: _scaffold,
      appBar: CustomAppBar(
          title:
              '${getTranslated('order_details', context)}: ${widget.orderModel!.id.toString()}'),
      body: Consumer2<OrderProvider, SplashProvider>(
        builder: (context, order, splashProvider, child) {
          double deliveryCharge = 0;
          double itemsPrice = 0;
          double discount = 0;
          double tax = 0;
          double totalTieredPricingDiscount = 0;
          String currency = splashProvider.configModel!.currencySymbol ?? '\$';

          if (order.orderDetails != null) {
            print(
                "delivery address -- ${jsonEncode(Provider.of<LocationProvider>(context, listen: false).addressList!)}");
            deliveryCharge = widget.orderModel!.deliveryCharge!;
            for (OrderDetailsModel orderDetails in order.orderDetails!) {
              if (orderDetails.tieredPricing != null &&
                  orderDetails.tieredPricing!.productId != null) {
                totalTieredPricingDiscount = totalTieredPricingDiscount +
                    (double.parse(orderDetails.tieredPricing!.discountPrice!) *
                        orderDetails.quantity!);
              }
              itemsPrice = itemsPrice +
                  ((orderDetails.productDetails!.price!) *
                      orderDetails.quantity!);
              print("itemsPrice == $itemsPrice");
              discount = discount + (orderDetails.discountOnProduct!);
              tax = tax + (orderDetails.taxAmount! * orderDetails.quantity!);
            }
          }
          double subTotal = itemsPrice + tax;
          bool isScheduled = widget.orderModel!.deliveryType == "scheduled";
          Color scheduledColor = isScheduled
              ? ColorResources.getSecondaryColor(context)
              : ColorResources.getPrimaryColor(context);
          return order.orderDetails != null
              ? Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          child: Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Icon(
                                      Icons.watch_later,
                                      size: 17,
                                      color:
                                          ColorResources.getTextColor(context),
                                    ),
                                    SizedBox(
                                        width: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    Text(
                                        DateConverter.isoStringToLocalDateOnly(
                                            widget.orderModel!.createdAt!),
                                        style: rubikRegular.copyWith(
                                            color: ColorResources.getTextColor(
                                                context))),
                                    Expanded(child: SizedBox()),
                                    TextButton.icon(
                                      onPressed: () {
                                        AddressModel? address;
                                        for (AddressModel address
                                            in Provider.of<LocationProvider>(
                                                    context,
                                                    listen: false)
                                                .addressList!) {
                                          if (address.id ==
                                              widget.orderModel!
                                                  .deliveryAddressId) {
                                            address = address;
                                            break;
                                          }
                                        }
                                        if (address != null) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext? context) =>
                                                          MapWidget(
                                                              address:
                                                                  address)));
                                        } else {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'no_address_found', context),
                                              context);
                                        }
                                      },
                                      icon: Icon(Icons.map, size: 18),
                                      label: Text(
                                          getTranslated(
                                              'delivery_address', context),
                                          style: rubikMedium.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL)),
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: BorderSide(
                                                  width: 1,
                                                  color: ColorResources
                                                      .getTextColor(context))),
                                          padding: EdgeInsets.all(Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                          minimumSize: Size(1, 30)),
                                    )
                                  ]),
                                  Divider(
                                      thickness: 1,
                                      color:
                                          ColorResources.getTextColor(context)
                                              .withOpacity(0.4)),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color:
                                              scheduledColor.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isScheduled
                                              ? Icons.schedule
                                              : Icons.local_shipping,
                                          color: scheduledColor,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          getTranslated(
                                            isScheduled
                                                ? 'scheduled'
                                                : 'immediate',
                                            context,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: scheduledColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: order.orderDetails!.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: ColorResources
                                                            .getBoxShadow(
                                                                context),
                                                        blurRadius: 5,
                                                        spreadRadius: 1)
                                                  ],
                                                  color: ColorResources
                                                      .getScaffoldBackgroundColor(
                                                          context)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: CachedNetworkImage(
                                                      height: 80,
                                                      width: 80,
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${order.orderDetails![index].productDetails!.image}',
                                                      cacheKey:
                                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${order.orderDetails![index].productDetails!.image}',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: Dimensions
                                                          .PADDING_SIZE_SMALL),
                                                  Expanded(
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  '${order.orderDetails![index].productDetails!.name}',
                                                                  style: rubikMedium.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: ColorResources
                                                                          .getTextColor(
                                                                              context),
                                                                      fontSize:
                                                                          15),
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  '${getTranslated('quantity', context)}: ',
                                                                  style: rubikRegular
                                                                      .copyWith(
                                                                          color:
                                                                              ColorResources.getTextColor(context))),
                                                              Text(
                                                                  order
                                                                      .orderDetails![
                                                                          index]
                                                                      .quantity
                                                                      .toString(),
                                                                  style: rubikMedium.copyWith(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: ColorResources
                                                                          .getScaffoldColor(
                                                                              context))),
                                                            ],
                                                          )
                                                        ]),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    PriceConverter.convertPrice(
                                                        context,
                                                        order
                                                            .orderDetails![
                                                                index]
                                                            .price),
                                                    style: rubikMedium.copyWith(
                                                        color: ColorResources
                                                            .getPrimaryColor(
                                                                context)),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                          ]);
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Divider(
                                      thickness: 1,
                                      color:
                                          ColorResources.getTextColor(context)
                                              .withOpacity(0.4)),
                                  SizedBox(height: 10),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            getTranslated(
                                                'items_price', context),
                                            style: rubikMedium.copyWith(
                                                color:
                                                    ColorResources.getTextColor(
                                                        context),
                                                fontSize: Dimensions
                                                    .FONT_SIZE_LARGE)),
                                        Text(
                                            PriceConverter.convertPrice(
                                                context, itemsPrice),
                                            style: rubikMedium.copyWith(
                                                color:
                                                    ColorResources.getTextColor(
                                                        context),
                                                fontSize: Dimensions
                                                    .FONT_SIZE_LARGE)),
                                      ]),
                                  SizedBox(height: 10),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            getTranslated(
                                                'total_products_discount',
                                                context),
                                            style: rubikMedium.copyWith(
                                                color:
                                                    ColorResources.getTextColor(
                                                        context),
                                                fontSize: Dimensions
                                                    .FONT_SIZE_LARGE)),
                                        Text(
                                            "(-) $currency${Helpers.formatTextWithNum(discount.toString())}",
                                            style: rubikMedium.copyWith(
                                                color:
                                                    ColorResources.getTextColor(
                                                        context),
                                                fontSize: Dimensions
                                                    .FONT_SIZE_LARGE)),
                                      ]),
                                  SizedBox(height: 10),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            getTranslated(
                                                'tiered_pricing_discount',
                                                context),
                                            style: rubikMedium.copyWith(
                                                color:
                                                    ColorResources.getTextColor(
                                                        context),
                                                fontSize: Dimensions
                                                    .FONT_SIZE_LARGE)),
                                        Text(
                                            "(-) $currency${Helpers.formatTextWithNum(totalTieredPricingDiscount.toString())}",
                                            style: rubikMedium.copyWith(
                                                color:
                                                    ColorResources.getTextColor(
                                                        context),
                                                fontSize: Dimensions
                                                    .FONT_SIZE_LARGE)),
                                      ]),
                                  SizedBox(height: 10),
                                  if (widget.orderModel!.couponDiscountAmount !=
                                      0.0)
                                    Column(
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  getTranslated(
                                                      'coupon_discount',
                                                      context),
                                                  style: rubikMedium.copyWith(
                                                      color: ColorResources
                                                          .getTextColor(
                                                              context),
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_LARGE)),
                                              Text(
                                                  '(-) ${splashProvider.configModel!.currencySymbol}${Helpers.formatTextWithNum(widget.orderModel!.couponDiscountAmount!.toString())}',
                                                  style: rubikMedium.copyWith(
                                                      color: ColorResources
                                                          .getTextColor(
                                                              context),
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_LARGE)),
                                            ]),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  if (widget.orderModel!
                                          .loyaltyPointsDiscountAmount !=
                                      0.0)
                                    Column(
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  getTranslated(
                                                      'loyalty_points_discount',
                                                      context),
                                                  style: rubikMedium.copyWith(
                                                      color: ColorResources
                                                          .getTextColor(
                                                              context),
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_LARGE)),
                                              Text(
                                                  '(-) ${splashProvider.configModel!.currencySymbol}${Helpers.formatTextWithNum(widget.orderModel!.loyaltyPointsDiscountAmount!.toString())}',
                                                  style: rubikMedium.copyWith(
                                                      color: ColorResources
                                                          .getTextColor(
                                                              context),
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_LARGE)),
                                            ]),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  if (widget.orderModel!.totalTaxAmount != 0.0)
                                    Column(
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  getTranslated('tax', context),
                                                  style: rubikMedium.copyWith(
                                                      color: ColorResources
                                                          .getTextColor(
                                                              context),
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_LARGE)),
                                              Text(
                                                  '${splashProvider.configModel!.currencySymbol} ${Helpers.formatTextWithNum(widget.orderModel!.totalTaxAmount!.toString())}',
                                                  style: rubikMedium.copyWith(
                                                      color: ColorResources
                                                          .getTextColor(
                                                              context),
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_LARGE)),
                                            ]),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  widget.orderModel!.couponDiscountAmount == 0
                                      ? SizedBox()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                              Text(
                                                  getTranslated(
                                                      'coupon_discount',
                                                      context),
                                                  style: rubikMedium.copyWith(
                                                      color: ColorResources
                                                          .getTextColor(
                                                              context),
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_LARGE)),
                                              Text(
                                                '(-) ${PriceConverter.convertPrice(context, widget.orderModel!.couponDiscountAmount)}',
                                                style: rubikMedium.copyWith(
                                                    color: ColorResources
                                                        .getTextColor(context),
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_LARGE),
                                              ),
                                            ]),
                                  SizedBox(height: 10),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            getTranslated(
                                                'delivery_fee', context),
                                            style: rubikMedium.copyWith(
                                                color:
                                                    ColorResources.getTextColor(
                                                        context),
                                                fontSize: Dimensions
                                                    .FONT_SIZE_LARGE)),
                                        Text(
                                            '(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
                                            style: rubikMedium.copyWith(
                                                color:
                                                    ColorResources.getTextColor(
                                                        context),
                                                fontSize: Dimensions
                                                    .FONT_SIZE_LARGE)),
                                      ]),
                                  SizedBox(height: 10),
                                  Divider(
                                      thickness: 1,
                                      color:
                                          ColorResources.getTextColor(context)
                                              .withOpacity(0.4)),
                                  SizedBox(height: 10),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            getTranslated(
                                                'total_price', context),
                                            style: rubikMedium.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: ColorResources
                                                    .getPrimaryColor(context))),
                                        Text(
                                            PriceConverter.convertPrice(context,
                                                widget.orderModel!.orderAmount),
                                            style: rubikMedium.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: ColorResources
                                                    .getPrimaryColor(context))),
                                      ]),
                                  SizedBox(height: 10),
                                  Divider(
                                      thickness: 1,
                                      color:
                                          ColorResources.getTextColor(context)
                                              .withOpacity(0.4)),
                                  SizedBox(height: 10),
                                  (widget.orderModel!.orderNote != null &&
                                          widget.orderModel!.orderNote!
                                              .isNotEmpty)
                                      ? Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.only(
                                              top: Dimensions
                                                  .PADDING_SIZE_LARGE),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 1,
                                                color:
                                                    ColorResources.getHintColor(
                                                        context)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              widget.orderModel!.orderNote!,
                                              style: rubikRegular.copyWith(
                                                  color: ColorResources
                                                      .getHintColor(context)),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    !order.showCancelled
                        ? Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(children: [
                                widget.orderModel!.orderStatus == 'pending'
                                    ? Expanded(
                                        child: Padding(
                                        padding: EdgeInsets.all(
                                            Dimensions.PADDING_SIZE_SMALL),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            minimumSize: Size(1, 50),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                side: BorderSide(
                                                    width: 2,
                                                    color: ColorResources
                                                        .getScaffoldColor(
                                                            context))),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) =>
                                                    OrderCancelDialog(
                                                      orderID: widget
                                                          .orderModel!.id
                                                          .toString(),
                                                      callback: (String message,
                                                          bool isSuccess,
                                                          String orderID) {
                                                        if (isSuccess) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      '$message. Order ID: $orderID'),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green));
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      message),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green));
                                                        }
                                                      },
                                                    ));
                                          },
                                          child: Text(
                                              getTranslated(
                                                  'cancel_order', context),
                                              style: TextStyle(
                                                color: ColorResources
                                                    .getScaffoldColor(context),
                                                fontSize:
                                                    Dimensions.FONT_SIZE_LARGE,
                                              )),
                                        ),
                                      ))
                                    : SizedBox(),
                              ]),
                            ),
                          )
                        : Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              margin:
                                  EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2,
                                    color: ColorResources.getScaffoldColor(
                                        context)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                  getTranslated('order_cancelled', context),
                                  style: rubikBold.copyWith(
                                      color: ColorResources.getScaffoldColor(
                                          context))),
                            ),
                          ),
                    (widget.orderModel!.orderStatus == 'confirmed' ||
                            widget.orderModel!.orderStatus == 'processing' ||
                            widget.orderModel!.orderStatus ==
                                'out_for_delivery')
                        ? Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              child: CustomButton(
                                text: getTranslated('track_order', context),
                                onTap: () {
                                  widget.orderModel!.deliveryMan == null
                                      ? showCustomSnackBar(
                                          getTranslated('cant_track', context),
                                          context)
                                      : Provider.of<OrderProvider>(context,
                                              listen: false)
                                          .addDirections(
                                              LatLng(
                                                  double.parse(widget
                                                      .orderModel!
                                                      .deliveryMan!
                                                      .latitude!),
                                                  double.parse(widget
                                                      .orderModel!
                                                      .deliveryMan!
                                                      .longitude!)),
                                              LatLng(
                                                  double.parse(widget
                                                      .orderModel!
                                                      .deliveryAddress!
                                                      .latitude!),
                                                  double.parse(widget.orderModel!.deliveryAddress!.longitude!)))
                                          .then((value) => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => OrderTrackingScreen(orderID: widget.orderModel!.id.toString(), track: widget.orderModel!))));
                                },
                              ),
                            ),
                          )
                        : SizedBox(),
                    widget.orderModel!.orderStatus == 'finished'
                        ? Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              child: CustomButton(
                                text: getTranslated('review', context),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              RateReviewScreen(
                                                orderDetailsList:
                                                    order.orderDetails!,
                                              )));
                                },
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                )
              : CustomCircularIndicator(
                  color: ColorResources.getScaffoldColor(context));
        },
      ),
    );
  }
}
