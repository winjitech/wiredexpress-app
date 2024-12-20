// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:wired_express/data/model/response/cart_model.dart';
// import 'package:wired_express/data/model/response/product_model.dart';
// import 'package:wired_express/data/model/response/wishlist_model.dart';
// import 'package:wired_express/helper/date_converter.dart';
// import 'package:wired_express/helper/price_converter.dart';
// import 'package:wired_express/helper/responsive_helper.dart';
// import 'package:wired_express/localization/language_constrants.dart';
// import 'package:wired_express/provider/auth_provider.dart';
// import 'package:wired_express/provider/cart_provider.dart';
// import 'package:wired_express/provider/product_provider.dart';
// import 'package:wired_express/provider/splash_provider.dart';
// import 'package:wired_express/provider/theme_provider.dart';
// import 'package:wired_express/provider/wishlist_provider.dart';
// import 'package:wired_express/utill/app_constants.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:wired_express/utill/dimensions.dart';
// import 'package:wired_express/utill/images.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:wired_express/view/base/rating_bar.dart';
// import 'package:wired_express/view/screens/home/widget/cart_bottom_sheet.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:wired_express/view/screens/product/product_details_screen.dart';
//
// class ProductWidget extends StatelessWidget {
//   final Product? product;
//   ProductWidget({@required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     final bool _isLoggedIn =
//         Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
//     final cart = Provider.of<CartProvider>(context, listen: false);
//     final productProvider =
//         Provider.of<ProductProvider>(context, listen: false);
//
//     double _startingPrice;
//     double? _endingPrice;
//     if (product!.choiceOptions!.length != 0) {
//       List<double> _priceList = [];
//       product!.variations!
//           .forEach((variation) => _priceList.add(variation.price!));
//       _priceList.sort((a, b) => a.compareTo(b));
//       _startingPrice = _priceList[0];
//       if (_priceList[0] < _priceList[_priceList.length - 1]) {
//         _endingPrice = _priceList[_priceList.length - 1];
//       }
//     } else {
//       _startingPrice = product!.price!;
//     }
//
//     double _discountedPrice = PriceConverter.convertWithDiscount(
//         context, product!.price!, product!.discount!, product!.discountType!);
//
//     DateTime _currentTime =
//         Provider.of<SplashProvider>(context, listen: false).currentTime;
//     DateTime _start =
//         DateFormat('hh:mm:ss').parse(product!.availableTimeStarts!);
//     DateTime _end = DateFormat('hh:mm:ss').parse(product!.availableTimeEnds!);
//     DateTime _startTime = DateTime(_currentTime.year, _currentTime.month,
//         _currentTime.day, _start.hour, _start.minute, _start.second);
//     DateTime _endTime = DateTime(_currentTime.year, _currentTime.month,
//         _currentTime.day, _end.hour, _end.minute, _end.second);
//     if (_endTime.isBefore(_startTime)) {
//       _endTime = _endTime.add(Duration(days: 1));
//     }
//     bool _isAvailable = DateConverter.isAvailable(
//         product!.availableTimeStarts!, product!.availableTimeEnds!, context);
//     _isAvailable = true;
//     return Padding(
//       padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
//       child: InkWell(
//         onTap: () {
//           Provider.of<ProductProvider>(context, listen: false)
//               .initData(product!);
//
//           Provider.of<CartProvider>(context, listen: false)
//               .isExistInCart(product!, productProvider.variationIndex!);
//           ResponsiveHelper.isMobile(context)
//               ? Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (BuildContext? context) => ProductDetailsScreen(
//                             product: product!,
//                             callback: (CartModel cartModel) {
//                               ScaffoldMessenger.of(context!).showSnackBar(
//                                   SnackBar(
//                                       content: Text(getTranslated(
//                                           'added_to_cart', context)),
//                                       backgroundColor: Colors.green));
//                             },
//                           )))
//               : showDialog(
//                   context: context,
//                   builder: (con) => Dialog(
//                         child: CartBottomSheet(
//                           product: product!,
//                           callback: (CartModel cartModel) {
//                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                 content: Text(
//                                     getTranslated('added_to_cart', context)),
//                                 backgroundColor: Colors.green));
//                           },
//                         ),
//                       ));
//         },
//         child: Container(
//           height: 106,
//           padding: EdgeInsets.symmetric(
//               vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
//               horizontal: Dimensions.PADDING_SIZE_SMALL),
//           decoration: BoxDecoration(
//               color: ColorResources.getScaffoldBackgroundColor(context),
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Provider.of<ThemeProvider>(context).darkTheme
//                       ? Colors.black.withOpacity(0.4)
//                       : Colors.grey[300]!,
//                   blurRadius: 5,
//                   spreadRadius: 1,
//                 )
//               ]),
//           child: Row(children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: FadeInImage.assetNetwork(
//                     placeholder: Images.placeholder_image,
//                     placeholderErrorBuilder: (BuildContext? context,
//                         Object? exception, StackTrace? stackTrace) {
//                       return Image.asset(
//                         Images.placeholder_image,
//                         height: 70,
//                         width: 85,
//                         fit: BoxFit.cover,
//                       );
//                     },
//                     imageErrorBuilder: (BuildContext? context,
//                         Object? exception, StackTrace? stackTrace) {
//                       return Image.asset(
//                         Images.placeholder_image,
//                         height: 70,
//                         width: 85,
//                         fit: BoxFit.cover,
//                       );
//                     },
//                     image:
//                         '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}',
//                     height: 115,
//                     width: 125,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 _isAvailable
//                     ? SizedBox()
//                     : Positioned(
//                         top: 0,
//                         left: 0,
//                         bottom: 0,
//                         right: 0,
//                         child: Container(
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.black.withOpacity(0.6)),
//                           child: Text(
//                               getTranslated('not_available_now_break', context),
//                               textAlign: TextAlign.center,
//                               style: rubikRegular.copyWith(
//                                 color: Colors.white,
//                                 fontSize: 8,
//                               )),
//                         ),
//                       ),
//               ],
//             ),
//             SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
//             Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('${product!.name}',
//                         style: rubikMedium.copyWith(
//                             color: ColorResources.getTextColor(context)),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis),
//                     SizedBox(height: 5),
//                     RatingBar(
//                         rating: product!.rating!.length > 0
//                             ? double.parse(product!.rating![0].average!)
//                             : 0.0,
//                         size: 10),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Text(
//                       '${PriceConverter.convertPrice(context, _startingPrice, discount: product!.discount, discountType: product!.discountType, asFixed: 1)}'
//                       '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product!.discount, discountType: product!.discountType, asFixed: 1)}' : ''}',
//                       style: rubikMedium.copyWith(
//                           color: ColorResources.getTextColor(context),
//                           fontSize: Dimensions.FONT_SIZE_SMALL),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     product!.price! > _discountedPrice
//                         ? Text(
//                             '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}$_startingPrice'
//                             '${_endingPrice != null ? ' - ${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}$_endingPrice' : ''}',
//                             style: rubikMedium.copyWith(
//                               color: Provider.of<ThemeProvider>(context,
//                                           listen: false)
//                                       .darkTheme
//                                   ? ColorResources.DISABLE_COLOR
//                                   : ColorResources.COLOR_GREY,
//                               decoration: TextDecoration.lineThrough,
//                               fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
//                             ))
//                         : SizedBox(),
//                   ]),
//             ),
//             Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//               Consumer<WishListProvider>(builder: (context, wishList, child) {
//                 return IconButton(
//                   onPressed: () {
//                     wishList.wishIdList.contains(product!.id)
//                         ? wishList.removeFromWishList(product!, (message) {})
//                         : wishList.addToWishList(product!, (message) {});
//                   },
//                   icon: _isLoggedIn
//                       ? Icon(
//                           wishList.wishIdList.contains(product!.id)
//                               ? Icons.favorite
//                               : Icons.favorite_border,
//                           color: wishList.wishIdList.contains(product!.id)
//                               ? ColorResources.getPrimaryColor(context)
//                               : ColorResources.COLOR_GREY,
//                         )
//                       : SizedBox(),
//                 );
//               }),
//               Expanded(child: SizedBox()),
//               Consumer<CartProvider>(builder: (context, cartProvider, child) {
//                 return IconButton(
//                   onPressed: () {
//                     // int cartId = 0;
//                     // if (cartProvider.existInCart) {
//                     //   cartId = cartProvider.matchedCartId!;
//                     // }
//                     // CartModel _cartModel = CartModel(
//                     //     id: cartId,
//                     //     productId: product!.id,
//                     //     product: product,
//                     //     quantity: productProvider.quantity,
//                     //     variationIndex: productProvider.variationIndex);
//                     // if (cartProvider.cartIdList.contains(product!.id)) {
//                     //   cartProvider.removeFromCartList(
//                     //       _cartModel.id!, _cartModel.productId!, (message) {});
//                     //   // cart.removeFromCart(_cartModel);
//                     // } else {
//                     //   cartProvider.addToCartList(_cartModel, (message) {});
//                     // }
//                   },
//                   icon: _isLoggedIn
//                       ? Icon(
//                           cartProvider.cartIdList.contains(product!.id)
//                               ? Icons.remove
//                               : Icons.add,
//                           color: cartProvider.cartIdList.contains(product!.id)
//                               ? ColorResources.getPrimaryColor(context)
//                               : ColorResources.COLOR_GREY,
//                         )
//                       : const SizedBox(),
//                 );
//               }),
//             ]),
//           ]),
//         ),
//       ),
//     );
//   }
// }
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/wishlist_model.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/rating_bar.dart';
import 'package:wired_express/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:wired_express/view/screens/product/product_details_screen.dart';
import 'package:wired_express/view/screens/signle_product_screen/single_product_screen.dart';

