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
import 'package:wired_express/view/base/not_logged_in_screen.dart';
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
        int minOrderQuantity =
            productProvider.productDetailsModel?.minimumOrderQuantity ?? 1;

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
                return const CustomCircularIndicator();
              }
              ProductModel product = productProvider.productDetailsModel!;
              List<TiredPricingModel> tiredPricing = product.tiredPricing ?? [];

              return Column(
                children: [
                  Expanded(child: ProductDetailsBodyView(product: product)),
                  Container(
                    padding: EdgeInsets.all(15),
                    color: ColorResources.getScaffoldBackgroundColor(context),
                    child: cartProvider.cartLoading == true
                        ? CustomCircularIndicator()
                        : CustomButton(
                            text: getTranslated('add_to_cart', context),
                            onTap: !isLoggedIn
                                ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            NotLoggedInScreen()))
                                : () {
                                    CartModel cartModel = CartModel(
                                        id: 0,
                                        productId: product.id,
                                        product: product,
                                        quantity: productProvider.quantity);

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
                  )
                ],
              );
            },
          );
        }));
  }
}
