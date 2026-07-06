import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

      body: Column(
        children: [
          CustomAppBar(title: 'order_details', showBackButton: true),
          Expanded(
            child: Consumer2<OrderProvider, SplashProvider>(
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
                                padding: EdgeInsets.all(10.r),
                                child: Center(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Icon(
                                            Icons.watch_later,
                                            size: 17.sp,
                                            color:
                                                ColorResources.getTextColor(context),
                                          ),
                                          SizedBox(
                                              width: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          Text(
                                            DateConverter.isoStringToLocalDateOnly(context ,
                                                widget.orderModel!.createdAt!),
                                            style: AppTextStyles.h7(context),
                                          ),
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
                                            icon: Icon(Icons.map, size: 18.sp),
                                            label: Text(
                                              getTranslated(
                                                  'delivery_address', context),
                                              style: AppTextStyles.h8(
                                                context,
                                              ),
                                            ),
                                            style: TextButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(5.r),
                                                    side: BorderSide(
                                                        width: 1,
                                                        color: ColorResources
                                                            .getTextColor(context))),
                                                padding: EdgeInsets.all(10.r),
                                                minimumSize: Size(1, 30)),
                                          )
                                        ]),
                                        Divider(
                                            thickness: 1,
                                            color:
                                                ColorResources.getTextColor(context)
                                                    .withOpacity(0.4)),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8.r),
                                              decoration: BoxDecoration(
                                                color: scheduledColor.withOpacity(0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                isScheduled ? Icons.schedule : Icons.local_shipping,
                                                color: scheduledColor,
                                                size: 22.sp,
                                              ),
                                            ),
                                            SizedBox(width: 10.w),

                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    getTranslated(
                                                      isScheduled ? 'scheduled' : 'immediate',
                                                      context,
                                                    ),
                                                    style: AppTextStyles.h3(
                                                      context,
                                                      fontSize: 15.sp,
                                                    ).copyWith(
                                                      color: scheduledColor,
                                                      letterSpacing: .3,
                                                    ),
                                                  ),

                                                  if (isScheduled)
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 2.h),
                                                      child: Text(
                                                        "${DateConverter.formatScheduledDate(context, widget.orderModel!.deliveryDate!)} • "
                                                            "${DateConverter.formatScheduledTime(widget.orderModel!.deliveryTime!)}",
                                                        style: AppTextStyles.h6(context).copyWith(
                                                          color: ColorResources.getHintColor(context),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15.h),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: order.orderDetails!.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(10.r),
                                                    child: Row(children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(10.r),
                                                        child: CachedNetworkImage(
                                                          height: 80.h,
                                                          width: 80.w,
                                                          fit: BoxFit.cover,
                                                          imageUrl:
                                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${order.orderDetails![index].productDetails!.image}',
                                                          cacheKey:
                                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${order.orderDetails![index].productDetails!.image}',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: 10.w),
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
                                                                      style: AppTextStyles.h4(
                                                                          context,
                                                                          fontSize:
                                                                              15.sp),
                                                                      maxLines: 2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 5.h),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    '${getTranslated('quantity', context)}: ',
                                                                    style: AppTextStyles
                                                                        .h7(context),
                                                                  ),
                                                                  Text(
                                                                    order
                                                                        .orderDetails![
                                                                            index]
                                                                        .quantity
                                                                        .toString(),
                                                                    style: AppTextStyles.h4(
                                                                            context)
                                                                        .copyWith(
                                                                      color: ColorResources
                                                                          .getTextColor(
                                                                              context).withOpacity(0.8),
                                                                    ),
                                                                  ),
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
                                                          order.orderDetails![index]
                                                              .price,
                                                        ),
                                                        style: AppTextStyles.h4(
                                                                context)
                                                            .copyWith(
                                                          color: ColorResources
                                                              .getPrimaryColor(
                                                                  context),
                                                        ),
                                                      )
                                                    ]),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                ]);
                                          },
                                        ),
                                        SizedBox(height: 10.h),
                                        Divider(
                                            thickness: 1,
                                            color:
                                                ColorResources.getTextColor(context)
                                                    .withOpacity(0.4)),
                                        SizedBox(height: 10.h),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                getTranslated('items_price', context),
                                                style: AppTextStyles.h4(context),
                                              ),
                                              Text(
                                                PriceConverter.convertPrice(
                                                    context, itemsPrice),
                                                style: AppTextStyles.h4(context),
                                              ),
                                            ]),
                                        SizedBox(height: 10.h),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                getTranslated(
                                                    'total_products_discount',
                                                    context),
                                                style: AppTextStyles.h4(context),
                                              ),
                                              Text(
                                                "(-) $currency${Helpers.formatTextWithNum(discount.toString())}",
                                                style: AppTextStyles.h4(context),
                                              ),
                                            ]),
                                        SizedBox(height: 10.h),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                getTranslated(
                                                    'tiered_pricing_discount',
                                                    context),
                                                style: AppTextStyles.h4(context),
                                              ),
                                              Text(
                                                "(-) $currency${Helpers.formatTextWithNum(totalTieredPricingDiscount.toString())}",
                                                style: AppTextStyles.h4(context),
                                              ),
                                            ]),
                                        SizedBox(height: 10.h),
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
                                                          'coupon_discount', context),
                                                      style:
                                                          AppTextStyles.h4(context),
                                                    ),
                                                    Text(
                                                      '(-) ${splashProvider.configModel!.currencySymbol}${Helpers.formatTextWithNum(widget.orderModel!.couponDiscountAmount!.toString())}',
                                                      style:
                                                          AppTextStyles.h4(context),
                                                    ),
                                                  ]),
                                              SizedBox(height: 10.h),
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
                                                      style:
                                                          AppTextStyles.h4(context),
                                                    ),
                                                    Text(
                                                      '(-) ${splashProvider.configModel!.currencySymbol}${Helpers.formatTextWithNum(widget.orderModel!.loyaltyPointsDiscountAmount?.toString()??"0")}',
                                                      style:
                                                          AppTextStyles.h4(context),
                                                    ),
                                                  ]),
                                              SizedBox(height: 10.h),
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
                                                      style:
                                                          AppTextStyles.h4(context),
                                                    ),
                                                    Text(
                                                      '${splashProvider.configModel!.currencySymbol} ${Helpers.formatTextWithNum(widget.orderModel!.totalTaxAmount!.toString())}',
                                                      style:
                                                          AppTextStyles.h4(context),
                                                    ),
                                                  ]),
                                              SizedBox(height: 10.h),
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
                                                          'coupon_discount', context),
                                                      style:
                                                          AppTextStyles.h4(context),
                                                    ),
                                                    Text(
                                                      '(-) ${PriceConverter.convertPrice(context, widget.orderModel!.couponDiscountAmount)}',
                                                      style:
                                                          AppTextStyles.h4(context),
                                                    ),
                                                  ]),
                                        SizedBox(height: 10.h),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                getTranslated(
                                                    'delivery_fee', context),
                                                style: AppTextStyles.h4(context),
                                              ),
                                              Text(
                                                '(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
                                                style: AppTextStyles.h4(context),
                                              ),
                                            ]),
                                        SizedBox(height: 10.h),
                                        Divider(
                                            thickness: 1,
                                            color:
                                                ColorResources.getTextColor(context)
                                                    .withOpacity(0.4)),
                                        SizedBox(height: 10.h),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                getTranslated('total_price', context),
                                                style: AppTextStyles.h2(context)
                                                    .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      ColorResources.getPrimaryColor(
                                                          context),
                                                ),
                                              ),
                                              Text(
                                                PriceConverter.convertPrice(context,
                                                    widget.orderModel!.orderAmount),
                                                style: AppTextStyles.h2(context)
                                                    .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      ColorResources.getPrimaryColor(
                                                          context),
                                                ),
                                              ),
                                            ]),
                                        SizedBox(height: 10.h),
                                        Divider(
                                            thickness: 1,
                                            color:
                                                ColorResources.getTextColor(context)
                                                    .withOpacity(0.4)),
                                        SizedBox(height: 10.h),
                                        (widget.orderModel!.orderNote != null &&
                                                widget.orderModel!.orderNote!
                                                    .isNotEmpty)
                                            ? Container(
                                                width:
                                                    MediaQuery.of(context).size.width,
                                                padding: EdgeInsets.all(10.r),
                                                margin: EdgeInsets.only(
                                                    top: Dimensions
                                                        .PADDING_SIZE_LARGE),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10.r),
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                          ColorResources.getHintColor(
                                                              context)),
                                                ),
                                                child: Padding(
                                                    padding: EdgeInsets.all(10.r),
                                                    child: Text(
                                                      widget.orderModel!.orderNote!,
                                                      style: AppTextStyles.h7(context)
                                                          .copyWith(
                                                        color: ColorResources
                                                            .getHintColor(context),
                                                      ),
                                                    )),
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
                                              padding: EdgeInsets.all(10.r),
                                              child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    minimumSize: Size(1, 50),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(40.r),
                                                        side: BorderSide(
                                                            width: 2,
                                                            color: ColorResources
                                                                .getScaffoldBackgroundColor(
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
                                                              callback: (String
                                                                      message,
                                                                  bool isSuccess,
                                                                  String orderID) {
                                                                if (isSuccess) {
                                                                  showCustomSnackBar(
                                                                      '$message. Order ID: $orderID',
                                                                      context,
                                                                      isError: false);
                                                                } else {
                                                                  showCustomSnackBar(
                                                                      message,
                                                                      context);
                                                                }
                                                              },
                                                            ));
                                                  },
                                                  child: Text(
                                                    getTranslated(
                                                        'cancel_order', context),
                                                    style: AppTextStyles.h4(
                                                      context,
                                                    ).copyWith(
                                                      color: ColorResources
                                                          .getScaffoldBackgroundColor(
                                                              context),
                                                    ),
                                                  )),
                                            ))
                                          : SizedBox(),
                                    ]),
                                  ),
                                )
                              : Center(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      margin: EdgeInsets.all(10.r),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2,
                                            color: ColorResources
                                                .getScaffoldBackgroundColor(context)),
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                      child: Text(
                                        getTranslated('order_cancelled', context),
                                        style: AppTextStyles.h2(context).copyWith(
                                          color: ColorResources
                                              .getScaffoldBackgroundColor(context),
                                        ),
                                      )),
                                ),
                          (widget.orderModel!.orderStatus == 'confirmed' ||
                                  widget.orderModel!.orderStatus == 'processing' ||
                                  widget.orderModel!.orderStatus ==
                                      'out_for_delivery')
                              ? Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(10.r),
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
                          widget.orderModel!.orderStatus == 'delivered'
                              ? Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(10.r),
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
                        color: ColorResources.getScaffoldBackgroundColor(context));
              },
            ),
          ),
        ],
      ),
    );
  }
}
