import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'package:wired_express/view/base/rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:wired_express/view/screens/product/product_details_screen.dart';

class CategoryProductWidget extends StatelessWidget {
  final Product? product;
  CategoryProductWidget({@required this.product});

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
      padding: EdgeInsets.only(bottom: 5, top: 5, right: 2, left: 2),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext? context) => ProductDetailsScreen(
                      product: product!,
                    ))),
        child: Container(
            decoration: BoxDecoration(
                color: ColorResources.getScaffoldBackgroundColor(context),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Provider.of<ThemeProvider>(context).darkTheme
                        ? Colors.black.withOpacity(0.4)
                        : Colors.grey[300]!,
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[400]),
                  width: 100,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.network(
                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}',
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
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
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      RatingBar(
                          rating: product!.rating!.length > 0
                              ? double.parse(product!.rating![0].average!)
                              : 0.0,
                          size: 18),
                      Row(
                        children: [
                          Text(
                            PriceConverter.convertPrice(context, product!.price,
                                        discount: product!.discount,
                                        discountType: product!.discountType) ==
                                    PriceConverter.convertPrice(
                                        context, product!.price)
                                ? ""
                                : '${PriceConverter.convertPrice(context, product!.price)}',
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${PriceConverter.convertPrice(context, product!.price, discount: product!.discount, discountType: product!.discountType)}',
                            style: TextStyle(
                                fontSize: 16,
                                color: ColorResources.getScaffoldColor(context),
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Consumer2<WishListProvider, CartProvider>(
                      builder: (context, wishList, cartProvider, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
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
                                : SizedBox()),
                        _isLoggedIn
                            ? Icon(
                                cartProvider.cartIdList.contains(product!.id)
                                    ? Icons.remove
                                    : Icons.add,
                                color: cartProvider.cartIdList
                                        .contains(product!.id)
                                    ? ColorResources.getPrimaryColor(context)
                                    : ColorResources.COLOR_GREY)
                            : SizedBox(),
                      ],
                    );
                  }),
                ),
              ]),
            )),
      ),
    );
  }
}
