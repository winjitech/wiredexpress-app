import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
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
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
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
                                              totalTaxAmount: widget.vatTaxPercentage == null?
                                              "0.0":
                                              widget.vatTaxPercentage.toString(),
                                              orderType: 'cart',
                                              deliveryDateTime:
                                                  orderProvider.selectedScheduledValue == 1
                                                      ? orderProvider
                                                          .selectedDeliveryDate
                                                          .toString()
                                                      : null);

                                          print(
                                              "placeOrder == ${placeOrder.toJson()}");
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
}
