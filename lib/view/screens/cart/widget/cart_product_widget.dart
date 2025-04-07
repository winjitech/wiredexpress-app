import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/moq_setting_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/screens/product/cart_product_details_screen.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel? cart;
  final int? cartIndex;
  final bool? isAvailable;
  final bool? fromSubmitOrder;

  CartProductWidget({
    @required this.cart,
    @required this.cartIndex,
    @required this.isAvailable,
    this.fromSubmitOrder = false,
  });

  @override
  Widget build(BuildContext context) {
    print('cart here -- ${jsonEncode(cart)}');

    Product product = cart!.product!;
    MoqSettingModel? moqSetting = product.moqSetting;
    int minOrderQuantity = moqSetting?.minimumOrderQuantity ?? 1;
    List<TiredPricingModel> tiredPricing = product.tiredPricing ?? [];

    double priceWithDiscount = PriceConverter.convertWithDiscount(
        context, product.price!, product.discount!, product.discountType!);
    double price = PriceConverter.getProductFinalPrice(
            tiredPricing, priceWithDiscount, cart!.quantity ?? 1) ??
        0.0;
    print("pricepricepriceprice == $price");
    double priceWithQuantity = price * cart!.quantity!;
    double priceWithQuantityWithoutDiscount = price * cart!.quantity!;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            return fromSubmitOrder == true
                ? GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          horizontal: Dimensions.PADDING_SIZE_SMALL,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // color: Colors.grey[400],
                              ),
                              width: 100,
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.network(
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image}',
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          '${cart!.quantity!} items',
                                          style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${priceWithQuantity}',
                                        style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext? context) =>
                            CartProductDetailsScreen(
                          product: cart!.product!,
                          cartIndex: cartIndex!,
                          cart: cart!,
                          callback: (CartModel cartModel) {
                            ScaffoldMessenger.of(context!).showSnackBar(
                              SnackBar(
                                content: Text(
                                    getTranslated('updated_in_cart', context)),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          horizontal: Dimensions.PADDING_SIZE_SMALL,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Provider.of<ThemeProvider>(context)
                                            .darkTheme
                                        ? Colors.black.withOpacity(0.4)
                                        : Colors.grey[300]!,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  )
                                ],
                                color: Colors.white,
                              ),
                              width: 100,
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.network(
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}',
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      '${cart!.quantity!} items',
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${priceWithQuantity}',
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        cart!.quantity! == 1
                                            ? GestureDetector(
                                                onTap: () {
                                                  Provider.of<CartProvider>(
                                                          context,
                                                          listen: false)
                                                      .removeFromCart(cart!);
                                                  Provider.of<CartProvider>(
                                                          context,
                                                          listen: false)
                                                      .removeFromCartList(
                                                          cart!.id!,
                                                          cart!.productId!,
                                                          (message) {});
                                                  showCustomSnackBar(
                                                      getTranslated(
                                                          'removed_cart_successfully',
                                                          context),
                                                      context,
                                                      isError: false);
                                                },
                                                child: Container(
                                                  width: 25,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      color: ColorResources
                                                          .getScaffoldColor(context),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  child: Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                    color: ColorResources
                                                        .COLOR_WHITE,
                                                  ),
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  if (cart!.quantity! > 1) {
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .updateQuantity(
                                                            cartIndex!,
                                                            cart!.quantity! -
                                                                1);
                                                  }
                                                },
                                                child: Container(
                                                  width: 25,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      color: ColorResources
                                                          .getScaffoldColor(context),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 20,
                                                    color: ColorResources
                                                        .COLOR_WHITE,
                                                  ),
                                                ),
                                              ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            cart!.quantity.toString(),
                                            style: rubikMedium.copyWith(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  ColorResources.getTextColor(
                                                      context),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Provider.of<CartProvider>(context,
                                                    listen: false)
                                                .updateQuantity(cartIndex!,
                                                    cart!.quantity! + 1);
                                          },
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color:
                                                  ColorResources.getScaffoldColor(context),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 20,
                                              color: ColorResources.COLOR_WHITE,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          },
        );
      },
    );
  }
}
