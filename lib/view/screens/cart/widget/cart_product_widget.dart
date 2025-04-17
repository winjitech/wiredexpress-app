import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/product_plan_discount_model.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
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

  CartProductWidget({
    @required this.cart,
    @required this.cartIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer4<ProductProvider, CartProvider, SplashProvider,
        ProfileProvider>(
      builder: (context, productProvider, cartProvider, splashProvider,
          profileProvider, child) {
        print('cart here -- ${jsonEncode(cart)}');

        ProductModel product = cart!.product!;
        int quantity = cart!.quantity!;
        TiredPricingModel? tiredPricing =
            cart!.tieredPricing ?? TiredPricingModel();
        double priceBeforeDisc = product.price!;
        ProductPlanDiscountModel? productPlanDiscountModel;
        if (profileProvider.userInfoModel != null &&
            profileProvider.userInfoModel!.exclusiveDiscounts == 1) {
          List<ProductPlanDiscountModel> productPlanDiscount =
              product.productPlanDiscount ?? [];

          try {
            productPlanDiscountModel = productPlanDiscount.firstWhere(
                  (discount) =>
              discount.planId ==
                  profileProvider.userInfoModel!.userSubscription!.planId,
              orElse: () => ProductPlanDiscountModel(),
            );
          } catch (e) {
            print("Error finding discount: $e");
            productPlanDiscountModel = ProductPlanDiscountModel();
          }
        }

        double discountedOnProductPrice = productPlanDiscountModel != null &&
            productPlanDiscountModel.planId != null
            ? PriceConverter.convertWithDiscount(
            context,
            product.price!,
            productPlanDiscountModel.discount!,
            productPlanDiscountModel.discountType!)
            : PriceConverter.convertWithDiscount(context, product.price!,
            product.discount!, product.discountType!);

        double priceAfterTieredPricing =
            PriceConverter.getProductFinalPriceWithTieredPricing(
                tiredPricing, discountedOnProductPrice) ??
                0.0;
        double finalProductPrice = priceAfterTieredPricing * quantity;

        String currency = splashProvider.configModel!.currencySymbol ?? '\$';
        bool haveDiscount = (priceBeforeDisc * quantity) != finalProductPrice;

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext? context) => CartProductDetailsScreen(
                  product: cart!.product!, cart: cart!),
            ),
          ),
          child: Container(
            margin:
            const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                horizontal: Dimensions.PADDING_SIZE_SMALL,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      imageUrl:
                      '${splashProvider.baseUrls!.productImageUrl}/${product.image}',
                      cacheKey:
                      '${splashProvider.baseUrls!.productImageUrl}/${product.image}',
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          product.name!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Row(
                                    children: [
                                      if (haveDiscount)
                                        Text(
                                          '$currency${Helpers.formatTextWithNum((priceBeforeDisc * quantity).toString())}',
                                          style: TextStyle(
                                            color:
                                            ColorResources.getTextColor(context)
                                                .withOpacity(0.4),
                                            fontSize: 16,
                                            decoration: TextDecoration.lineThrough,
                                            decorationColor:
                                            ColorResources.getTextColor(context)
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '$currency${Helpers.formatTextWithNum(finalProductPrice.toString())}',
                                        style: TextStyle(
                                          color:
                                          ColorResources.getTextColor(context),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  )),
                              // Quantity Controls
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    quantity == 1
                                        ? GestureDetector(
                                      onTap: () {
                                        Provider.of<CartProvider>(context,
                                            listen: false)
                                            .removeFromCart(cart!);
                                        Provider.of<CartProvider>(context,
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
                                                .getScaffoldColor(
                                                context),
                                            borderRadius:
                                            BorderRadius.circular(
                                                50)),
                                        child: const Icon(
                                          Icons.delete,
                                          size: 20,
                                          color:
                                          ColorResources.COLOR_WHITE,
                                        ),
                                      ),
                                    )
                                        : GestureDetector(
                                      onTap: () {
                                        if (quantity > 1) {
                                          Provider.of<CartProvider>(
                                              context,
                                              listen: false)
                                              .updateQuantity(cartIndex!,
                                              quantity - 1);
                                        }
                                      },
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: ColorResources
                                                .getScaffoldColor(
                                                context),
                                            borderRadius:
                                            BorderRadius.circular(
                                                50)),
                                        child: const Icon(
                                          Icons.remove,
                                          size: 20,
                                          color:
                                          ColorResources.COLOR_WHITE,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        quantity.toString(),
                                        style: rubikMedium.copyWith(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                          color: ColorResources.getTextColor(
                                              context),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Provider.of<CartProvider>(context,
                                            listen: false)
                                            .updateQuantity(
                                            cartIndex!, quantity + 1);
                                      },
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color:
                                          ColorResources.getScaffoldColor(
                                              context),
                                          borderRadius:
                                          BorderRadius.circular(50),
                                        ),
                                        child: const Icon(
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
