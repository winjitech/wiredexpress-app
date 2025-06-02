import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:wired_express/data/model/body/place_order_body.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/payment_provider.dart';
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
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:wired_express/view/screens/payment/payment_webview.dart';
import 'package:wired_express/view/screens/payment/update_card_screen.dart';
import 'package:wired_express/view/screens/payment/widget/remove_card_bottom_sheet.dart';

class CheckoutScreen extends StatefulWidget {
  final PlaceOrderBody? orderBody;

  const CheckoutScreen({super.key, this.orderBody});

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

  bool? _isLoggedIn;

  bool _isCashActive = true;

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
        Provider.of<PaymentProvider>(context, listen: false).getPaymentCardList(
            context,
            Provider.of<ProfileProvider>(context, listen: false)
                .userInfoModel!
                .id!);
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      key: _scaffoldKey,
      appBar: CustomAppBar(title: getTranslated('checkout', context)),
      body: _isLoggedIn!
          ? Consumer4<OrderProvider, CartProvider, ProfileProvider,
              PaymentProvider>(
              builder: (context, orderProvider, cartProvider, profileProvider,
                  paymentProvider, child) {
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
                                              ' (${getTranslated('optional', context).toLowerCase()})',
                                              style: rubikMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE,
                                                  color: ColorResources
                                                          .getHintColor(context)
                                                      .withOpacity(0.6)),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        CustomTextField(
                                            fillColor: ColorResources
                                                .getTextFieldFillColor(context),
                                            controller: _noteController,
                                            hintText: getTranslated(
                                                'additional_note', context),
                                            maxLines: 5,
                                            inputType: TextInputType.multiline,
                                            inputAction:
                                                TextInputAction.newline,
                                            capitalization:
                                                TextCapitalization.sentences),
                                        SizedBox(height: 20),
                                        if (profileProvider.userInfoModel!
                                                .scheduledDelivery ==
                                            1)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  getTranslated(
                                                      'delivery_type', context),
                                                  style: rubikMedium.copyWith(
                                                      color: ColorResources
                                                          .getTextColor(
                                                              context),
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_LARGE)),
                                              SizedBox(height: 15),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child:
                                                          _buildSchedulingOption(
                                                              context: context,
                                                              orderProvider:
                                                                  orderProvider,
                                                              value: 0,
                                                              textKey:
                                                                  'same_day')),
                                                  const SizedBox(width: 15),
                                                  Expanded(
                                                      child:
                                                          _buildSchedulingOption(
                                                              context: context,
                                                              orderProvider:
                                                                  orderProvider,
                                                              value: 1,
                                                              textKey:
                                                                  'schedule'))
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
                                                                    .withOpacity(
                                                                        0.9),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 16))
                                                      ],
                                                    ),
                                                    SizedBox(height: 15),
                                                    GestureDetector(
                                                      onTap: () => DateConverter
                                                          .deliveryDateTime(
                                                              context,
                                                              orderProvider),
                                                      child: Container(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 10,
                                                              vertical: 15),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              border: Border.all(
                                                                  color: ColorResources
                                                                      .getBorderColor(
                                                                          context),
                                                                  width: 0.5)),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .date_range,
                                                                color: ColorResources
                                                                        .getTextColor(
                                                                            context)
                                                                    .withOpacity(
                                                                        0.6),
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
                                                                    color: orderProvider.selectedDeliveryDate ==
                                                                            null
                                                                        ? ColorResources.getTextColor(context).withOpacity(
                                                                            0.6)
                                                                        : ColorResources.getTextColor(
                                                                            context),
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )),
                                                            ],
                                                          )),
                                                    ),
                                                    SizedBox(height: 20),
                                                  ],
                                                ),
                                              SizedBox(height: 20),
                                            ],
                                          ),
                                        paymentProvider.loading! ||
                                                paymentProvider
                                                        .paymentCardList ==
                                                    null
                                            ? const Center(
                                                child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CustomCircularIndicator()),
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15,
                                                            left: 16,
                                                            right: 16),
                                                    child: Text(
                                                      getTranslated(
                                                          'payment_info',
                                                          context),
                                                      style:
                                                          rubikMedium.copyWith(
                                                        color: ColorResources
                                                            .getTextColor(
                                                                context),
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_LARGE,
                                                      ),
                                                    ),
                                                  ),
                                                  paymentProvider
                                                          .paymentCardList!
                                                          .isEmpty
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 16,
                                                                  right: 16,
                                                                  top: 10),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              paymentProvider
                                                                  .cardUpdateLink(
                                                                      context)
                                                                  .then(
                                                                      (value) {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (_) =>
                                                                                UpdateCardSreen()));
                                                              });
                                                            },
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.35,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border:
                                                                    Border.all(
                                                                  color: ColorResources
                                                                          .getTextColor(
                                                                              context)
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10.0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                        getTranslated(
                                                                            'add_card_info',
                                                                            context),
                                                                        style: TextStyle(
                                                                            color:
                                                                                ColorResources.getTextColor(context))),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    Icon(
                                                                        Icons
                                                                            .add,
                                                                        color: ColorResources.getTextColor(context)
                                                                            .withOpacity(0.5)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  paymentProvider
                                                          .paymentCardList!
                                                          .isEmpty
                                                      ? const SizedBox()
                                                      : Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 16,
                                                                      right: 16,
                                                                      top: 16,
                                                                      bottom:
                                                                          8),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              ColorResources.getTextColor(context).withOpacity(0.5),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            14),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(Icons.credit_card,
                                                                                color: ColorResources.getTextColor(context)),
                                                                            const SizedBox(width: 30),
                                                                            Text(
                                                                              '**** **** **** ${paymentProvider.paymentCardList![0].last4}',
                                                                              style: TextStyle(color: ColorResources.getTextColor(context)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () =>
                                                                            showModalBottomSheet(
                                                                          context:
                                                                              context,
                                                                          builder: (BuildContext context) =>
                                                                              RemoveCardBottomSheet(cardId: paymentProvider.paymentCardList![0].id!),
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          isScrollControlled:
                                                                              true,
                                                                          barrierColor:
                                                                              Colors.black54,
                                                                          isDismissible:
                                                                              true,
                                                                          useSafeArea:
                                                                              true,
                                                                        ),
                                                                        child:
                                                                            const Padding(
                                                                          padding:
                                                                              EdgeInsets.all(5),
                                                                          child: Icon(
                                                                              Icons.delete,
                                                                              color: Colors.red),
                                                                        ),
                                                                      ),
                                                                      paymentProvider
                                                                              .loading!
                                                                          ? const SizedBox(
                                                                              height: 20,
                                                                              width: 20,
                                                                              child: CustomCircularIndicator(color: Colors.white),
                                                                            )
                                                                          : GestureDetector(
                                                                              onTap: () => paymentProvider.cardUpdateLink(context).then((value) {
                                                                                Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateCardSreen()));
                                                                              }),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(5),
                                                                                child: Icon(Icons.edit, color: ColorResources.getTextColor(context).withOpacity(0.5)),
                                                                              ),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
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
                                        } else if (paymentProvider
                                            .paymentCardList!.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'please_add_your_card_details',
                                                  context),
                                              context);
                                        } else {
                                          PlaceOrderBody placeOrder =
                                              PlaceOrderBody(
                                                  cart: widget.orderBody!.cart!,
                                                  couponDiscountAmount: widget
                                                      .orderBody!
                                                      .couponDiscountAmount!,
                                                  usePointsDiscountAmount: widget
                                                      .orderBody!
                                                      .usePointsDiscountAmount!,
                                                  couponDiscountTitle: '',
                                                  couponCode: widget
                                                      .orderBody!.couponCode!,
                                                  totalTaxAmount: widget
                                                      .orderBody!
                                                      .totalTaxAmount!,
                                                  orderAmount: widget
                                                      .orderBody!.orderAmount!,
                                                  deliveryAddressId: widget
                                                      .orderBody!
                                                      .deliveryAddressId!,
                                                  orderType: widget
                                                      .orderBody!.orderType!,
                                                  // paymentMethod: _isCashActive
                                                  //     ? 'cash_on_delivery'
                                                  //     : 'credit_card',
                                                  paymentMethod: 'credit_card',
                                                  orderNote:
                                                      _noteController.text ??
                                                          '',
                                                  deliveryDateTime: profileProvider
                                                              .userInfoModel!
                                                              .scheduledDelivery ==
                                                          1
                                                      ? orderProvider.selectedScheduledValue ==
                                                              1
                                                          ? orderProvider
                                                              .selectedDeliveryDate
                                                              .toString()
                                                          : ''
                                                      : '',
                                                  usePoints: widget
                                                      .orderBody!.usePoints!,
                                                  remainingUserPoints: widget
                                                      .orderBody!
                                                      .remainingUserPoints!,
                                                  deliveryCharge: widget.orderBody!.deliveryCharge!,
                                                  priorityDelivery: profileProvider.userInfoModel!.priorityBulkOrderFulfillment ?? 0,
                                                  cardId: paymentProvider.paymentCardList != null && paymentProvider.paymentCardList!.isNotEmpty ? paymentProvider.paymentCardList![0].id! : "");

                                          log("placeOrder == ${placeOrder.toJson()}");
                                          orderProvider.placeOrder(
                                              placeOrder, _callback);
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
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  DashboardScreen(pageIndex: 2)));
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (BuildContext context) => PaymentWebView(
      //               url: '${AppConstants.baseUrl}/paypal/create/${orderID}',
      //               fromCheckoutScreen: true,
      //             )));
    } else {
      showCustomSnackBar(
          getTranslated('something_went_wrong', context), context);
    }
  }
}
