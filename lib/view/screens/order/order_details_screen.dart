import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/utill/app_constants.dart';
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
import 'package:wired_express/view/base/custom_divider.dart';
import 'package:wired_express/view/base/map_widget.dart';
import 'package:wired_express/view/screens/order/widget/change_method_dialog.dart';
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
    Timer(Duration(seconds: 1), () async {
      await Provider.of<LocationProvider>(context, listen: false)
          .initAddressList(context);

      await Provider.of<OrderProvider>(context, listen: false)
          .getOrderDetails(widget.orderId.toString(), context);
      // await Provider.of<OrderProvider>(context, listen: false).trackOrder(widget.orderId.toString(), widget.orderModel!, context, true) ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      key: _scaffold,
      appBar: CustomAppBar(
          title:
              '${getTranslated('order_details', context)}: ${widget.orderModel!.id.toString()}'),
      body: Consumer<OrderProvider>(
        builder: (context, order, child) {
          double deliveryCharge = 0;
          double _itemsPrice = 0;
          double _discount = 0;
          double _tax = 0;

          if (order.orderDetails != null) {
            // print('trackmodel -- ${jsonEncode(order.trackModel)}');
            print("delivery address -- ${jsonEncode(Provider.of<LocationProvider>(context, listen: false).addressList!)}");
            deliveryCharge = widget.orderModel!.deliveryCharge!;
            for (OrderDetailsModel orderDetails in order.orderDetails!) {
              _itemsPrice = _itemsPrice + (orderDetails.price! * orderDetails.quantity!);
              _discount = _discount +
                  (orderDetails.discountOnProduct!
                  // * orderDetails.quantity!
                  );
              _tax = _tax + (orderDetails.taxAmount! * orderDetails.quantity!);
            }
          }
          double _subTotal = _itemsPrice + _tax;
          double _total = _itemsPrice -
              _discount +
              widget.orderModel!.totalTaxAmount! +
              deliveryCharge -
              (order.trackModel != null
                  ? widget.orderModel!.couponDiscountAmount!
                  : 0);

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
                                    // Text(
                                    //     '${getTranslated('order_id', context)}:',
                                    //     style: rubikRegular.copyWith(
                                    //         color: ColorResources.getTextColor(
                                    //             context))),
                                    // SizedBox(
                                    //     width: Dimensions
                                    //         .PADDING_SIZE_EXTRA_SMALL),
                                    // Text(widget.orderModel!.id.toString(),
                                    //     style: rubikRegular.copyWith(
                                    //         color: ColorResources.getTextColor(
                                    //             context))),
                                    // SizedBox(
                                    //     width: Dimensions
                                    //         .PADDING_SIZE_EXTRA_SMALL),
                                    // Expanded(child: SizedBox()),
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
                                        //  final address =
                                        //  Provider.of<LocationProvider>(
                                        //      context,
                                        //      listen: false)
                                        //      .addressList!;
                                        // AddressModel? filteredAddresses =
                                        //  address
                                        //      .where((address) =>
                                        //  address.id ==
                                        //      order.trackModel!
                                        //          .deliveryAddressId)
                                        //      .toList();
                                        //
                                        //  if (filteredAddresses.isNotEmpty) {
                                        //    Navigator.push(
                                        //        context,
                                        //        MaterialPageRoute(
                                        //            builder:
                                        //                (BuildContext? context) =>
                                        //                MapWidget(
                                        //                  address:
                                        //                  filteredAddresses
                                        //                 ,
                                        //                )));
                                        //  } else {}

                                        //
                                        // Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //           builder:
                                        //               (BuildContext? context) =>
                                        //                   MapWidget(
                                        //                     address: _address,
                                        //                   )));

                                        AddressModel? _address;
                                        for (AddressModel address
                                            in Provider.of<LocationProvider>(
                                                    context,
                                                    listen: false)
                                                .addressList!) {
                                          if (address.id ==
                                              widget.orderModel!
                                                  .deliveryAddressId) {
                                            _address = address;
                                            break;
                                          }
                                        }
                                        if (_address != null) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext? context) =>
                                                          MapWidget(
                                                            address: _address,
                                                          )));
                                          //
                                          // Navigator.pushNamed(context, Routes.getMapRoute(
                                          //   _address.address!, _address.addressType!, _address.latitude!, _address.longitude!, _address.contactPersonName!,
                                          //   _address.contactPersonNumber!, _address.id!, _address.userId!,
                                          // ));
                                        } else {
                                          showCustomSnackBar(
                                              getTranslated('no_address_found', context), context);
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
                                  // SizedBox(
                                  //     height: Dimensions.PADDING_SIZE_LARGE),
                                  //
                                  // Row(children: [
                                  //   Text('${getTranslated('item', context)}:',
                                  //       style: rubikRegular.copyWith(
                                  //           color: ColorResources.getTextColor(
                                  //               context))),
                                  //   SizedBox(
                                  //       width: Dimensions
                                  //           .PADDING_SIZE_EXTRA_SMALL),
                                  //   Text(
                                  //       widget.orderModel!.detailsCount
                                  //           .toString(),
                                  //       style: rubikMedium.copyWith(
                                  //           color:
                                  //               ColorResources.getPrimaryColor(
                                  //                   context))),
                                  //   Expanded(child: SizedBox()),
                                  //   TextButton.icon(
                                  //     onPressed: () {
                                  //       //  final address =
                                  //       //  Provider.of<LocationProvider>(
                                  //       //      context,
                                  //       //      listen: false)
                                  //       //      .addressList!;
                                  //       // AddressModel? filteredAddresses =
                                  //       //  address
                                  //       //      .where((address) =>
                                  //       //  address.id ==
                                  //       //      order.trackModel!
                                  //       //          .deliveryAddressId)
                                  //       //      .toList();
                                  //       //
                                  //       //  if (filteredAddresses.isNotEmpty) {
                                  //       //    Navigator.push(
                                  //       //        context,
                                  //       //        MaterialPageRoute(
                                  //       //            builder:
                                  //       //                (BuildContext? context) =>
                                  //       //                MapWidget(
                                  //       //                  address:
                                  //       //                  filteredAddresses
                                  //       //                 ,
                                  //       //                )));
                                  //       //  } else {}
                                  //
                                  //       //
                                  //       // Navigator.push(
                                  //       //       context,
                                  //       //       MaterialPageRoute(
                                  //       //           builder:
                                  //       //               (BuildContext? context) =>
                                  //       //                   MapWidget(
                                  //       //                     address: _address,
                                  //       //                   )));
                                  //
                                  //       AddressModel? _address;
                                  //       for (AddressModel address
                                  //           in Provider.of<LocationProvider>(
                                  //                   context,
                                  //                   listen: false)
                                  //               .addressList!) {
                                  //         if (address.id ==
                                  //             widget.orderModel!
                                  //                 .deliveryAddressId) {
                                  //           _address = address;
                                  //           break;
                                  //         }
                                  //       }
                                  //       if (_address != null) {
                                  //         Navigator.push(
                                  //             context,
                                  //             MaterialPageRoute(
                                  //                 builder:
                                  //                     (BuildContext? context) =>
                                  //                         MapWidget(
                                  //                           address: _address,
                                  //                         )));
                                  //         //
                                  //         // Navigator.pushNamed(context, Routes.getMapRoute(
                                  //         //   _address.address!, _address.addressType!, _address.latitude!, _address.longitude!, _address.contactPersonName!,
                                  //         //   _address.contactPersonNumber!, _address.id!, _address.userId!,
                                  //         // ));
                                  //       } else {
                                  //         showCustomSnackBar(
                                  //             "No address found", context);
                                  //       }
                                  //     },
                                  //     icon: Icon(Icons.map, size: 18),
                                  //     label: Text(
                                  //         getTranslated(
                                  //             'delivery_address', context),
                                  //         style: rubikMedium.copyWith(
                                  //             fontSize:
                                  //                 Dimensions.FONT_SIZE_SMALL)),
                                  //     style: TextButton.styleFrom(
                                  //         shape: RoundedRectangleBorder(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(5),
                                  //             side: BorderSide(
                                  //                 width: 1,
                                  //                 color: ColorResources
                                  //                     .getTextColor(context))),
                                  //         padding: EdgeInsets.all(Dimensions
                                  //             .PADDING_SIZE_EXTRA_SMALL),
                                  //         minimumSize: Size(1, 30)),
                                  //   )
                                  //   // TextButton.icon(
                                  //   //   onPressed: () {
                                  //   //     AddressModel? _address;
                                  //   //     List<AddressModel>? addressList = Provider.of<LocationProvider>(context, listen: false).addressList;
                                  //   //
                                  //   //     if (addressList != null) {
                                  //   //       for (AddressModel address in addressList) {
                                  //   //         if (address.id == order.trackModel!.deliveryAddressId) {
                                  //   //           _address = address;
                                  //   //           break;
                                  //   //         }
                                  //   //       }
                                  //   //     }
                                  //   //
                                  //   //     if (_address != null) {
                                  //   //       Navigator.push(context, MaterialPageRoute(builder: (BuildContext? context) => MapWidget(address: _address,)));
                                  //   //     } else {
                                  //   //       print("null address");
                                  //   //     }
                                  //   //   },
                                  //   //   icon: Icon(Icons.map, size: 18),
                                  //   //   label: Text(getTranslated('delivery_address', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                                  //   //   style: TextButton.styleFrom(
                                  //   //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(width: 1)),
                                  //   //     padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  //   //     minimumSize: Size(1, 30),
                                  //   //   ),
                                  //   // )
                                  // ]),
                                  Divider(
                                    thickness: 1,
                                  ),
                                  SizedBox(height: 10),

                                  // Payment info
                                  // Align(
                                  //   alignment: Alignment.center,
                                  //   child: Text(getTranslated('payment_info', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  // ),
                                  // SizedBox(height: 10),
                                  // Row(children: [
                                  //   Expanded(flex: 2, child: Text(getTranslated('status', context), style: rubikRegular)),
                                  //   Expanded(flex: 8, child: Text(
                                  //     getTranslated(order.trackModel!.paymentStatus!, context),
                                  //     style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                                  //   )),
                                  // ]),
                                  // SizedBox(height: 5),
                                  // Row(children: [
                                  //   Expanded(flex: 2, child: Text(getTranslated('method', context), style: rubikRegular)),
                                  //   Expanded(flex: 8, child: Row(children: [
                                  //     Text(
                                  //       (order.trackModel!.paymentMethod! != null && order.trackModel!.paymentMethod!.length > 0)
                                  //           ? order.trackModel!.paymentMethod == 'cash_on_delivery' ? getTranslated('cash_on_delivery', context)
                                  //           : '${order.trackModel!.paymentMethod![0].toUpperCase()}${order.trackModel!.paymentMethod!.substring(1).replaceAll('_', ' ')}'
                                  //           : getTranslated('digital_payment', context),
                                  //       style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                                  //     ),
                                  //     (order.trackModel!.paymentStatus != 'paid' && order.trackModel!.paymentMethod != 'cash_on_delivery'
                                  //         && order.trackModel!.orderStatus != 'delivered') ? InkWell(
                                  //       onTap: () {
                                  //         showDialog(context: context, barrierDismissible: false, builder: (context) => ChangeMethodDialog(
                                  //           orderID: order.trackModel!.id.toString(), callback: (String message, bool isSuccess) {
                                  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: isSuccess ? Colors.green : Colors.red));
                                  //         },
                                  //         ));
                                  //       },
                                  //       child: Container(
                                  //         alignment: Alignment.center,
                                  //         margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  //         padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL, vertical: 2),
                                  //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withOpacity(0.5)),
                                  //         child: Text(getTranslated('change', context), style: rubikRegular.copyWith(fontSize: 10, color: Colors.black)),
                                  //       ),
                                  //     ) : SizedBox(),
                                  //   ])),
                                  // ]),
                                  // Divider(height: 40),
                                  //

                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: order.orderDetails!.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10),
                                            Container(
                                              height: 100,
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Provider.of<
                                                                      ThemeProvider>(
                                                                  context)
                                                              .darkTheme
                                                          ? Colors.black
                                                              .withOpacity(0.4)
                                                          : Colors.grey[300]!,
                                                      blurRadius: 5,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                  color: ColorResources
                                                      .getScaffoldBackgroundColor(
                                                          context)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(children: [
                                                  Container(
                                                      height: 90,
                                                      width: 90,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              Colors.black12),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          placeholder:
                                                              Images.loading,
                                                          placeholderErrorBuilder:
                                                              (BuildContext?
                                                                      context,
                                                                  Object?
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                            return Image.asset(
                                                                Images.loading,
                                                                height: 70,
                                                                width: 85,
                                                                fit: BoxFit
                                                                    .cover);
                                                          },
                                                          imageErrorBuilder:
                                                              (BuildContext?
                                                                      context,
                                                                  Object?
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                            return Image.asset(
                                                                Images.loading,
                                                                height: 70,
                                                                width: 85,
                                                                fit: BoxFit
                                                                    .cover);
                                                          },
                                                          image:
                                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/'
                                                              '${order.orderDetails![index].productDetails!.image}',
                                                          height: 90,
                                                          width: 90,
                                                        ),
                                                      )),
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

                                                          Row(children: [
                                                            order.orderDetails![index]
                                                                        .discountOnProduct! >
                                                                    0
                                                                ? Text(
                                                                    '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(
                                                                        context,
                                                                        order
                                                                            .orderDetails![index]
                                                                            .price)}',
                                                                    style: rubikBold
                                                                        .copyWith(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough,
                                                                      fontSize:
                                                                          Dimensions
                                                                              .FONT_SIZE_SMALL,
                                                                      color: Provider.of<ThemeProvider>(context, listen: false).darkTheme
                                                                          ? ColorResources
                                                                              .DISABLE_COLOR
                                                                          : ColorResources
                                                                              .COLOR_GREY,
                                                                    ),
                                                                  )
                                                                : SizedBox(),
                                                            SizedBox(width: 5),
                                                            Text(
                                                              '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(
                                                                  context,
                                                                  order.orderDetails![index].price! -
                                                                      order.orderDetails![index].discountOnProduct!)}',
                                                              style: rubikBold.copyWith(
                                                                  color: ColorResources
                                                                      .SCAFFOLD_COLOR),
                                                            ),
                                                          ]),
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
                                                                          .SCAFFOLD_COLOR)),
                                                            ],
                                                          )
                                                          // Row(children: [
                                                          //   Container(
                                                          //       height: 10,
                                                          //       width: 10,
                                                          //       decoration:
                                                          //           BoxDecoration(
                                                          //         shape: BoxShape
                                                          //             .circle,
                                                          //         color: Theme.of(
                                                          //                 context)
                                                          //             .textTheme
                                                          //             .bodyText1!
                                                          //             .color,
                                                          //       )),
                                                          //   SizedBox(
                                                          //       width: Dimensions
                                                          //           .PADDING_SIZE_EXTRA_SMALL),
                                                          // Text(
                                                          //   '${getTranslated(widget.orderModel!.orderStatus == 'delivered' ? 'delivered_at' : 'ordered_at', context)} '
                                                          //   '${DateConverter.isoStringToLocalDateOnly(widget.orderModel!.orderStatus! == 'delivered' ? order.orderDetails![index].updatedAt! : order.orderDetails![index].createdAt!)}',
                                                          //   style: rubikRegular.copyWith(
                                                          //       color: ColorResources
                                                          //           .getTextColor(
                                                          //               context),
                                                          //       fontSize:
                                                          //           Dimensions
                                                          //               .FONT_SIZE_SMALL),
                                                          // ),
                                                          // ]),
                                                        ]),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ]);
                                    },
                                  ),
                                  SizedBox(height: 10),

                                  Divider(
                                    thickness: 1,
                                  ),
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
                                            '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(context,
                                                _itemsPrice - _discount)}',
                                            style: rubikMedium.copyWith(
                                                color:
                                                    ColorResources.getTextColor(
                                                        context),
                                                fontSize: Dimensions
                                                    .FONT_SIZE_LARGE)),
                                      ]),



                                  SizedBox(height: 10),

                                 if(widget.orderModel!.couponDiscountAmount!=0.0)
                                   Column(children: [
                                     Row(
                                         mainAxisAlignment:
                                         MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text(
                                               getTranslated(
                                                   'coupon_discount', context),
                                               style: rubikMedium.copyWith(
                                                   color:
                                                   ColorResources.getTextColor(
                                                       context),
                                                   fontSize: Dimensions
                                                       .FONT_SIZE_LARGE)),
                                           Text(
                                               '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol} ${Helpers.formatTextWithNum(widget.orderModel!.couponDiscountAmount!.toString())}',
                                               style: rubikMedium.copyWith(
                                                   color:
                                                   ColorResources.getTextColor(
                                                       context),
                                                   fontSize: Dimensions
                                                       .FONT_SIZE_LARGE)),
                                         ]),

                                     SizedBox(height: 10),
                                   ],) ,
                                  if(widget.orderModel!.totalTaxAmount!=0.0)
                                    Column(children: [
                                      Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                getTranslated(
                                                    'tax', context),
                                                style: rubikMedium.copyWith(
                                                    color:
                                                    ColorResources.getTextColor(
                                                        context),
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_LARGE)),
                                            Text(
                                                '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol} ${Helpers.formatTextWithNum(widget.orderModel!.totalTaxAmount!.toString())}',
                                                style: rubikMedium.copyWith(
                                                    color:
                                                    ColorResources.getTextColor(
                                                        context),
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_LARGE)),
                                          ]),

                                      SizedBox(height: 10),
                                    ],) ,


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
                                                '(-) ${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(context, widget.orderModel!.couponDiscountAmount)}',
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
                                            '(+) ${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(context, deliveryCharge)}',
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
                                  ),
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
                                                    .SCAFFOLD_COLOR)),
                                        Text(
                                            '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(
                                                context, _total)}',
                                            style: rubikMedium.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: ColorResources
                                                    .SCAFFOLD_COLOR)),
                                      ]),
                                  SizedBox(height: 10),

                                  Divider(
                                    thickness: 1,
                                  ),
                                  SizedBox(height: 10),

                                  (widget.orderModel!.orderNote != null &&
                                          widget.orderModel!.orderNote!
                                              .isNotEmpty)
                                      ? Container(
                                          width: MediaQuery.of(context).size.width,
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
                                                        .SCAFFOLD_COLOR)),
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
                                                        .SCAFFOLD_COLOR,
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_LARGE,
                                                  )),
                                        ),
                                      ))
                                    : SizedBox(),

                                /*
                    (order.trackModel.paymentStatus == 'unpaid' && order.trackModel.paymentMethod != 'cash_on_delivery' && order.trackModel.orderStatus
                        != 'delivered') ? Expanded(child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      child: CustomButton(
                        text: getTranslated('pay_now', context),
                        onTap: () async {
                          if(ResponsiveHelper.isWeb()) {
                            String hostname = html.window.location.hostname;
                            String selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?order_id=${order.trackModel.id}&&customer_id=${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id}'
                                '&&callback=http://$hostname${Routes.ORDER_SUCCESS_SCREEN}/${order.trackModel.id}';
                            html.window.open(selectedUrl, "_self");
                          }else {
                            Navigator.pushReplacementNamed(context, Routes.getPaymentRoute('order', order.trackModel.id.toString(), order.trackModel.userId));
                          }
                        },
                      ),
                    )) : SizedBox(),*/
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
                                    color: ColorResources.SCAFFOLD_COLOR),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                  getTranslated('order_cancelled', context),
                                  style: rubikBold.copyWith(
                                      color: ColorResources.SCAFFOLD_COLOR)),
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

                                  // Navigator.pushNamed(
                                  //     context,
                                  //     Routes.getOrderTrackingRoute(
                                  //         order.trackModel!.id!));
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
                                  Navigator.pushNamed(
                                      context, Routes.getRateReviewRoute(),
                                      arguments: RateReviewScreen(
                                        orderDetailsList: order.orderDetails!,
                                        // deliveryMan: order.trackModel!.deliveryMan!,
                                      ));
                                },
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          ColorResources.SCAFFOLD_COLOR)));
        },
      ),
    );
  }
}
