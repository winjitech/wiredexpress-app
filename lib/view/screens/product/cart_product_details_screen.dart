import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/screens/product/widget/product_details_body_view.dart';

class CartProductDetailsScreen extends StatefulWidget {
  final ProductModel? product;
  final CartModel? cart;
  CartProductDetailsScreen({@required this.product, this.cart});
  @override
  _CartProductDetailsScreenState createState() =>
      _CartProductDetailsScreenState();
}

class _CartProductDetailsScreenState extends State<CartProductDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 0), () async {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);

      productProvider.setQuantity(widget.cart!.quantity!);

      await productProvider
          .getProductDetails(context, widget.product!.id!)
          .then((onValue) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
        key: _scaffoldKey,
        body: Consumer<CartProvider>(builder: (context, cartProvider, child) {
          return Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              if (productProvider.productDetailsLoading ||
                  productProvider.productDetailsModel == null) {
                return CustomCircularIndicator();
              }
              ProductModel product = productProvider.productDetailsModel!;
              List<TiredPricingModel> tiredPricing = product.tiredPricing ?? [];

              return Column(
                children: [
                  Expanded(child: ProductDetailsBodyView(product: product)),
                  Container(
                    padding: EdgeInsets.all(15),
                    color: ColorResources.getScaffoldBackgroundColor(context),
                    child: Column(
                      children: [
                        !cartProvider.cartLoading
                            ? Column(children: [
                                CustomButton(
                                  text:
                                      getTranslated('update_in_cart', context),
                                  backgroundColor:
                                      ColorResources.getPrimaryColor(context),
                                  onTap: () {
                                    CartModel cartModel = CartModel(
                                        id: widget.cart!.id!,
                                        productId: product.id,
                                        quantity: productProvider.quantity,
                                        product: product,
                                        tieredPricing: PriceConverter
                                            .getMatchedTieredPricingModel(
                                                context,
                                                tiredPricing,
                                                productProvider.quantity ?? 1));

                                    cartProvider
                                        .addToCartList(cartModel)
                                        .then((value) {
                                      cartProvider.initCartList(context);
                                      cartProvider
                                          .initCartListProductIds(context);
                                      showCustomSnackBar(
                                          getTranslated(
                                              'updated_successfully', context),
                                          context,
                                          isError: false);
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                                SizedBox(height: 15),
                                MaterialButton(
                                    onPressed: () {
                                      cartProvider
                                          .removeFromCartList(
                                              widget.cart!.id!, product.id!)
                                          .then((value) {
                                        cartProvider.initCartList(context);
                                        cartProvider
                                            .initCartListProductIds(context);
                                        showCustomSnackBar(
                                            getTranslated(
                                                'delete_from_cart_successful',
                                                context),
                                            context,
                                            isError: false);
                                        Navigator.pop(context);
                                      });
                                    },
                                    color: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    elevation: 0,
                                    minWidth: MediaQuery.of(context).size.width,
                                    height: 50,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        side: BorderSide(color: Colors.red)),
                                    child: Text(
                                        getTranslated(
                                            'delete_from_cart', context),
                                        style: TextStyle(color: Colors.red))),
                              ])
                            : CustomCircularIndicator(
                                color:
                                    ColorResources.getScaffoldColor(context)),
                      ],
                    ),
                  )
                ],
              );
            },
          );
        }));
  }
}
