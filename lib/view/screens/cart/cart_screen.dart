import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:wired_express/data/helper/helpers.dart';
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
      final bool isLoggedIn =
          Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
      if (isLoggedIn) {
        int? id = Provider.of<CustomAuthProvider>(context, listen: false)
            .getUserAddressId();
        print("--------------$id");

        Provider.of<CartProvider>(context, listen: false).initCartList(context);
        Provider.of<LocationProvider>(context, listen: false)
            .initAddressList(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false)
        .setOrderType('delivery', notify: false);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final TextEditingController couponController = TextEditingController();
    final bool isLoggedIn =
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
        key: scaffoldKey,
        appBar: CustomMainAppBar(
          onMenuPressed: () => showDrawer(),
          title: getTranslated('shopping_cart', context),
        ),
        body: isLoggedIn
            ? Padding(
                padding: const EdgeInsets.all(5),
                child: Consumer4<CartProvider, LocationProvider, SplashProvider,
                    CustomAuthProvider>(
                  builder: (context, cartProvider, locationProvider,
                      splashProvider, authProvider, child) {
                    double finalPrice = 0;
                    double totalPrice = 0;
                    double totalDiscount = 0;
                    double totalTax = 0;
                    double totalTiredPricing = 0;
                    cartProvider.cartList.forEach((cart) {
                      TiredPricingModel? tiredPricing =
                          cart.tieredPricing ?? TiredPricingModel();
                      totalTiredPricing = totalTiredPricing +
                          (double.parse(tiredPricing.discountPrice ?? "0.0") *
                              cart.quantity!);
                      print("totalTiredPricing == $totalTiredPricing");

                      double priceWithDiscount =
                          PriceConverter.convertWithDiscount(
                              context,
                              cart.product!.price!,
                              cart.product!.discount!,
                              cart.product!.discountType!);
                      double price =
                          PriceConverter.getProductFinalPriceWithTieredPricing(
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

                      totalPrice = totalPrice + priceWithQuantity;
                      totalDiscount =
                          totalDiscount + (discountAmount * cart.quantity!);
                      totalTax = totalTax + (taxAmount * cart.quantity!);
                    });

                    double deliveryCharge = double.parse(
                        splashProvider.configModel!.deliveryCharge ?? "0.0");

                    finalPrice = totalPrice -
                        totalDiscount -
                        Provider.of<CouponProvider>(context).discount! +
                        deliveryCharge +
                        totalTax;

                    double priceWithDiscount0 = totalPrice - totalDiscount;

                    double couponDiscountAmount = 0;
                    if (Provider.of<CouponProvider>(context).coupon != null) {
                      couponDiscountAmount = Helpers.applyDiscount(
                          Provider.of<CouponProvider>(context).coupon!,
                          (totalPrice - totalDiscount));
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
                                                  onTap: () => showModalBottomSheet(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) => AddressBottomSheet(),
                                                    ),
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
                                                                    authProvider
                                                                            .getUserAddressId() ==
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
                                                                        : ColorResources.getScaffoldColor(
                                                                            context),
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
                                                                        : ColorResources.getScaffoldColor(
                                                                            context),
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
                                                                    authProvider
                                                                            .getUserAddressId() ==
                                                                        0))
                                                            ? Icon(
                                                                Icons
                                                                    .not_listed_location_outlined,
                                                                color: ColorResources
                                                                    .getScaffoldColor(
                                                                        context),
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .published_with_changes_sharp,
                                                                color: ColorResources
                                                                    .getScaffoldColor(
                                                                        context),
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
                                                              couponController,
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
                                                          if (couponController
                                                                  .text
                                                                  .isNotEmpty &&
                                                              !coupon
                                                                  .isLoading!) {
                                                            print(
                                                                'couponDiscountAmount 1=> ${couponDiscountAmount}');
                                                            if (couponDiscountAmount <
                                                                1) {
                                                              print(
                                                                  'couponDiscountAmount 2=> ${couponDiscountAmount}');
                                                              coupon
                                                                  .applyCoupon(
                                                                      couponController
                                                                          .text,
                                                                      priceWithDiscount0)
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
                                                                  'couponDiscountAmount 3=> ${couponDiscountAmount}');
                                                              coupon
                                                                  .removeCouponData(
                                                                      true);
                                                            }
                                                          } else if (couponController
                                                              .text.isEmpty) {
                                                            showCustomSnackBar(
                                                                getTranslated(
                                                                    'enter_a_Coupon_code',
                                                                    context),
                                                                context);
                                                          }
                                                        },
                                                        color: ColorResources
                                                            .getScaffoldColor(
                                                                context),
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
                                                        '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${Helpers.formatTextWithNum(totalPrice.toString())}',
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
                                                            'tiered_pricing_discount',
                                                            context),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 16,
                                                        )),
                                                    Text(
                                                        '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${Helpers.formatTextWithNum(totalTiredPricing.toString())}',
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
                                                        '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${Helpers.formatTextWithNum(totalTax.toString())}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        )),
                                                  ]),

                                              const SizedBox(height: 10),

                                              if (couponDiscountAmount != 0.0)
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
                                                              '(-)  ${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${Helpers.formatTextWithNum(couponDiscountAmount.toString())}',
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

                                              if (totalDiscount != 0.0)
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
                                                            '(-) ${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${Helpers.formatTextWithNum(totalDiscount.toString())}',
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
                                                        '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${Helpers.formatTextWithNum(finalPrice.toString())}',
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
                                    if (authProvider.getUserAddressId() == 0) {
                                      showCustomSnackBar(
                                        getTranslated(
                                            'select_address_required', context),
                                        context,
                                      );
                                    } else {
                                      Provider.of<PlaceOrderProvider>(context,
                                              listen: false)
                                          .orderDetails(
                                        amount: finalPrice,
                                        orderType: 'cart',
                                        fromCart: true,
                                        cartList: cartProvider.cartList,
                                        deliveryId:
                                            authProvider.getUserAddressId()!,
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                CheckoutScreen(
                                                  amount: finalPrice,
                                                  orderType: 'cart',
                                                  fromCart: true,
                                                  cartList:
                                                      cartProvider.cartList,
                                                  deliveryAddressId:
                                                      authProvider
                                                          .getUserAddressId(),
                                                  totalTax: totalTax,
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
