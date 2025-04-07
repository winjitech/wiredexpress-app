import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/coupon_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/address_bottom_sheet.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_main_appbar.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/base/no_data_screen.dart';
import 'package:wired_express/view/base/not_logged_in_screen.dart';
import 'package:wired_express/view/screens/cart/widget/cart_product_widget.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/screens/checkout/checkout_screen.dart';
import 'package:wired_express/view/screens/drawer/drawer_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final advancedDrawerController = AdvancedDrawerController();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 0), () {
      final bool _isLoggedIn =
          Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
      if (_isLoggedIn) {
        String? id = Provider.of<CustomAuthProvider>(context, listen: false)
            .getUserAddressId();
        print("--------------${id}");
        if (id != null) {
          final locationProvider =
              Provider.of<LocationProvider>(context, listen: false);
          int addressIndex = locationProvider.addressList
                  ?.indexWhere((address) => address.id.toString() == id) ??
              -1;
          if (addressIndex >= 0) {
            Provider.of<OrderProvider>(context, listen: false)
                .setAddressIndex(addressIndex);
          }
        } else {
          final locationProvider =
              Provider.of<LocationProvider>(context, listen: false);
          locationProvider.initAddressList(context);
          locationProvider.addressList;
          if ((locationProvider.addressList == null ||
              locationProvider.addressList!.length == 0 ||
              Provider.of<OrderProvider>(context, listen: false).addressIndex <
                  0)) {
            Provider.of<OrderProvider>(context, listen: false)
                .setAddressIndex(0);
          }
        }
        Provider.of<CartProvider>(context, listen: false).initCartList(context);
        Provider.of<LocationProvider>(context, listen: false)
            .initAddressList(context);
        ('cart' != 'take_away' &&
                (Provider.of<LocationProvider>(context, listen: false).addressList ==
                        null ||
                    Provider.of<LocationProvider>(context, listen: false)
                            .addressList!
                            .length ==
                        0 ||
                    Provider.of<OrderProvider>(context, listen: false).addressIndex <
                        0))
            ? Provider.of<LocationProvider>(context, listen: false).getZone(
                context,
                Provider.of<LocationProvider>(context, listen: false)
                    .addressList![0]
                    .latitude
                    .toString(),
                Provider.of<LocationProvider>(context, listen: false)
                    .addressList![0]
                    .longitude
                    .toString())
            : Provider.of<LocationProvider>(context, listen: false).getZone(
                context,
                Provider.of<LocationProvider>(context, listen: false)
                    .addressList![Provider.of<OrderProvider>(context, listen: false)
                        .addressIndex]
                    .latitude
                    .toString(),
                Provider.of<LocationProvider>(context, listen: false)
                    .addressList![Provider.of<OrderProvider>(context, listen: false).addressIndex]
                    .longitude
                    .toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false)
        .setOrderType('delivery', notify: false);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final TextEditingController _couponController = TextEditingController();
    final bool _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    return AdvancedDrawer(
      rtlOpening: false,
      openRatio: 0.55,
      openScale: 0.80,
      backdrop: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: IconButton(
            onPressed: () {
              closeDrawer();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 36,
            )),
      )),
      childDecoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
      controller: advancedDrawerController,
      animationCurve: Curves.easeInOutExpo,
      animationDuration: const Duration(milliseconds: 400),
      backdropColor: ColorResources.getScaffoldColor(context),
      drawer: DrawerScreen(),
      child: Scaffold(
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
        key: _scaffoldKey,
        appBar: CustomMainAppBar(
          onMenuPressed: () => showDrawer(),
          title: getTranslated('shopping_cart', context),
        ),
        body: _isLoggedIn
            ? Padding(
                padding: const EdgeInsets.all(5),
                child: Consumer2<CartProvider, LocationProvider>(
                  builder: (context, cartProvider, locationProvider, child) {
                    double _finalPrice = 0;
                    double _totalPrice = 0;
                    double _totalDiscount = 0;
                    double _totalTax = 0;
                    cartProvider.cartList.forEach((cart) {
                      List<TiredPricingModel> tiredPricing =
                          cart.product!.tiredPricing ?? [];

                      double priceWithDiscount =
                          PriceConverter.convertWithDiscount(
                              context,
                              cart.product!.price!,
                              cart.product!.discount!,
                              cart.product!.discountType!);
                      double price = PriceConverter.getProductFinalPrice(
                              tiredPricing,
                              priceWithDiscount,
                              cart.quantity ?? 1) ??
                          0.0;
                      print("pricepricepriceprice == $price");
                      double priceWithQuantity = price * cart.quantity!;

                      double discountAmount = 0;
                      double taxAmount = double.parse(Helpers.formatTextWithNum(
                          PriceConverter.convertPercentageToAmount(
                                  priceWithQuantity, cart.product!.tax!)
                              .toString()));
                      // if (cart.product!.discountType == 'amount') {
                      //   discountAmount = cart.product!.discount!;
                      // } else {
                      //   discountAmount =
                      //       (cart.product!.price! * cart.product!.discount!) /
                      //           100;
                      // }

                      _totalPrice = _totalPrice + priceWithQuantity;
                      _totalDiscount =
                          _totalDiscount + (discountAmount * cart.quantity!);
                      _totalTax = _totalTax + (taxAmount * cart.quantity!);
                    });

                    double deliveryCharge = locationProvider.deliveryFee;

                    _finalPrice = _totalPrice -
                        _totalDiscount -
                        Provider.of<CouponProvider>(context).discount! +
                        deliveryCharge +
                        _totalTax;

                    double _priceWithDiscount = _totalPrice - _totalDiscount;

                    double _couponDiscountAmount = 0;
                    if (Provider.of<CouponProvider>(context).coupon != null) {
                      _couponDiscountAmount = Helpers.applyDiscount(
                          Provider.of<CouponProvider>(context).coupon!,
                          (_totalPrice - _totalDiscount));
                    }

                    return cartProvider.cartList.isNotEmpty
                        ? Column(
                            children: [
                              Expanded(
                                child: Scrollbar(
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    physics: const BouncingScrollPhysics(),
                                    child: Center(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // const StatusCartWidget(
                                              //   cart: true,
                                              // ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: cartProvider
                                                    .cartList.length,
                                                itemBuilder: (context, index) {
                                                  return CartProductWidget(
                                                      cart: cartProvider
                                                          .cartList[index],
                                                      cartIndex: index,
                                                      isAvailable: true);
                                                },
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: ColorResources
                                                        .getScaffoldBackgroundColor(
                                                            context),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Provider.of<
                                                                          ThemeProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .darkTheme
                                                              ? Colors.black
                                                                  .withOpacity(
                                                                      0.4)
                                                              : Colors
                                                                  .grey[300]!,
                                                          blurRadius: 2,
                                                          spreadRadius: 1)
                                                    ]),
                                                height: 50,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return const AddressBottomSheet();
                                                      },
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(
                                                      children: [
                                                        ("cart" != 'take_away' &&
                                                                (locationProvider
                                                                            .addressList ==
                                                                        null ||
                                                                    locationProvider
                                                                            .addressList!
                                                                            .length ==
                                                                        0 ||
                                                                    Provider.of<OrderProvider>(context,
                                                                                listen: false)
                                                                            .addressIndex <
                                                                        0))
                                                            ? Text(
                                                                'Select Delivery Location',
                                                                style: TextStyle(
                                                                    color: Provider.of<ThemeProvider>(context,
                                                                                listen:
                                                                                    false)
                                                                            .darkTheme
                                                                        ? Colors
                                                                            .white54
                                                                        : ColorResources
                                                                            .getScaffoldColor(context),
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )
                                                            : Text(
                                                                'Change Delivery Location',
                                                                style: TextStyle(
                                                                    color: Provider.of<ThemeProvider>(context,
                                                                                listen:
                                                                                    false)
                                                                            .darkTheme
                                                                        ? Colors
                                                                            .white54
                                                                        : ColorResources
                                                                            .getScaffoldColor(context),
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                        const Spacer(),
                                                        ("cart" != 'take_away' &&
                                                                (locationProvider
                                                                            .addressList ==
                                                                        null ||
                                                                    locationProvider
                                                                            .addressList!
                                                                            .length ==
                                                                        0 ||
                                                                    Provider.of<OrderProvider>(context,
                                                                                listen: false)
                                                                            .addressIndex <
                                                                        0))
                                                            ?  Icon(
                                                                Icons
                                                                    .not_listed_location_outlined,
                                                                color: ColorResources
                                                                    .getScaffoldColor(context),
                                                              )
                                                            :  Icon(
                                                                Icons
                                                                    .published_with_changes_sharp,
                                                                color: ColorResources
                                                                    .getScaffoldColor(context),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    getTranslated(
                                                        'promo_code', context),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 20),
                                                  )),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              // Coupon
                                              Consumer<CouponProvider>(
                                                builder:
                                                    (context, coupon, child) {
                                                  return Row(
                                                    children: [
                                                      Expanded(
                                                        child: CustomTextField(
                                                          hintText: getTranslated(
                                                              'enter_promo_code',
                                                              context),
                                                          controller:
                                                              _couponController,
                                                          inputType:
                                                              TextInputType
                                                                  .text,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      MaterialButton(
                                                        height: 50,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40)),
                                                        onPressed: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          if (_couponController
                                                                  .text
                                                                  .isNotEmpty &&
                                                              !coupon
                                                                  .isLoading!) {
                                                            print(
                                                                'couponDiscountAmount 1=> ${_couponDiscountAmount}');
                                                            if (_couponDiscountAmount <
                                                                1) {
                                                              print(
                                                                  'couponDiscountAmount 2=> ${_couponDiscountAmount}');
                                                              coupon
                                                                  .applyCoupon(
                                                                      _couponController
                                                                          .text,
                                                                      _priceWithDiscount)
                                                                  .then(
                                                                      (discount) {
                                                                if (discount >
                                                                    0) {
                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                      content: Text(
                                                                          'You got ${getTranslated('description', context) == "Description" ? '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}' : '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}'}$discount discount'),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .green));
                                                                } else {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(getTranslated(
                                                                        'invalid_code_or',
                                                                        context)),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ));
                                                                }
                                                              });
                                                            } else {
                                                              print(
                                                                  'couponDiscountAmount 3=> ${_couponDiscountAmount}');
                                                              coupon
                                                                  .removeCouponData(
                                                                      true);
                                                            }
                                                          } else if (_couponController
                                                              .text.isEmpty) {
                                                            showCustomSnackBar(
                                                                getTranslated(
                                                                    'enter_a_Coupon_code',
                                                                    context),
                                                                context);
                                                          }
                                                        },
                                                        color: ColorResources
                                                            .getScaffoldColor(context),
                                                        child: coupon
                                                                    .discount! <=
                                                                0
                                                            ? !coupon.isLoading!
                                                                ? Text(
                                                                    getTranslated(
                                                                        'enter',
                                                                        context),
                                                                    style: rubikMedium.copyWith(
                                                                        color: Colors
                                                                            .white))
                                                                : CustomCircularIndicator(
                                                                    color: Colors
                                                                        .white)
                                                            : const Icon(
                                                                Icons.clear,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),

                                              const SizedBox(height: 40),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        getTranslated(
                                                            'items_price',
                                                            context),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        )),
                                                    Text(
                                                        '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${Helpers.formatTextWithNum(_totalPrice.toString())}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        )),
                                                  ]),

                                              const SizedBox(height: 10),

                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        getTranslated(
                                                            'tax', context),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        )),
                                                    Text(
                                                        '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${Helpers.formatTextWithNum(_totalTax.toString())}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        )),
                                                  ]),

                                              const SizedBox(height: 10),

                                              if (_couponDiscountAmount != 0.0)
                                                Column(
                                                  children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              getTranslated(
                                                                  'coupon_discount',
                                                                  context),
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              )),
                                                          Text(
                                                              '(-)  ${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${Helpers.formatTextWithNum(_couponDiscountAmount.toString())}',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              )),
                                                        ]),
                                                    const SizedBox(height: 10),
                                                  ],
                                                ),

                                              if (_totalDiscount != 0.0)
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            '${getTranslated('your_sale', context)}',
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            )),
                                                        Text(
                                                            '(-) ${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${Helpers.formatTextWithNum(_totalDiscount.toString())}',
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            ))
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                  ],
                                                ),
                                              // if (deliveryCharge != 0.0)
                                              Column(
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            getTranslated(
                                                                'delivery_fee',
                                                                context),
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            )),
                                                        Text(
                                                            '(+) ${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${deliveryCharge}',
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            )),
                                                      ]),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),

                                              const Divider(
                                                thickness: 1,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        '${getTranslated('total_price', context)}:',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        )),
                                                    Text(
                                                        '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${Helpers.formatTextWithNum(_finalPrice.toString())}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ))
                                                  ]),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                child: CustomButton(
                                  text: getTranslated('place_order', context),
                                  onTap: () {
                                    var orderProvider =
                                        Provider.of<OrderProvider>(context,
                                            listen: false);
                                    var locationProvider =
                                        Provider.of<LocationProvider>(context,
                                            listen: false);

                                    if (locationProvider.addressList!.isEmpty) {
                                      showCustomSnackBar(
                                        getTranslated(
                                            'select_address_required', context),
                                        context,
                                      );
                                    } else if (orderProvider.addressIndex ==
                                            -1 ||
                                        locationProvider
                                                .addressList![
                                                    orderProvider.addressIndex]
                                                .id ==
                                            null) {
                                      showCustomSnackBar(
                                        getTranslated(
                                            'select_address_required', context),
                                        context,
                                      );
                                    } else {
                                      Provider.of<PlaceOrderProvider>(context,
                                              listen: false)
                                          .orderDetails(
                                        amount: _finalPrice,
                                        orderType: 'cart',
                                        fromCart: true,
                                        cartList: cartProvider.cartList,
                                        deliveryId: locationProvider
                                            .addressList![
                                                orderProvider.addressIndex]
                                            .id!,
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                CheckoutScreen(
                                                  amount: _finalPrice,
                                                  orderType: 'cart',
                                                  fromCart: true,
                                                  cartList:
                                                      cartProvider.cartList,
                                                  deliveryAddressId:
                                                      locationProvider
                                                          .addressList![
                                                              orderProvider
                                                                  .addressIndex]
                                                          .id!,
                                                  totalTax: _totalTax,
                                                )),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        : NoDataScreen(isCart: true);
                  },
                ),
              )
            : NotLoggedInScreen(),
      ),
    );
  }

  void showDrawer() {
    if (mounted) {
      advancedDrawerController.showDrawer();
    }
  }

  void closeDrawer() {
    if (mounted) {
      advancedDrawerController.hideDrawer();
    }
  }
}
