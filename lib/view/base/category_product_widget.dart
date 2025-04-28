import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/product_plan_discount_model.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:wired_express/view/screens/product/product_details_screen.dart';

class CategoryProductWidget extends StatelessWidget {
  final ProductModel? product;
  CategoryProductWidget({@required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer4<ProfileProvider, ProductProvider, SplashProvider,
            WishListProvider>(
        builder: (context, profileProvider, productProvider, splashProvider,
            wishListProvider, child) {
      bool isLoggedIn =
          Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
      ProductPlanDiscountModel? productPlanDiscountModel;
      if (isLoggedIn &&
          profileProvider.userInfoModel != null &&
          profileProvider.userInfoModel!.exclusiveDiscounts == 1) {
        List<ProductPlanDiscountModel> productPlanDiscount =
            product!.productPlanDiscount ?? [];

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
              product!.price!,
              productPlanDiscountModel.discount!,
              productPlanDiscountModel.discountType!)
          : PriceConverter.convertWithDiscount(context, product!.price!,
              product!.discount!, product!.discountType!);
      double originalPrice = PriceConverter.convertWithDiscount(
          context, product!.price!, 0.0, 'amount');

      DateTime currentTime = splashProvider.currentTime;
      DateTime startTime =
          _parseAvailableTime(product!.availableTimeStarts!, currentTime);
      DateTime endTime =
          _parseAvailableTime(product!.availableTimeEnds!, currentTime);

      if (endTime.isBefore(startTime)) {
        endTime = endTime.add(const Duration(days: 1));
      }

      bool isAvailable = DateConverter.isAvailable(
          product!.availableTimeStarts!, product!.availableTimeEnds!, context);
      bool isEarlyProduct = product!.isEarlyProduct == 1;

      return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext? context) =>
                    ProductDetailsScreen(productId: product!.id))),
        child: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: ColorResources.getBorderColor(context),
                      width: 0.4),
                  color: ColorResources.getScaffoldBackgroundColor(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        imageUrl:
                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}',
                        cacheKey:
                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product!.name!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: ColorResources.getTextColor(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          RatingBar(
                              rating: product!.rating!.length > 0
                                  ? double.parse(product!.rating![0].average!)
                                  : 0.0,
                              size: 18),
                          Row(
                            children: [
                              Row(
                                children: [
                                  if (discountedOnProductPrice != originalPrice)
                                    Text(
                                      "${splashProvider.configModel!.currencySymbol ?? '\$'}${Helpers.formatTextWithNum(originalPrice.toString())}",
                                      style: TextStyle(
                                        color:
                                            ColorResources.getTextColor(context)
                                                .withOpacity(0.4),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor:
                                            ColorResources.getTextColor(context)
                                                .withOpacity(0.4),
                                      ),
                                    ),
                                  const SizedBox(width: 5),
                                ],
                              ),
                              Text(
                                "${splashProvider.configModel!.currencySymbol ?? '\$'}${Helpers.formatTextWithNum(discountedOnProductPrice.toString())}",
                                style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        ColorResources.getPrimaryColor(context),
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                )),
            if (isEarlyProduct)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: Colors.green,
                    ),
                    child: Text(
                      getTranslated('new', context),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorResources.getCardColor(context)),
                    )),
              ),
            if (isLoggedIn)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                    onTap: () {
                      if (wishListProvider.wishIdList.contains(product!.id)) {
                        wishListProvider.removeFromWishList(
                            product!, (message) {});
                      } else {
                        wishListProvider.addToWishList(product!, (message) {});
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 15, bottom: 15),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorResources.getTextColor(context)
                              .withOpacity(0.1)),
                      child: Icon(
                        wishListProvider.wishIdList.contains(product!.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: wishListProvider.wishIdList.contains(product!.id)
                            ? ColorResources.getPrimaryColor(context)
                            : ColorResources.getTextColor(context)
                                .withOpacity(0.5),
                      ),
                    )),
              ),
          ],
        ),
      );
    });
  }

  DateTime _parseAvailableTime(String timeString, DateTime currentTime) {
    DateTime time = DateFormat('hh:mm:ss').parse(timeString);
    return DateTime(currentTime.year, currentTime.month, currentTime.day,
        time.hour, time.minute, time.second);
  }
}
