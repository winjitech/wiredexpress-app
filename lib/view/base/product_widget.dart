import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:wired_express/view/screens/product/product_details_screen.dart';

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
        child: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext? context) =>
                        ProductDetailsScreen(productId: product!.id))),
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
                                  '${PriceConverter.convertPrice(context, product!.price, discount: product!.discount, discountType: product!.discountType)}',
                                  style: TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                  PriceConverter.convertPrice(
                                      context, product!.price,
                                      discount: product!.discount,
                                      discountType:
                                      product!.discountType) ==
                                      PriceConverter.convertPrice(
                                          context, product!.price)
                                      ? ""
                                      : '${PriceConverter.convertPrice(context, product!.price)}',
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
