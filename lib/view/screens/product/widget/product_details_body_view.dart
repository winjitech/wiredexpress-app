import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/moq_setting_model.dart';
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

      List<TiredPricingModel> tiredPricing = product.tiredPricing ?? [];
      MoqSettingModel? moqSetting = product.moqSetting;
      int minOrderQuantity = moqSetting?.minimumOrderQuantity ?? 1;
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

      double discountedOnProductPrice = productPlanDiscountModel != null &&
              productPlanDiscountModel.planId != null
          ? PriceConverter.convertWithDiscount(
              context,
              product.price!,
              productPlanDiscountModel.discount!,
              productPlanDiscountModel.discountType!)
          : PriceConverter.convertWithDiscount(context, product.price!,
              product.discount!, product.discountType!);
      double price = PriceConverter.getProductFinalPrice(context, tiredPricing,
              discountedOnProductPrice, productProvider.quantity ?? 1) ??
          0.0;

      double priceWithQuantity = price * productProvider.quantity!;
      double priceWithQuantityWithoutDiscount =
          price * productProvider.quantity!;

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
      TiredPricingModel? tiredPricingModel =
          PriceConverter.getMatchedTieredPricingModel(
              context, tiredPricing, productProvider.quantity ?? 1);
      bool? haveTiredPricingDiscount =
          tiredPricingModel != null && tiredPricingModel.productId != null;
      print("haveTiredPricingDiscount == $haveTiredPricingDiscount");
      return Stack(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  String url =
                      '${splashProvider.baseUrls!.productImageUrl}/${product.image}';
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImagePreview(imageURL: url)));
                },
                child: Image.network(
                  '${splashProvider.baseUrls!.productImageUrl}/${product.image}',
                  fit: BoxFit.cover,
                  height: 450,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
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
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                            '$currency${Helpers.formatTextWithNum(discountedOnProductPrice.toString())}',
                            style: TextStyle(
                                color: ColorResources.getTextColor(context),
                                fontWeight: FontWeight.normal,
                                fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
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
                                      color: ColorResources.getScaffoldColor(
                                          context),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Icon(Icons.remove,
                                      size: 20,
                                      color: ColorResources
                                          .getScaffoldBackgroundColor(
                                              context))),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(productProvider.quantity.toString(),
                                  style: rubikMedium.copyWith(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: ColorResources.getTextColor(context),
                                  )),
                            ),
                            GestureDetector(
                              onTap: () => productProvider
                                  .setQuantity(productProvider.quantity! + 1),
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: ColorResources.getScaffoldColor(
                                        context),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Icon(
                                  Icons.add,
                                  size: 20,
                                  color:
                                      ColorResources.getScaffoldBackgroundColor(
                                          context),
                                ),
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
                        price > discountedOnProductPrice
                            ? Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  PriceConverter.convertPrice(context, price),
                                  style: const TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              )
                            : const SizedBox(),
                        Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            RatingBar(
                                rating: product.rating!.length > 0
                                    ? double.parse(product.rating![0].average!)
                                    : 0.0,
                                size: 18),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      Text('${getTranslated('total_amount', context)}:',
                          style: rubikMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: ColorResources.getTextColor(context))),
                      const SizedBox(
                          width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      if (((product.price! * productProvider.quantity!)) !=
                          priceWithQuantity)
                        Row(
                          children: [
                            Text(
                              "${splashProvider.configModel!.currencySymbol ?? '\$'}${Helpers.formatTextWithNum((product.price! * productProvider.quantity!).toString())}",
                              style: TextStyle(
                                color: ColorResources.getTextColor(context)
                                    .withOpacity(0.4),
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                decoration: TextDecoration.lineThrough,
                                decorationColor:
                                    ColorResources.getTextColor(context)
                                        .withOpacity(0.4),
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      Text(
                        PriceConverter.convertPrice(context, priceWithQuantity),
                        style: TextStyle(
                            fontSize: 16,
                            color: ColorResources.getPrimaryColor(context),
                            fontWeight: FontWeight.w600),
                      ),
                    ]),
                  ],
                ),
              )
            ],
          ),
          Positioned(
              top: 15,
              left: 15,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(8),
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
                    padding: EdgeInsets.all(8),
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
      );
    });
  }
}
