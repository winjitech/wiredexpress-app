import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wired_express/data/model/body/place_order_body.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/coupon_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/base/not_logged_in_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/screens/payment/payment_success_screen.dart';
import 'package:wired_express/view/screens/payment/payment_webview.dart';

class CheckoutScreen extends StatefulWidget {
  final double? amount;
  final String? orderType;
  final List<CartModel>? cartList;
  final bool? fromCart;
  final int? deliveryAddressId;
  final double? totalTax;
  final double? vatTaxPercentage;

  CheckoutScreen({
    @required this.amount,
    @required this.orderType,
    @required this.fromCart,
    @required this.cartList,
    @required this.deliveryAddressId,
    @required this.totalTax,
    this.vatTaxPercentage,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _noteController = TextEditingController();
  GoogleMapController? _mapController;
  bool? _isCashOnDeliveryActive;
  bool? _isDigitalPaymentActive;

  bool _loading = true;
  Set<Marker> _markers = HashSet<Marker>();
  bool? _isLoggedIn;
  List<CartModel>? _cartList;

  bool _isCashActive = true;
  bool _isDigitalActive = false;

  @override
  void initState() {
    super.initState();
    _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    Timer(Duration(seconds: 0), () async {
      orderProvider.clearSelectScheduledValue();
      if (_isLoggedIn!) {
        if (Provider.of<ProfileProvider>(context, listen: false)
                .userInfoModel ==
            null) {
          Provider.of<ProfileProvider>(context, listen: false)
              .getUserInfo(context);
        }
        Provider.of<LocationProvider>(context, listen: false)
            .initAddressList(context);
        orderProvider.clearPrevData();
        _isCashOnDeliveryActive =
            Provider.of<SplashProvider>(context, listen: false)
                    .configModel!
                    .cashOnDelivery ==
                'true';
        _isDigitalPaymentActive =
            Provider.of<SplashProvider>(context, listen: false)
                    .configModel!
                    .digitalPayment ==
                'true';
        _cartList = [];
        widget.fromCart!
            ? _cartList!.addAll(
                Provider.of<CartProvider>(context, listen: false).cartList)
            : _cartList!.addAll(widget.cartList!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      key: _scaffoldKey,
      appBar: CustomAppBar(title: getTranslated('checkout', context)),
      body: _isLoggedIn!
          ? Consumer2<OrderProvider, CartProvider>(
              builder: (context, orderProvider, cartProvider, child) {
                return Consumer<LocationProvider>(
                  builder: (context, address, child) {
                    return Column(
                      children: [
                        Expanded(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(25),
                              physics: BouncingScrollPhysics(),
                              child: Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Padding(
                                        //   padding: const EdgeInsets.all(15.0),
                                        //   child: Row(
                                        //     children: [
                                        //       Text('Add Note ',
                                        //           style: rubikMedium.copyWith(
                                        //               color: ColorResources
                                        //                   .getTextColor(
                                        //                       context),
                                        //               fontSize: Dimensions
                                        //                   .FONT_SIZE_LARGE)),
                                        //       Text(
                                        //         '(${getTranslated('optional', context).toLowerCase()})',
                                        //         style: rubikMedium.copyWith(
                                        //             fontSize: Dimensions
                                        //                 .FONT_SIZE_LARGE,
                                        //             color: ColorResources
                                        //                 .getHintColor(context)),
                                        //       )
                                        //     ],
                                        //   ),
                                        // ),
                                        // // Address
                                        // widget.orderType != 'take_away'
                                        //     ? Column(children: [
                                        //   Padding(
                                        //     padding: EdgeInsets.symmetric(
                                        //         horizontal: Dimensions
                                        //             .PADDING_SIZE_SMALL),
                                        //     child: Row(children: [
                                        //       Text(
                                        //           getTranslated(
                                        //               'delivery_address',
                                        //               context),
                                        //           style: rubikMedium.copyWith(
                                        //               fontSize: Dimensions
                                        //                   .FONT_SIZE_LARGE)),
                                        //       Expanded(child: SizedBox()),
                                        //       TextButton.icon(
                                        //         onPressed: () {
                                        //           Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>
                                        //               AddressScreen()));
                                        //
                                        //           // Navigator.pushNamed(
                                        //           //     context,
                                        //           //     Routes
                                        //           //         .getAddAddressRoute(
                                        //           //         'checkout',
                                        //           //         'add',
                                        //           //         '',
                                        //           //         '',
                                        //           //         '',
                                        //           //         '',
                                        //           //         '',
                                        //           //         '',
                                        //           //         0,
                                        //           //         0));
                                        //         },
                                        //         icon: Icon(Icons.add),
                                        //         label: Text(
                                        //             getTranslated(
                                        //                 'add', context),
                                        //             style: rubikRegular),
                                        //       ),
                                        //     ]),
                                        //   ),
                                        //   SizedBox(
                                        //     height: 60,
                                        //     child: address.addressList !=
                                        //         null
                                        //         ? address.addressList!
                                        //         .length >
                                        //         0
                                        //         ? ListView.builder(
                                        //       physics:
                                        //       BouncingScrollPhysics(),
                                        //       scrollDirection:
                                        //       Axis.horizontal,
                                        //       padding: EdgeInsets.only(
                                        //           left: Dimensions
                                        //               .PADDING_SIZE_SMALL),
                                        //       itemCount: address
                                        //           .addressList
                                        //           !.length,
                                        //       itemBuilder:
                                        //           (context,
                                        //           index) {
                                        //         return Padding(
                                        //           padding: EdgeInsets.only(
                                        //               right: Dimensions
                                        //                   .PADDING_SIZE_LARGE),
                                        //           child:
                                        //           GestureDetector(
                                        //             onTap: () {
                                        //               order.setAddressIndex(
                                        //                   index);
                                        //             },
                                        //             child: Stack(
                                        //                 children: [
                                        //                   Container(
                                        //                     height:
                                        //                     60,
                                        //                     width:
                                        //                     200,
                                        //                     decoration:
                                        //                     BoxDecoration(
                                        //                       color: index == order.addressIndex ? Colors.white : ColorResources.getBackgroundColor(context),
                                        //                       borderRadius: BorderRadius.circular(10),
                                        //                       border: index == order.addressIndex ? Border.all(color: Theme.of(context).primaryColor, width: 2) : null,
                                        //                     ),
                                        //                     child:
                                        //                     Row(children: [
                                        //                       Padding(
                                        //                         padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        //                         child: Icon(
                                        //                           address.addressList![index].addressType == 'Home'
                                        //                               ? Icons.home_outlined
                                        //                               : address.addressList![index].addressType == 'Workplace'
                                        //                               ? Icons.work_outline
                                        //                               : Icons.list_alt_outlined,
                                        //                           color: index == order.addressIndex ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyText1!.color,
                                        //                           size: 30,
                                        //                         ),
                                        //                       ),
                                        //                       Expanded(
                                        //                         child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                        //                           Text(address.addressList![index].addressType!,
                                        //                               style: rubikRegular.copyWith(
                                        //                                 fontSize: Dimensions.FONT_SIZE_SMALL,
                                        //                                 color: ColorResources.getGreyBunkerColor(context),
                                        //                               )),
                                        //                           Text(address.addressList![index].address!, style: rubikRegular, maxLines: 1, overflow: TextOverflow.ellipsis),
                                        //                         ]),
                                        //                       ),
                                        //                       index == order.addressIndex
                                        //                           ? Align(
                                        //                         alignment: Alignment.topRight,
                                        //                         child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                                        //                       )
                                        //                           : SizedBox(),
                                        //                     ]),
                                        //                   ),
                                        //
                                        //                 ]),
                                        //           ),
                                        //         );
                                        //       },
                                        //     )
                                        //         : Center(
                                        //         child: Text(
                                        //             getTranslated(
                                        //                 'no_address_available',
                                        //                 context)))
                                        //         : CustomCircularIndicator(),
                                        //   ),
                                        //   SizedBox(height: 20),
                                        // ])
                                        //     : SizedBox(),

                                        // Padding(
                                        //   padding: EdgeInsets.symmetric(
                                        //       horizontal: Dimensions
                                        //           .PADDING_SIZE_SMALL),
                                        //   child: Text(
                                        //       getTranslated(
                                        //           'payment_method', context),
                                        //       style: rubikMedium.copyWith(
                                        //           fontSize: Dimensions
                                        //               .FONT_SIZE_LARGE)),
                                        // ),
                                        //
                                        // Row(
                                        //   children: [
                                        //     Checkbox(
                                        //       fillColor:  MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                                        //       value: _isCashActive,
                                        //       onChanged: (value) {
                                        //         setState(() {
                                        //           _isCashActive = true;
                                        //           _isDigitalActive = false;
                                        //         });
                                        //       },
                                        //     ),
                                        //     Text(getTranslated(
                                        //         'cash_on_delivery', context),
                                        //
                                        //     )
                                        //   ],
                                        // ),
                                        //
                                        //
                                        // Row(
                                        //   children: [
                                        //     Checkbox(
                                        //       fillColor:  MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                                        //       value: _isDigitalActive,
                                        //       onChanged: (value) {
                                        //         setState(() {
                                        //           _isCashActive = false;
                                        //           _isDigitalActive = true;
                                        //         });
                                        //       },
                                        //     ),
                                        //
                                        //     Text(getTranslated(
                                        //         'digital_payment', context),
                                        //
                                        //     )
                                        //   ],
                                        // ),
                                        //
                                        Row(
                                          children: [
                                            Text(
                                                getTranslated(
                                                    'additional_note', context),
                                                style: rubikMedium.copyWith(
                                                    color: ColorResources
                                                        .getTextColor(context),
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_LARGE)),
                                            Text(
                                              '(${getTranslated('optional', context).toLowerCase()})',
                                              style: rubikMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE,
                                                  color: ColorResources
                                                      .getHintColor(context)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomTextField(
                                          controller: _noteController,
                                          hintText: getTranslated(
                                              'additional_note', context),
                                          maxLines: 5,
                                          inputType: TextInputType.multiline,
                                          inputAction: TextInputAction.newline,
                                          capitalization:
                                              TextCapitalization.sentences,
                                        ),

                                        SizedBox(height: 20),
                                        Text(
                                            getTranslated(
                                                'delivery_type', context),
                                            style: rubikMedium.copyWith(
                                                color:
                                                    ColorResources.getTextColor(
                                                        context),
                                                fontSize: Dimensions
                                                    .FONT_SIZE_LARGE)),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: _buildSchedulingOption(
                                                    context: context,
                                                    orderProvider:
                                                        orderProvider,
                                                    value: 0,
                                                    textKey: 'same_day')),
                                            const SizedBox(width: 15),
                                            Expanded(
                                                child: _buildSchedulingOption(
                                                    context: context,
                                                    orderProvider:
                                                        orderProvider,
                                                    value: 1,
                                                    textKey: 'schedule'))
                                          ],
                                        ),
                                        if (orderProvider
                                                .selectedScheduledValue ==
                                            1)
                                          Column(
                                            children: [
                                              SizedBox(height: 20),
                                              Row(
                                                children: [
                                                  Text(
                                                    getTranslated(
                                                        'delivery_date',
                                                        context),
                                                    style: TextStyle(
                                                      color: ColorResources
                                                              .getTextColor(
                                                                  context)
                                                          .withOpacity(0.9),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15),
                                              GestureDetector(
                                                onTap: () => DateConverter
                                                    .deliveryDateTime(
                                                        context, orderProvider),
                                                child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 15),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        border: Border.all(
                                                            color: ColorResources
                                                                .getBorderColor(
                                                                    context),
                                                            width: 0.5)),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.date_range,
                                                          color: ColorResources
                                                                  .getTextColor(
                                                                      context)
                                                              .withOpacity(0.6),
                                                        ),
                                                        const SizedBox(
                                                            width: 15),
                                                        Expanded(
                                                            child: Text(
                                                          orderProvider
                                                                      .selectedDeliveryDate ==
                                                                  null
                                                              ? getTranslated(
                                                                  'select_date',
                                                                  context)
                                                              : DateConverter.formatDateTime(
                                                                  context,
                                                                  orderProvider
                                                                      .selectedDeliveryDate!
                                                                      .toString()),
                                                          style: TextStyle(
                                                              color: orderProvider
                                                                          .selectedDeliveryDate ==
                                                                      null
                                                                  ? ColorResources
                                                                          .getTextColor(
                                                                              context)
                                                                      .withOpacity(
                                                                          0.6)
                                                                  : ColorResources
                                                                      .getTextColor(
                                                                          context),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )),
                                                      ],
                                                    )),
                                              ),
                                              SizedBox(height: 20),
                                            ],
                                          )
                                      ]),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(
                              Dimensions.PADDING_SIZE_SMALL),
                          child: !orderProvider.isLoading
                              ? Builder(
                                  builder: (context) => CustomButton(
                                      text: getTranslated(
                                          'confirm_order', context),
                                      onTap: () {
                                        if (orderProvider
                                                    .selectedDeliveryDate ==
                                                null &&
                                            orderProvider
                                                    .selectedScheduledValue ==
                                                1) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'select_delivery_date_required',
                                                  context),
                                              context);
                                        } else {
                                          _cartList = cartProvider.cartList;
                                          List<ProductCart> carts = [];
                                          for (int index = 0;
                                              index < _cartList!.length;
                                              index++) {
                                            CartModel cart = _cartList![index];

                                            double price = cart.product!.price!;
                                            double discountAmount = 0;
                                            if (cart.product!.discountType ==
                                                'amount') {
                                              discountAmount =
                                                  cart.product!.discount!;
                                            } else {
                                              discountAmount = (cart
                                                          .product!.price! *
                                                      cart.product!.discount!) /
                                                  100;
                                            }

                                            carts.add(ProductCart(
                                                cart.product!.id.toString(),
                                                price.toString(),
                                                discountAmount,
                                                cart.quantity,
                                                cart.product!.tax,
                                                cart.tieredPricing));
                                          }
                                          PlaceOrderBody placeOrder = PlaceOrderBody(
                                              cart: carts,
                                              couponDiscountAmount:
                                                  Provider.of<CouponProvider>(context, listen: false)
                                                      .discount,
                                              couponDiscountTitle: '',
                                              deliveryAddressId:
                                                  widget.deliveryAddressId,
                                              orderAmount: widget.amount,
                                              orderNote:
                                                  _noteController.text ?? '',
                                              paymentMethod: _isCashActive
                                                  ? 'cash_on_delivery'
                                                  : 'credit_card',
                                              couponCode: Provider.of<CouponProvider>(context, listen: false).coupon != null
                                                  ? Provider.of<CouponProvider>(
                                                          context,
                                                          listen: false)
                                                      .coupon!
                                                      .code
                                                  : "",
                                              totalTaxAmount: widget.vatTaxPercentage
                                                  .toString(),
                                              orderType: 'cart',
                                              deliveryDateTime:
                                                  orderProvider.selectedScheduledValue == 1
                                                      ? orderProvider
                                                          .selectedDeliveryDate
                                                          .toString()
                                                      : null);

                                          print("placeOrder == ${placeOrder.toJson()}");
                                          orderProvider.placeOrder(placeOrder, _callback);
                                        }
                                      }),
                                )
                              : CustomCircularIndicator(),
                        ),
                        const SizedBox(height: 20)
                      ],
                    );
                  },
                );
              },
            )
          : NotLoggedInScreen(),
    );
  }

  Widget _buildSchedulingOption(
      {required BuildContext context,
      required OrderProvider orderProvider,
      required int value,
      required String textKey}) {
    return GestureDetector(
      onTap: () {
        orderProvider.setSelectScheduledValue(value);
        if (value == 1) {
          orderProvider.clearSelectDeliveryDate();
        }
      },
      child: Row(
        children: [
          Icon(
              orderProvider.selectedScheduledValue == value
                  ? Icons.check_circle_sharp
                  : Icons.circle_outlined,
              color: orderProvider.selectedScheduledValue == value
                  ? ColorResources.getSecondaryColor(context)
                  : ColorResources.getBorderColor(context)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(getTranslated(textKey, context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: orderProvider.selectedScheduledValue == value
                      ? ColorResources.getSecondaryColor(context)
                      : ColorResources.getTextColor(context).withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                )),
          ),
        ],
      ),
    );
  }

  void _callback(
      bool isSuccess, String message, String orderID, int addressID) async {
    if (isSuccess) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext? context) =>
                  PaymentSuccessScreen(success: true)));
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (BuildContext context) => PaymentWebView(
      //               url: '${AppConstants.BASE_URL}/paypal/create/${orderID}',
      //             )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  // void _callback(
  //     bool isSuccess, String message, String orderID, int addressID) async {
  //   if (isSuccess) {
  //     if (widget.fromCart!) {
  //       Provider.of<CartProvider>(context, listen: false).clearCartList();
  //     }
  //     Provider.of<OrderProvider>(context, listen: false).stopLoader();
  //     if (_isCashOnDeliveryActive! &&
  //         Provider.of<OrderProvider>(context, listen: false)
  //                 .paymentMethodIndex ==
  //             0) {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (_) => OrderSuccessfulScreen(
  //                     orderID: orderID,
  //                     status: 0,
  //                   )));
  //       // Navigator.pushReplacementNamed(
  //       //     context, '${Routes.ORDER_SUCCESS_SCREEN}/$orderID/success');
  //     } else {
  //       //  Navigator.pushReplacementNamed(context, Routes.getPaymentRoute('checkout', orderID,
  //       //    Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id));
  //
  //       // Navigator.pushReplacementNamed(
  //       //     context, '${Routes.ORDER_SUCCESS_SCREEN}/$orderID/success');
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (_) => OrderSuccessfulScreen(
  //                     orderID: orderID,
  //                     status: 0,
  //                   )));
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(message), backgroundColor: Colors.red));
  //   }
  // }

  // void _setMarkers(int selectedIndex) async {
  //   Uint8List activeImageData = await convertAssetToUnit8List(
  //       Images.store_marker,
  //       width: ResponsiveHelper.isMobilePhone() ? 70 : 20);
  //   Uint8List inactiveImageData = await convertAssetToUnit8List(
  //       Images.unselected_store_marker,
  //       width: ResponsiveHelper.isMobilePhone() ? 70 : 20);
  //
  //   // Marker
  //   _markers = HashSet<Marker>();
  //   for (int index = 0; index < _branches.length; index++) {
  //     _markers.add(Marker(
  //       markerId: MarkerId('branch_$index'),
  //       position: LatLng(double.parse(_branches[index].latitude),
  //           double.parse(_branches[index].longitude)),
  //       infoWindow: InfoWindow(
  //           title: _branches[index].name, snippet: _branches[index].address),
  //       icon: BitmapDescriptor.fromBytes(
  //         selectedIndex == index ? activeImageData : inactiveImageData,
  //       ),
  //     ));
  //   }
  //
  //   _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //       target: LatLng(
  //         double.parse(_branches[selectedIndex].latitude),
  //         double.parse(_branches[selectedIndex].longitude),
  //       ),
  //       zoom: ResponsiveHelper.isMobile(context) ? 18 : 8)));
  //
  //   setState(() {});
  // }

  Future<Uint8List> convertAssetToUnit8List(String imagePath,
      {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
