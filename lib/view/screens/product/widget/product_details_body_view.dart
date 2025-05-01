import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/product_plan_discount_model.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/rating_bar.dart';
import 'package:wired_express/view/screens/home/widget/image_preview.dart';

class ProductDetailsBodyView extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsBodyView({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return Consumer5<ProductProvider, CategoryProvider, SplashProvider,
            WishListProvider, ProfileProvider>(
        builder: (context, productProvider, categoryProvider, splashProvider,
            wishList, profileProvider, child) {
      bool isLoggedIn =
          Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
      String currency = splashProvider.configModel!.currencySymbol ?? '\$';

      List<TiredPricingModel> tiredPricings = product.tiredPricing ?? [];
      // MoqSettingModel? moqSetting = product.moqSetting;
      // int minOrderQuantity = moqSetting?.minimumOrderQuantity ?? 1;
      int minOrderQuantity = product.minimumOrderQuantity ?? 1;
      ProductPlanDiscountModel? productPlanDiscountModel;
      if (isLoggedIn &&
          profileProvider.userInfoModel != null &&
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
      double originalPrice = product.price!;

      TiredPricingModel? tiredPricingModel;

      double priceAfterProductPlanDiscount = productPlanDiscountModel != null &&
              productPlanDiscountModel.planId != null
          ? PriceConverter.convertWithDiscount(
              context,
              originalPrice,
              productPlanDiscountModel.discount!,
              productPlanDiscountModel.discountType!)
          : originalPrice;
      print(
          "priceAfterProductPlanDiscount -- ${priceAfterProductPlanDiscount}");
      double priceAfterNormalDiscountOnProduct =
          PriceConverter.convertWithDiscount(context, originalPrice,
              product.discount!, product!.discountType!);
      print(
          "priceAfterNormalDiscountOnProduct -- ${priceAfterNormalDiscountOnProduct}");

      double priceAfterTiredPricing = PriceConverter.getProductFinalPrice(
              context,
          tiredPricings,
              originalPrice,
              productProvider.quantity ?? 1) ??
          0.0;
      print("priceAfterTiredPricing -- ${priceAfterTiredPricing}");
      double finalPriceWithoutQuantity = min(
        priceAfterProductPlanDiscount,
        min(priceAfterNormalDiscountOnProduct, priceAfterTiredPricing),
      );
      print("finalPriceWithoutQuantity -- ${finalPriceWithoutQuantity}");
      String discountMessage;

      if (finalPriceWithoutQuantity == priceAfterProductPlanDiscount) {
        double discount = productPlanDiscountModel?.discount ?? 0;

        if (discount > 0) {
          discountMessage = '${getTranslated('get', context)} '
              '${PriceConverter.calculateDiscountAmount(context, originalPrice, discount, productPlanDiscountModel?.discountType ?? "amount")} '
              '${getTranslated('off_per_item_on_orders_of', context).toLowerCase()} '
              '${getTranslated('as_plan_discount', context)}';
        } else {
          discountMessage = "none";
        }
      } else if (finalPriceWithoutQuantity ==
          priceAfterNormalDiscountOnProduct) {
        double discount = product.discount ?? 0;

        tiredPricingModel = PriceConverter.getMatchedTieredPricingModel(
          context,
          tiredPricings,
          productProvider.quantity ?? 1,
        );

        if (discount > 0) {
          discountMessage = '';
              // '${PriceConverter.calculateDiscountAmount(context, originalPrice, discount, product.discountType ?? "amount")} '
              // '${getTranslated('off_per_item_on_orders_of', context).toLowerCase()} '
              // '${getTranslated('as_promotional_discount', context)}';
        } else {
          discountMessage = "none";
        }
      } else if (finalPriceWithoutQuantity == priceAfterTiredPricing) {
        tiredPricingModel = PriceConverter.getMatchedTieredPricingModel(
          context,
          tiredPricings,
          productProvider.quantity ?? 1,
        );
        discountMessage = '${tiredPricingModel!.minQuantity ?? "this"} '
            '${getTranslated('items', context)} +: '
            '$currency${Helpers.formatTextWithNum(tiredPricingModel.discountPrice!)} '
            '${getTranslated('off_per_item', context)}';

        // discountMessage = '${getTranslated('get', context)} '
        //     '${Helpers.formatTextWithNum(tiredPricingModel!.discountPrice!)} '
        //     '${getTranslated('off_per_item_on_orders_of', context).toLowerCase()} '
        //     '${tiredPricingModel.minQuantity ?? "this"}+ '
        //     '${getTranslated('units', context).toLowerCase()}';
      } else {
        discountMessage = "none";
      }

      print(discountMessage);

      double finalPriceWithQuantity =
          finalPriceWithoutQuantity * productProvider.quantity!;
      double originalPriceWithQuantity =
          originalPrice * productProvider.quantity!;
      print('Final Price With Quantity: $finalPriceWithQuantity');
      print('Original Price With Quantity: $originalPriceWithQuantity');

      DateTime currentTime = splashProvider.currentTime;
      DateTime start =
          DateFormat('hh:mm:ss').parse(product.availableTimeStarts!);
      DateTime end = DateFormat('hh:mm:ss').parse(product.availableTimeEnds!);
      DateTime startTime = DateTime(currentTime.year, currentTime.month,
          currentTime.day, start.hour, start.minute, start.second);
      DateTime endTime = DateTime(currentTime.year, currentTime.month,
          currentTime.day, end.hour, end.minute, end.second);
      if (endTime.isBefore(startTime)) {
        endTime = endTime.add(const Duration(days: 1));
      }

      bool isAvailable = true;
      String description = '';
      description = product.description ?? '';
      return Scrollbar(
          child: Stack(
        children: [
          SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImagePreview(
                                imageURL:
                                    '${splashProvider.baseUrls!.productImageUrl}/${product.image}'))),
                    child: Image.network(
                      '${splashProvider.baseUrls!.productImageUrl}/${product.image}',
                      fit: BoxFit.cover,
                      height: 450,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.name!,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    color: ColorResources.getTextColor(context),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            if (originalPrice != finalPriceWithoutQuantity)
                              Text(
                                "$currency${Helpers.formatTextWithNum(originalPrice.toString())}",
                                style: TextStyle(
                                  color: ColorResources.getTextColor(context)
                                      .withOpacity(0.4),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor:
                                      ColorResources.getTextColor(context)
                                          .withOpacity(0.4),
                                ),
                              ),
                            SizedBox(width: 5),
                            Text(
                              "$currency${Helpers.formatTextWithNum(finalPriceWithoutQuantity.toString())}",
                              style: TextStyle(
                                color: ColorResources.getTextColor(context),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(children: [
                                GestureDetector(
                                  onTap: () {
                                    if (productProvider.quantity! >
                                        minOrderQuantity) {
                                      productProvider.setQuantity(
                                          productProvider.quantity! - 1);
                                    }
                                  },
                                  child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          color: ColorResources.getTextColor(
                                                  context)
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Icon(Icons.remove,
                                          size: 20,
                                          color: ColorResources.getTextColor(
                                              context))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child:
                                      Text(productProvider.quantity.toString(),
                                          style: rubikMedium.copyWith(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500,
                                            color: ColorResources.getTextColor(
                                                context),
                                          )),
                                ),
                                GestureDetector(
                                  onTap: () => productProvider.setQuantity(
                                      productProvider.quantity! + 1),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        color:
                                            ColorResources.getTextColor(context)
                                                .withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Icon(Icons.add,
                                        size: 20,
                                        color: ColorResources.getTextColor(
                                            context)),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                RatingBar(
                                    rating: product.rating!.length > 0
                                        ? double.parse(
                                            product.rating![0].average!)
                                        : 0.0,
                                    size: 18),
                              ],
                            ),
                          ],
                        ),
                        product.description != null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Text(
                                    getTranslated('description', context),
                                    style: TextStyle(
                                        color: ColorResources.getTextColor(
                                            context),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              description,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: ColorResources.getTextColor(context)
                                      .withOpacity(0.6),
                                  fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (discountMessage != "none")
                          Column(
                            children: [
                              Text(
                                discountMessage,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      ColorResources.getPrimaryColor(context),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        if (minOrderQuantity != 1)
                          Column(
                            children: [
                              Text(
                                  "${getTranslated('min_order_quantity_is', context)} $minOrderQuantity",
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange,
                                      fontSize: 14)),
                              const SizedBox(height: 5),
                            ],
                          ),
                        Row(children: [
                          Text('${getTranslated('total_amount', context)}:',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: ColorResources.getTextColor(context))),
                          const SizedBox(
                              width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          if (originalPriceWithQuantity !=
                              finalPriceWithQuantity)
                            Text(
                              "$currency${Helpers.formatTextWithNum(originalPriceWithQuantity.toString())}",
                              style: TextStyle(
                                color: ColorResources.getTextColor(context)
                                    .withOpacity(0.4),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
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
                            "$currency${Helpers.formatTextWithNum(finalPriceWithQuantity.toString())}",
                            style: TextStyle(
                              color: ColorResources.getPrimaryColor(context),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              )),
          Positioned(
              top: 15,
              left: 15,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorResources.getScaffoldBackgroundColor(context),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ColorResources.getBoxShadow(context),
                          offset: const Offset(0, 2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        size: 20,
                        Icons.arrow_back_ios_sharp,
                        color: ColorResources.getTextColor(context)
                            .withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              )),
          Positioned(
              top: 15,
              right: 15,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => wishList.wishIdList
                          .contains(productProvider.productDetailsModel!.id)
                      ? wishList.removeFromWishList(
                          productProvider.productDetailsModel!, (message) {
                          wishList.initWishList(context);
                          wishList.initWishListProductIds(context);
                        })
                      : wishList.addToWishList(
                          productProvider.productDetailsModel!, (message) {
                          wishList.initWishList(context);
                          wishList.initWishListProductIds(context);
                        }),
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorResources.getScaffoldBackgroundColor(context),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ColorResources.getBoxShadow(context),
                          offset: const Offset(0, 2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      size: 25,
                      wishList.wishIdList
                              .contains(productProvider.productDetailsModel!.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: wishList.wishIdList
                              .contains(productProvider.productDetailsModel!.id)
                          ? ColorResources.getPrimaryColor(context)
                          : ColorResources.getTextColor(context)
                              .withOpacity(0.4),
                    ),
                  ),
                ),
              ))
        ],
      ));
    });
  }
}
