import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/body/place_order_body.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/coupon_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/utill/color_resources.dart';

import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_main_appbar.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/screens/cart/widget/cart_product_widget.dart';
import 'package:wired_express/view/screens/cart/widget/status_cart_widget.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:wired_express/view/screens/drawer/drawer_screen.dart';

class SubmitOrderScreen extends StatefulWidget {
  @override
  _SubmitOrderScreenState createState() => _SubmitOrderScreenState();
}

class _SubmitOrderScreenState extends State<SubmitOrderScreen> {
  final advancedDrawerController = AdvancedDrawerController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  List<CartModel>? _cartList;

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
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
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 36,
              )),
        )),
        childDecoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
        controller: advancedDrawerController,
        animationCurve: Curves.easeInOutExpo,
        animationDuration: Duration(milliseconds: 400),
        backdropColor: ColorResources.SCAFFOLD_COLOR,
        drawer: DrawerScreen(),
        child: Scaffold(
            backgroundColor:
                ColorResources.getScaffoldBackgroundColor(context!),
            key: _scaffoldKey,
            appBar: CustomMainAppBar(
              onMenuPressed: () => showDrawer(),
              title: getTranslated('submit_order', context),
            ),
            body: Consumer2<CartProvider, PlaceOrderProvider>(
                builder: (context, cartProvider, placeOrderProvider, child) {
              final address =
                  Provider.of<LocationProvider>(context, listen: false)
                      .addressList;
              String? id =
                  Provider.of<CustomAuthProvider>(context, listen: false)
                      .getUserAddressId();
              print("--------------${id}");
              double _finalPrice = 0;
              double _totalPrice = 0;
              double _totalDiscount = 0;

              cartProvider.cartList.forEach((cart) {
                String variationType = Helpers.getVariationType(
                    cart.product!, cart.variationIndex!);

                double price = cart.product!.price!;
                double discountAmount = 0;
                if (cart.product!.discountType == 'amount') {
                  discountAmount = cart.product!.discount!;
                } else {
                  discountAmount =
                      (cart.product!.price! * cart.product!.discount!) / 100;
                }
                for (Variation variation in cart.product!.variations!) {
                  if (variation.type == variationType) {
                    price = variation.price!;

                    if (cart.product!.discountType == 'amount') {
                      discountAmount = cart.product!.discount!;
                    } else {
                      discountAmount =
                          (variation.price! * cart.product!.discount!) / 100;
                    }

                    break;
                  }
                }

                _totalPrice = _totalPrice + (price * cart.quantity!);
                _totalDiscount =
                    _totalDiscount + (discountAmount * cart.quantity!);
              });
              final locationProvider =
                  Provider.of<LocationProvider>(context, listen: false);
              double deliveryCharge = locationProvider.deliveryFee;

              _finalPrice = _totalPrice -
                  _totalDiscount -
                  Provider.of<CouponProvider>(context).discount! +
                  deliveryCharge;

              double _priceWithDiscount = _totalPrice - _totalDiscount;

              double _couponDiscountAmount = 0;
              if (Provider.of<CouponProvider>(context).coupon != null) {
                _couponDiscountAmount = Helpers.applyDiscount(
                    Provider.of<CouponProvider>(context).coupon!,
                    (_totalPrice - _totalDiscount));
              }

              return Scrollbar(
                  child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      //  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(children: [
                                StatusCartWidget(
                                  delivery: true,
                                  payment: true,
                                  order: true,
                                  cart: true,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: cartProvider.cartList.length,
                                  itemBuilder: (context, index) {
                                    return CartProductWidget(
                                        fromSubmitOrder: true,
                                        cart: cartProvider.cartList[index],
                                        cartIndex: index,
                                        isAvailable: true);
                                  },
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    getTranslated('delivery', context),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Center(
                                    child: Consumer<CustomAuthProvider>(
                                      builder: (context, custom, child) {
                                        try {
                                          if (address == null ||
                                              address.isEmpty) {
                                            return SizedBox();
                                          }

                                          if (id == null || id.isEmpty) {
                                            return Text(
                                              address[0].address.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            );
                                          }

                                          var matchedAddress =
                                              address.firstWhere(
                                            (element) =>
                                                element.id == int.parse(id),
                                          );

                                          if (matchedAddress != null) {
                                            return Text(
                                              matchedAddress.address.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            );
                                          } else {
                                            return SizedBox();
                                          }
                                        } catch (e) {
                                          return SizedBox();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    getTranslated('PAYMENT', context),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          Images.masterCard,
                                          width: 50,
                                        ),
                                        Text(
                                          getTranslated('master_card', context),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Center(
                                            child: Text('0000-0000-0000-0000'
                                                // placeOrderProvider
                                                // .paymentNumber
                                                // .toString()
                                                )),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          '${getTranslated('total_price', context)}:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          )),
                                      Text(
                                          '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${_finalPrice}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ))
                                    ]),
                                SizedBox(
                                  height: 70,
                                ),
                                placeOrderProvider.isLoading == true
                                    ? Center(
                                        child: Padding(
                                        padding: EdgeInsets.all(
                                            Dimensions.PADDING_SIZE_SMALL),
                                        child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<
                                                    Color>(
                                                ColorResources.SCAFFOLD_COLOR)),
                                      ))
                                    : CustomButton(
                                        text: getTranslated(
                                            'submit_order', context),
                                        onTap: () {
                                          print(
                                              'placeOrderProvider.deliveryId ${placeOrderProvider.deliveryId}');
                                          _cartList = Provider.of<CartProvider>(
                                                  context,
                                                  listen: false)
                                              .cartList;
                                          List<ProductCart> carts = [];
                                          for (int index = 0;
                                              index < _cartList!.length;
                                              index++) {
                                            CartModel cart = _cartList![index];

                                            String variationType =
                                                Helpers.getVariationType(
                                                    cart.product!,
                                                    cart.variationIndex!);

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

                                            for (Variation variation
                                                in cart.product!.variations!) {
                                              if (variation.type ==
                                                  variationType) {
                                                price = variation.price!;

                                                if (cart.product!
                                                        .discountType ==
                                                    'amount') {
                                                  discountAmount =
                                                      cart.product!.discount!;
                                                } else {
                                                  discountAmount =
                                                      (variation.price! *
                                                              cart.product!
                                                                  .discount!) /
                                                          100;
                                                }

                                                break;
                                              }
                                            }

                                            Variation _variation =
                                                Provider.of<ProductProvider>(
                                                        context,
                                                        listen: false)
                                                    .getVariation(cart.product!,
                                                        cart.variationIndex!);

                                            carts.add(ProductCart(
                                                cart.product!.id.toString(),
                                                price.toString(),
                                                '',
                                                _variation,
                                                discountAmount,
                                                cart.quantity,
                                                cart.product!.tax));
                                          }

                                          PlaceOrderBody _orderModel =
                                              PlaceOrderBody(
                                            cart: carts,
                                            couponDiscountAmount:
                                                Provider.of<CouponProvider>(
                                                        context,
                                                        listen: false)
                                                    .discount,
                                            couponDiscountTitle: '',
                                            couponCode: Provider.of<
                                                                CouponProvider>(
                                                            context,
                                                            listen: false)
                                                        .coupon !=
                                                    null
                                                ? Provider.of<CouponProvider>(
                                                        context,
                                                        listen: false)
                                                    .coupon!
                                                    .code
                                                : null,
                                            orderAmount: _finalPrice,
                                            deliveryAddressId:
                                                placeOrderProvider.deliveryId,
                                            orderType: 'cart',
                                            paymentMethod: 'cash_on_delivery',
                                            orderNote: null,
                                          );
                                          placeOrderProvider
                                              .placeOrder(_orderModel)
                                              .then((value) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        DashboardScreen(
                                                            pageIndex: 0)));
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'order_placed_successfully',
                                                    context),
                                                context,
                                                isError: false);
                                          });
                                        })
                              ])))));
            })));
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
