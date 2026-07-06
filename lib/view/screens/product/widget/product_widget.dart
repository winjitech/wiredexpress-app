import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/rating_bar.dart';
import 'package:wired_express/view/screens/product/product_details_screen.dart';

class ProductWidget extends StatelessWidget {
  final ProductModel? product;

  ProductWidget({@required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ProfileProvider, SplashProvider, WishListProvider>(builder:
        (context, profileProvider, splashProvider, wishListProvider, child) {
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

      double discountedOnProductPrice = min(
        productPlanDiscountModel != null &&
                productPlanDiscountModel.planId != null
            ? PriceConverter.convertWithDiscount(
                context,
                product!.price!,
                productPlanDiscountModel.discount!,
                productPlanDiscountModel.discountType!,
              )
            : double.infinity,
        PriceConverter.convertWithDiscount(
          context,
          product!.price!,
          product!.discount!,
          product!.discountType!,
        ),
      );

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
                builder: (BuildContext context) =>
                    ProductDetailsScreen(productId: product!.id))),
        child: Container(
          padding: EdgeInsets.all(15.r),
          decoration: BoxDecoration(
            color: ColorResources.getCardColor(context),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: CachedNetworkImage(
                      height: 90.h,
                      width: 90.w,
                      fit: BoxFit.cover,
                      imageUrl:
                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}',
                      cacheKey:
                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}',
                    ),
                  ),

                  if (isEarlyProduct)
                    Positioned(
                      top: 5,
                      left: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          getTranslated('new', context),
                          style: AppTextStyles.h8(context).copyWith(
                            color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(width: 10.w),

              /// Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      product!.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.h2(
                        context,
                        fontSize: 15.sp,
                      ),
                    ),

                    SizedBox(height: 4.h),
                    RatingBar(
                        rating: product!.rating!.length > 0
                            ? double.parse(product!.rating![0].average!)
                            : 0.0),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        if (discountedOnProductPrice != originalPrice) ...[
                          Text(
                            "${splashProvider.configModel!.currencySymbol ?? '\$'}${Helpers.formatTextWithNum(originalPrice.toString())}",
                            style: AppTextStyles.h4(context).copyWith(
                              fontWeight: FontWeight.w500,
                              color: ColorResources.getTextColor(context)
                                  .withOpacity(.4),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 6.w),
                        ],

                        Text(
                          "${splashProvider.configModel!.currencySymbol ?? '\$'}${Helpers.formatTextWithNum(discountedOnProductPrice.toString())}",
                          style: AppTextStyles.h4(context).copyWith(
                            color: ColorResources.getPrimaryColor(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
            if(isLoggedIn)  GestureDetector(
                onTap: () {
                  if (wishListProvider.wishIdList.contains(product!.id)) {
                    wishListProvider.removeFromWishList(product!, (message) {});
                  } else {
                    wishListProvider.addToWishList(product!, (message) {});
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    color: ColorResources.getScaffoldBackgroundColor(context),
                   shape: BoxShape.circle
                  ),
                  child: Icon(
                    wishListProvider.wishIdList.contains(product!.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 18.sp,
                    color: wishListProvider.wishIdList.contains(product!.id)
                        ? ColorResources.getPrimaryColor(context)
                        : ColorResources.COLOR_GREY,
                  ),
                ),
              ),
            ],
          ),
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
