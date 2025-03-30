import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/language_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/rating_bar.dart';
import 'package:wired_express/view/screens/home/widget/image_preview.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CartBottomSheet extends StatelessWidget {
  final Product? product;
  final bool? fromSetMenu;
  final Function? callback;
  final CartModel? cart;
  final int cartIndex;
  CartBottomSheet(
      {@required this.product,
        this.fromSetMenu = false,
        this.callback,
        this.cart,
        this.cartIndex = 0});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool fromCart = cart != null;

    // fromCart?
    // Provider.of<ProductProvider>(context, listen: false)
    //     .initDataWithCart(product!, cart!) : Provider.of<ProductProvider>(context, listen: false)
    //     .initData(product!);
    Variation _variation = Variation();
    String? _image;

    return Stack(
      children: [
        Container(
          width: 550,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: ResponsiveHelper.isMobile(context)? BorderRadius.only(topLeft:
            Radius.circular(20),topRight: Radius.circular(20)): BorderRadius.all(Radius.circular(20)),
          ),
          child: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              double? _startingPrice;
              double? _endingPrice;
              if (product!.choiceOptions!.length != 0) {
                List<double> _priceList = [];
                product!.variations!.forEach((variation) => _priceList.add(variation.price!));
                _priceList.sort((a, b) => a.compareTo(b));
                _startingPrice = _priceList[0];
                if (_priceList[0] < _priceList[_priceList.length - 1]) {
                  _endingPrice = _priceList[_priceList.length - 1];
                }
              } else {
                _startingPrice = product!.price!;
              }

              List<String> _variationList = [];
              for (int index = 0;
              index < product!.choiceOptions!.length;
              index++) {
                _variationList.add(product!.choiceOptions![index]
                    .options![productProvider.variationIndex![index]]
                    .replaceAll(' ', ''));
              }
              String variationType = '';
              bool isFirst = true;
              _variationList.forEach((variation) {
                if (isFirst) {
                  variationType = '$variationType$variation';
                  isFirst = false;
                } else {
                  variationType = '$variationType-$variation';
                }
              });

              double price = product!.price!;
              String? _url;
              for (Variation variation in product!.variations!) {
                if (variation.type == variationType) {
                  price = variation.price!;
                  _variation = variation;
                  _image = variation.image;
                  _url = '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/$_image!}';
                  break;
                }
              }

              double priceWithDiscount = PriceConverter.convertWithDiscount(
                  context, price, product!.discount!, product!.discountType!);
              double priceWithQuantity =
                  priceWithDiscount * productProvider.quantity!;

              DateTime _currentTime =
                  Provider.of<SplashProvider>(context, listen: false)
                      .currentTime;
              DateTime _start =
              DateFormat('hh:mm:ss').parse(product!.availableTimeStarts!);
              DateTime _end =
              DateFormat('hh:mm:ss').parse(product!.availableTimeEnds!);
              DateTime _startTime = DateTime(
                  _currentTime.year,
                  _currentTime.month,
                  _currentTime.day,
                  _start.hour,
                  _start.minute,
                  _start.second);
              DateTime _endTime = DateTime(
                  _currentTime.year,
                  _currentTime.month,
                  _currentTime.day,
                  _end.hour,
                  _end.minute,
                  _end.second);
              if (_endTime.isBefore(_startTime)) {
                _endTime = _endTime.add(Duration(days: 1));
              }
              // bool _isAvailable = _currentTime.isAfter(_startTime) &&
              //     _currentTime.isBefore(_endTime);
             bool _isAvailable=true;

              // CartModel _cartModel = CartModel(
              //   price,
              //   priceWithDiscount,
              //   [_variation],
              //   (price -
              //       PriceConverter.convertWithDiscount(context, price,
              //           product!.discount!, product!.discountType!)),
              //   productProvider.quantity,
              //   price -
              //       PriceConverter.convertWithDiscount(
              //           context, price, product!.tax!, product!.taxType!),
              //
              //   product!,
              // );
              bool isExistInCart = true;

              return SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Product
                      Row(children: [
                        _image==null?
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                String url =
                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}';
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImagePreview(imageURL: url)));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder_rectangle,
                                  image:
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}',
                                  width: ResponsiveHelper.isMobile(context)
                                      ? 150
                                      : ResponsiveHelper.isTab(context)
                                      ? 140
                                      : ResponsiveHelper.isDesktop(context)
                                      ? 140
                                      : null,
                                  height: ResponsiveHelper.isMobile(context)
                                      ? 150
                                      : ResponsiveHelper.isTab(context)
                                      ? 140
                                      : ResponsiveHelper.isDesktop(context)
                                      ? 140
                                      : null,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            product!.availability == 'low'?
                            Text(getTranslated('low_availability', context), style: TextStyle(fontSize: 12, color: Colors.deepOrange)) : SizedBox(),
                          ],
                        ) :
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                String url =
                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/$_image';
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImagePreview(imageURL: url)));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: _url !=null?
                                Container(
                                  height: 150,
                                  width: 150,
                                  child: Image.network('${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/$_image',fit: BoxFit.cover,
                                    loadingBuilder:(BuildContext? context, Widget? child,ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child!;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null ?
                                          loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                )
                                : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ColorResources.getPrimaryColor(context)))),
                              ),
                            ),
                            product!.availability == 'low'?
                            Text(getTranslated('low_availability', context), style: TextStyle(fontSize: 12, color: Colors.deepOrange)) : SizedBox(),
                          ],
                        ),

                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(
                                              '${product!.name}',
                                              style: TextStyle(fontSize: 13)),
                                          actions: [

                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    '${product!.name}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: rubikMedium.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                  ),
                                ),
                                if(product!.matchedTag != null && product!.matchedTag != '')
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                if(product!.matchedTag != null && product!.matchedTag != '')
                                  Text(product!.matchedTag ?? '', style: giftFont.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                                SizedBox(height: 10),
                                RatingBar(
                                    rating: product!.rating!.length > 0
                                        ? double.parse(
                                        product!.rating![0].average!)
                                        : 0.0,
                                    size: 15),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(context, _startingPrice, discount: product!.discount, discountType: product!.discountType)}'
                                          '${_endingPrice != null ? ' - ${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(context, _endingPrice, discount: product!.discount, discountType: product!.discountType)}' : ''}',
                                      style: rubikMedium.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_LARGE),
                                    ),
                                    price == priceWithDiscount
                                        ? Consumer<WishListProvider>(builder:
                                        (context, wishList, child) {
                                      return InkWell(
                                        onTap: () {
                                          wishList.wishIdList
                                              .contains(product!.id)
                                              ? wishList
                                              .removeFromWishList(
                                              product!,
                                                  (message) {
                                              })
                                              : wishList.addToWishList(
                                              product!, (message) {
                                          });
                                        },
                                        child: Icon(
                                          wishList.wishIdList.contains(product!.id)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: wishList.wishIdList.contains(product!.id)
                                              ? ColorResources.getPrimaryColor(context)
                                              : ColorResources.COLOR_GREY,
                                        ),
                                      );
                                    })
                                        : SizedBox(),
                                  ],
                                ),
                                SizedBox(height: 5),
                                price > priceWithDiscount
                                    ? Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(context, _startingPrice)}'
                                            '${_endingPrice != null ? ' - ${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                                        style: rubikMedium.copyWith(
                                            color: Provider.of<ThemeProvider>(context,
                                                listen:
                                                false)
                                                .darkTheme
                                                ? ColorResources
                                                .DISABLE_COLOR
                                                : ColorResources
                                                .COLOR_GREY,
                                            decoration: TextDecoration
                                                .lineThrough),
                                      ),
                                      Consumer<WishListProvider>(builder:
                                          (context, wishList, child) {
                                        return InkWell(
                                          onTap: () {
                                            wishList.wishIdList
                                                .contains(product!.id)
                                                ? wishList
                                                .removeFromWishList(
                                                product!,
                                                    (message) {})
                                                : wishList.addToWishList(
                                                product!,
                                                    (message) {});

                                          },
                                          child: Icon(
                                            wishList.wishIdList.contains(product!.id)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: wishList.wishIdList.contains(product!.id)
                                                ? ColorResources.getPrimaryColor(context)
                                                : ColorResources.COLOR_GREY,
                                          ),
                                        );
                                      }),
                                    ])
                                    : SizedBox(),
                              ]),
                        ),
                      ]),

                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      // Quantity
                      Row(children: [
                        Text(getTranslated('quantity', context),
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE)),
                        Expanded(child: SizedBox()),
                        Container(
                          decoration: BoxDecoration(
                              color: ColorResources.getBackgroundColor(context),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(children: [
                            InkWell(
                              onTap: () {
                                if (productProvider.quantity !> 1) {
                                  productProvider.setQuantity(false);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                                    vertical:
                                    Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Icon(Icons.remove, size: 20),
                              ),
                            ),
                            Text(productProvider.quantity.toString(),
                                style: rubikMedium.copyWith(
                                    fontSize:
                                    Dimensions.FONT_SIZE_EXTRA_LARGE)),

                            InkWell(
                              onTap: () => productProvider.setQuantity(true),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                                    vertical:
                                    Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Icon(Icons.add, size: 20),
                              ),
                            ),
                          ]),
                        ),
                      ]),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      // Variation
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: product!.choiceOptions!.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product!.choiceOptions![index].title!,
                                    style: rubikMedium.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                SizedBox(
                                    height:
                                    Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                GridView.builder(
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: (1 / 0.25),
                                  ),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: product
                                      !.choiceOptions![index].options!.length,
                                  itemBuilder: (context, i) {
                                    return InkWell(
                                      onTap: () {
                                        productProvider.setCartVariationIndex(
                                            index, i);
                                        Provider.of<CartProvider>(context, listen: false).isExistInCart(
                                            product!, productProvider.variationIndex!);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                        decoration: BoxDecoration(
                                          color: productProvider
                                              .variationIndex![index] !=
                                              i
                                              ? ColorResources.BACKGROUND_COLOR
                                              : ColorResources.getPrimaryColor(context),
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          border: productProvider
                                              .variationIndex![index] !=
                                              i
                                              ? Border.all(
                                              color: ColorResources
                                                  .BORDER_COLOR,
                                              width: 2)
                                              : null,
                                        ),
                                        child: Text(
                                          product!.choiceOptions![index].options![i]
                                              .trim(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: rubikRegular.copyWith(
                                            color: productProvider
                                                .variationIndex![
                                            index] !=
                                                i
                                                ? ColorResources.COLOR_BLACK
                                                : ColorResources.COLOR_WHITE,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                    height: index !=
                                        product!.choiceOptions!.length - 1
                                        ? Dimensions.PADDING_SIZE_LARGE
                                        : 0),
                              ]);
                        },
                      ),
                      product!.choiceOptions!.length > 0
                          ? SizedBox(height: Dimensions.PADDING_SIZE_LARGE)
                          : SizedBox(),


                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            product!.description != null ?
                            Text(getTranslated('description', context),
                                style: rubikMedium.copyWith(
                                    fontSize:
                                    Dimensions.FONT_SIZE_LARGE)) : SizedBox(),
                            SizedBox(
                                height:
                                Dimensions.PADDING_SIZE_EXTRA_SMALL),

                            Consumer(builder: (context,
                                LanguageProvider languageProvider, child) {
                              String description = '';
                              description = product!.description ?? '';
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(description, style: rubikRegular, maxLines: 4),
                                  product!.description != null?
                                  product!.description!.length > 200 ?
                                  GestureDetector(
                                      onTap:(){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Text(
                                                  description,
                                                  style: TextStyle(fontSize: 10)),
                                              actions: [

                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text(getTranslated('see_more', context), style: TextStyle(color: ColorResources.getPrimaryColor(context)))) : SizedBox() : SizedBox(),
                                ],
                              );
                            }),
                         //   Text('${product.description.length}'),

                            SizedBox(
                                height: Dimensions.PADDING_SIZE_LARGE),

                          ]),

                      Row(children: [
                        Text('${getTranslated('total_amount', context)}:',
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE)),
                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Text(
                            '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(
                                context, priceWithQuantity)}',
                            style: rubikBold.copyWith(
                              color: ColorResources.getPrimaryColor(context),
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                            )),
                      ]),

                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),



                      CustomButton(text: getTranslated('add_to_cart', context), onTap: () {

                      }),


                      // _isAvailable
                      //     ? CustomButton(
                      //   text: getTranslated(
                      //       isExistInCart
                      //           ? 'already_added_in_cart'
                      //           : fromCart
                      //           ? 'update_in_cart'
                      //           : 'add_to_cart',
                      //       context),
                      //   backgroundColor: Theme.of(context).primaryColor,
                      //   onTap: (!isExistInCart)
                      //       ? () {
                      //     if (!isExistInCart) {
                      //       Navigator.pop(context); Provider.of<CartProvider>(context,
                      //           listen: false)
                      //           .addToCartList(product!, (message) {});
                      //       Provider.of<CartProvider>(context,
                      //           listen: false)
                      //           .addToCart(_cartModel, cartIndex, fromCart);
                      //       callback!(_cartModel);
                      //     }
                      //   }
                      //       : null,
                      // )
                      //     : Container(
                      //   alignment: Alignment.center,
                      //   padding:
                      //   EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(10),
                      //     color: Theme.of(context)
                      //         .primaryColor
                      //         .withOpacity(0.1),
                      //   ),
                      //   child: Column(children: [
                      //     Text(
                      //         getTranslated('not_available_now', context),
                      //         style: rubikMedium.copyWith(
                      //           color: Theme.of(context).primaryColor,
                      //           fontSize: Dimensions.FONT_SIZE_LARGE,
                      //         )),
                      //     Text(
                      //       '${getTranslated('available_will_be', context)} ${DateConverter.convertTimeToTime(product!.availableTimeStarts!)} '
                      //           '- ${DateConverter.convertTimeToTime(product!.availableTimeEnds!)}',
                      //       style: rubikRegular,
                      //     ),
                      //   ]),
                      // ),
                    ]),
              );
            },
          ),
        ),
        ResponsiveHelper.isMobile(context)? SizedBox():  Positioned(
          right: 10,
          top: 5,
          child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close)),
        ),
      ],
    );
  }
}
