import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/product_bottom_sheet.dart';
import 'package:wired_express/view/screens/product/widget/product_details_body_view.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int? productId;
  ProductDetailsScreen({@required this.productId});
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 0), () async {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await productProvider
          .getProductDetails(context, widget.productId!)
          .then((onValue) {
        int minOrderQuantity = productProvider
                .productDetailsModel?.moqSetting?.minimumOrderQuantity ??
            1;

        productProvider.setQuantity(minOrderQuantity);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    return Scaffold(
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
        key: _scaffoldKey,
        body: Consumer<CartProvider>(builder: (context, cartProvider, child) {
          return Consumer2<ProductProvider, SplashProvider>(
            builder: (context, productProvider, splashProvider, child) {
              String currency =
                  splashProvider.configModel!.currencySymbol ?? '\$';

              if (productProvider.productDetailsLoading ||
                  productProvider.productDetailsModel == null) {
                return CustomCircularIndicator();
              }
              ProductModel product = productProvider.productDetailsModel!;
              List<TiredPricingModel> tiredPricing = product.tiredPricing ?? [];

              return Scrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ProductDetailsBodyView(product: product),
                      Padding(
                        padding: EdgeInsets.all(25),
                        child: Column(
                          children: [
                            if (isLoggedIn)
                              cartProvider.cartLoading == true
                                  ? CustomCircularIndicator(
                                      color: ColorResources.getScaffoldColor(
                                          context))
                                  : CustomButton(
                                      text:
                                          getTranslated('add_to_cart', context),
                                      onTap: () {
                                        CartModel cartModel = CartModel(
                                            id: 0,
                                            productId: product.id,
                                            product: product,
                                            quantity: productProvider.quantity,
                                            tieredPricing: PriceConverter
                                                .getMatchedTieredPricingModel(context ,
                                                    tiredPricing,
                                                    productProvider.quantity ??
                                                        1));

                                        cartProvider
                                            .addToCartList(cartModel)
                                            .then((value) {
                                          cartProvider.initCartList(context);
                                          cartProvider
                                              .initCartListProductIds(context);
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'added_cart_successfully',
                                                  context),
                                              context,
                                              isError: false);
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: () => showModalBottomSheet(
                                useSafeArea: true,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return ProductDetailsBottomSheet(
                                    product: product,
                                    callback: (CartModel cartModel) {
                                      ScaffoldMessenger.of(context!)
                                          .showSnackBar(SnackBar(
                                              content: Text(getTranslated(
                                                  'added_to_cart', context)),
                                              backgroundColor: Colors.green));
                                    },
                                  );
                                },
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(getTranslated('specification', context),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: ColorResources.getTextColor(
                                                  context)
                                              .withOpacity(0.6),
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 10),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 15,
                                    color: ColorResources.getTextColor(context)
                                        .withOpacity(0.6),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }));
  }
}
