// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:wired_express/data/model/response/product_model.dart';
// import 'package:wired_express/helper/date_converter.dart';
// import 'package:wired_express/helper/price_converter.dart';
// import 'package:wired_express/provider/auth_provider.dart';
// import 'package:wired_express/provider/cart_provider.dart';
// import 'package:wired_express/provider/product_provider.dart';
// import 'package:wired_express/provider/splash_provider.dart';
// import 'package:wired_express/provider/wishlist_provider.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:wired_express/view/screens/product/product_details_screen.dart';
//
// class ProductWidget extends StatelessWidget {
//   final ProductModel? product;
//   ProductWidget({@required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isLoggedIn =
//         Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
//     final cart = Provider.of<CartProvider>(context, listen: false);
//     final productProvider =
//         Provider.of<ProductProvider>(context, listen: false);
//
//     double discountedPrice = PriceConverter.convertWithDiscount(
//         context, product!.price!, product!.discount!, product!.discountType!);
//
//     DateTime currentTime =
//         Provider.of<SplashProvider>(context, listen: false).currentTime;
//     DateTime start =
//         DateFormat('hh:mm:ss').parse(product!.availableTimeStarts!);
//     DateTime end = DateFormat('hh:mm:ss').parse(product!.availableTimeEnds!);
//     DateTime startTime = DateTime(currentTime.year, currentTime.month,
//         currentTime.day, start.hour, start.minute, start.second);
//     DateTime endTime = DateTime(currentTime.year, currentTime.month,
//         currentTime.day, end.hour, end.minute, end.second);
//     if (endTime.isBefore(startTime)) {
//       endTime = endTime.add(const Duration(days: 1));
//     }
//     bool isAvailable = DateConverter.isAvailable(
//         product!.availableTimeStarts!, product!.availableTimeEnds!, context);
//     isAvailable = true;
//     return GestureDetector(
//         onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext? context) =>
//                     ProductDetailsScreen(productId: product!.id))),
//         child: Container(
//             decoration: BoxDecoration(
//               color: ColorResources.getScaffoldBackgroundColor(context),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Column(children: [
//               Stack(children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: CachedNetworkImage(
//                     height: 170,
//                     fit: BoxFit.cover,
//                     imageUrl:
//                         '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}',
//                     cacheKey:
//                         '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}',
//                   ),
//                 ),
//                 Positioned(
//                     top: 0,
//                     right: 0,
//                     child: Consumer<WishListProvider>(
//                         builder: (context, wishList, child) {
//                       return IconButton(
//                           onPressed: () {
//                             wishList.wishIdList.contains(product!.id)
//                                 ? wishList.removeFromWishList(
//                                     product!, (message) {})
//                                 : wishList.addToWishList(
//                                     product!, (message) {});
//                           },
//                           icon: isLoggedIn
//                               ? Icon(
//                                   wishList.wishIdList.contains(product!.id)
//                                       ? Icons.favorite
//                                       : Icons.favorite_border,
//                                   color: wishList.wishIdList
//                                           .contains(product!.id)
//                                       ? ColorResources.getPrimaryColor(context)
//                                       : ColorResources.COLOR_GREY)
//                               : const SizedBox());
//                     }))
//               ]),
//               const SizedBox(height: 10),
//               Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                   child: Column(
//                     children: [
//                       Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                                 child: Text(product!.name!,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 15))),
//                           ]),
//                       SizedBox(height: 5),
//                       Row(children: [
//                         Text(
//                             PriceConverter.convertPrice(context, product!.price,
//                                 discount: product!.discount,
//                                 discountType: product!.discountType),
//                             style: const TextStyle(
//                                 color: Colors.black38,
//                                 fontWeight: FontWeight.w500)),
//                         Text(
//                             PriceConverter.convertPrice(context, product!.price,
//                                         discount: product!.discount,
//                                         discountType: product!.discountType) ==
//                                     PriceConverter.convertPrice(
//                                         context, product!.price)
//                                 ? ""
//                                 : PriceConverter.convertPrice(
//                                     context, product!.price),
//                             style: const TextStyle(
//                                 color: Colors.black45,
//                                 fontWeight: FontWeight.normal,
//                                 fontSize: 16,
//                                 decoration: TextDecoration.lineThrough))
//                       ]),
//                     ],
//                   ))
//             ])));
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/product_plan_discount_model.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:wired_express/view/screens/product/product_details_screen.dart';

class ProductWidget extends StatelessWidget {
  final ProductModel? product;

  ProductWidget({@required this.product});

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
                builder: (BuildContext context) =>
                    ProductDetailsScreen(productId: product!.id))),
        child: Container(
          decoration: BoxDecoration(
            color: ColorResources.getScaffoldBackgroundColor(context),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      height: 170,
                      fit: BoxFit.cover,
                      imageUrl:
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}',
                      cacheKey:
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}',
                    ),
                  ),
                  if (isLoggedIn)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                          onTap: () {
                            if (wishListProvider.wishIdList
                                .contains(product!.id)) {
                              wishListProvider.removeFromWishList(
                                  product!, (message) {});
                            } else {
                              wishListProvider.addToWishList(
                                  product!, (message) {});
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              color: ColorResources.getScaffoldBackgroundColor(
                                  context),
                            ),
                            child: Icon(
                              wishListProvider.wishIdList.contains(product!.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: wishListProvider.wishIdList
                                      .contains(product!.id)
                                  ? ColorResources.getPrimaryColor(context)
                                  : ColorResources.COLOR_GREY,
                            ),
                          )),
                    ),
                  if (isEarlyProduct)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14 , vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green,
                          ),
                          child: Text(getTranslated('new', context) , 
                          style: TextStyle(fontSize: 14 ,fontWeight: FontWeight.w500,
                            color: ColorResources.getCardColor(context)
                          ),)),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product!.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Row(
                          children: [
                            if (discountedOnProductPrice != originalPrice)
                              Text(
                                "${splashProvider.configModel!.currencySymbol ?? '\$'}${Helpers.formatTextWithNum(originalPrice.toString())}",
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
                          "${splashProvider.configModel!.currencySymbol ?? '\$'}${Helpers.formatTextWithNum(discountedOnProductPrice.toString())}",
                          style: TextStyle(
                              fontSize: 16,
                              color: ColorResources.getPrimaryColor(context),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
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