class ProductWidget extends StatelessWidget {
  final Product? product;
  ProductWidget({@required this.product});

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    final cart = Provider.of<CartProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    double _startingPrice;
    double? _endingPrice;
    if (product!.choiceOptions!.length != 0) {
      List<double> _priceList = [];
      product!.variations!
          .forEach((variation) => _priceList.add(variation.price!));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if (_priceList[0] < _priceList[_priceList.length - 1]) {
        _endingPrice = _priceList[_priceList.length - 1];
      }
    } else {
      _startingPrice = product!.price!;
    }

    double _discountedPrice = PriceConverter.convertWithDiscount(
        context, product!.price!, product!.discount!, product!.discountType!);

    DateTime _currentTime =
        Provider.of<SplashProvider>(context, listen: false).currentTime;
    DateTime _start =
        DateFormat('hh:mm:ss').parse(product!.availableTimeStarts!);
    DateTime _end = DateFormat('hh:mm:ss').parse(product!.availableTimeEnds!);
    DateTime _startTime = DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, _start.hour, _start.minute, _start.second);
    DateTime _endTime = DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, _end.hour, _end.minute, _end.second);
    if (_endTime.isBefore(_startTime)) {
      _endTime = _endTime.add(Duration(days: 1));
    }
    bool _isAvailable = DateConverter.isAvailable(
        product!.availableTimeStarts!, product!.availableTimeEnds!, context);
    _isAvailable = true;
    return Padding(
        padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        child: InkWell(
            onTap: () {
              Provider.of<ProductProvider>(context, listen: false)
                  .initData(product!);

              Provider.of<CartProvider>(context, listen: false)
                  .isExistInCart(product!, productProvider.variationIndex!);
              ResponsiveHelper.isMobile(context)
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext? context) =>
                              SingleProductScreen(
                                product: product!,
                                callback: (CartModel cartModel) {
                                  ScaffoldMessenger.of(context!).showSnackBar(
                                      SnackBar(
                                          content: Text(getTranslated(
                                              'added_to_cart', context)),
                                          backgroundColor: Colors.green));
                                },
                              )))
                  : showDialog(
                      context: context,
                      builder: (con) => Dialog(
                            child: CartBottomSheet(
                              product: product!,
                              callback: (CartModel cartModel) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(getTranslated(
                                            'added_to_cart', context)),
                                        backgroundColor: Colors.green));
                              },
                            ),
                          ));
            },
            child: Container(
                decoration: BoxDecoration(
                  color: ColorResources.getScaffoldBackgroundColor(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  Stack(children: [
                    Container(
                        height: 170,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Provider.of<ThemeProvider>(context).darkTheme
                                    ? Colors.black.withOpacity(0.4)
                                    : Colors.grey[300]!,
                                blurRadius: 5,
                                spreadRadius: 1,
                              )
                            ],
                            color: Colors.white),
                        child: FadeInImage.assetNetwork(
                            placeholder: Images.loading,
                            placeholderErrorBuilder: (BuildContext? context,
                                Object? exception, StackTrace? stackTrace) {
                              return Image.asset(Images.loading_icon,
                                  height: 70, width: 85, fit: BoxFit.cover);
                            },
                            imageErrorBuilder: (BuildContext? context,
                                Object? exception, StackTrace? stackTrace) {
                              return Image.asset(Images.loading_icon,
                                  height: 70, width: 85, fit: BoxFit.cover);
                            },
                            image:
                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}')),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Consumer<WishListProvider>(
                            builder: (context, wishList, child) {
                          return IconButton(
                              onPressed: () {
                                wishList.wishIdList.contains(product!.id)
                                    ? wishList.removeFromWishList(
                                        product!, (message) {})
                                    : wishList.addToWishList(
                                        product!, (message) {});
                              },
                              icon: _isLoggedIn
                                  ? Icon(
                                      wishList.wishIdList.contains(product!.id)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: wishList.wishIdList
                                              .contains(product!.id)
                                          ? ColorResources.getPrimaryColor(
                                              context)
                                          : ColorResources.COLOR_GREY)
                                  : SizedBox());
                        }))
                  ]),
                  SizedBox(height: 5),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(product!.name!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15))),
                            SizedBox(
                              width: 5,
                            ),
                            Column(children: [
                              Text(
                                  '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(context, _startingPrice, discount: product!.discount, discountType: product!.discountType)}',
                                  style: TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                  PriceConverter.convertPrice(
                                              context, _startingPrice,
                                              discount: product!.discount,
                                              discountType:
                                                  product!.discountType) ==
                                          PriceConverter.convertPrice(
                                              context, _startingPrice)
                                      ? ""
                                      : '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(context, _startingPrice)}',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough))
                            ])
                          ]))
                ]))));
  }
}
