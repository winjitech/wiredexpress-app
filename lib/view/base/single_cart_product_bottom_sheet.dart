import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/language_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_divider.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/rating_bar.dart';

class SingleCartProductDetailsBottomSheet extends StatefulWidget {
  final Product? product;
  final bool? fromSetMenu;
  final Function? callback;
  final CartModel? cart;
  final int cartIndex;
  SingleCartProductDetailsBottomSheet(
      {@required this.product,
      this.fromSetMenu = false,
      this.callback,
      this.cart,
      this.cartIndex = 0});

  @override
  State<SingleCartProductDetailsBottomSheet> createState() =>
      _SingleCartProductDetailsBottomSheetState();
}

class _SingleCartProductDetailsBottomSheetState
    extends State<SingleCartProductDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 1), () {});
  }

  @override
  Widget build(BuildContext context) {
    bool fromCart = widget.cart != null;
    fromCart
        ? Provider.of<ProductProvider>(context, listen: false)
            .initCartData(widget.cart!.quantity!, widget.cart!.variationIndex!)
        : Provider.of<ProductProvider>(context, listen: false)
            .initData(widget.product!);

    Variation _variation = Variation();
    String? _image;
    final bool _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    // final String languageStr = getTranslated('set_language', context);
    return Consumer2<CartProvider, ProductProvider>(
        builder: (context, cartProvider, productProvider, child) {
      double? _startingPrice;
      double? _endingPrice;
      if (widget.product!.choiceOptions!.length != 0) {
        List<double> _priceList = [];
        widget.product!.variations!
            .forEach((variation) => _priceList.add(variation.price!));
        _priceList.sort((a, b) => a.compareTo(b));
        _startingPrice = _priceList[0];
        if (_priceList[0] < _priceList[_priceList.length - 1]) {
          _endingPrice = _priceList[_priceList.length - 1];
        }
      } else {
        _startingPrice = widget.product!.price!;
      }

      List<String> _variationList = [];
      for (int index = 0;
          index < widget.product!.choiceOptions!.length;
          index++) {
        _variationList.add(widget.product!.choiceOptions![index]
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

      double price = widget.product!.price!;
      String? _url;
      for (Variation variation in widget.product!.variations!) {
        if (variation.type == variationType) {
          price = variation.price!;
          _variation = variation;
          _image = variation.image;
          _url =
              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/$_image!}';
          break;
        }
      }

      double priceWithDiscount = PriceConverter.convertWithDiscount(context,
          price, widget.product!.discount!, widget.product!.discountType!);

      double priceWithQuantity = priceWithDiscount * productProvider.quantity!;
      double priceWithQuantityWithoutDiscount =
          price * productProvider.quantity!;

      DateTime _currentTime =
          Provider.of<SplashProvider>(context, listen: false).currentTime;
      DateTime _start =
          DateFormat('hh:mm:ss').parse(widget.product!.availableTimeStarts!);
      DateTime _end =
          DateFormat('hh:mm:ss').parse(widget.product!.availableTimeEnds!);
      DateTime _startTime = DateTime(_currentTime.year, _currentTime.month,
          _currentTime.day, _start.hour, _start.minute, _start.second);
      DateTime _endTime = DateTime(_currentTime.year, _currentTime.month,
          _currentTime.day, _end.hour, _end.minute, _end.second);
      if (_endTime.isBefore(_startTime)) {
        _endTime = _endTime.add(Duration(days: 1));
      }
      // bool _isAvailable = _currentTime.isAfter(_startTime) &&
      //     _currentTime.isBefore(_endTime);
      bool _isAvailable = true;

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: ColorResources.getScaffoldBackgroundColor(context),
        ),
        padding: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(),
                child: Row(
                  children: [
                    Text(
                        '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${'${PriceConverter.convertPrice(context, _startingPrice, discount: widget.product!.discount, discountType: widget.product!.discountType)}'
                            '${_endingPrice != null ? ' - ${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(context, _endingPrice, discount: widget.product!.discount, discountType: widget.product!.discountType)}' : ''}'}',
                        style: TextStyle(
                            color: ColorResources.getTextColor(context),
                            fontWeight: FontWeight.normal,
                            fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    SizedBox(width: 20),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          // color: ColorResources.getBackgroundColor(context),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(children: [
                        InkWell(
                          onTap: () {
                            if (productProvider.quantity! > 1) {
                              productProvider.setQuantity(false);
                            }
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                color: ColorResources.SCAFFOLD_COLOR,
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(
                              Icons.remove,
                              size: 20,
                              color: ColorResources.COLOR_WHITE,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(productProvider.quantity.toString(),
                              style: rubikMedium.copyWith(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: ColorResources.getTextColor(context),
                              )),
                        ),
                        InkWell(
                          onTap: () => productProvider.setQuantity(true),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                color: ColorResources.SCAFFOLD_COLOR,
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(
                              Icons.add,
                              size: 20,
                              color: ColorResources.COLOR_WHITE,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  price > priceWithDiscount
                      ? Padding(
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(context, _startingPrice)}'
                            '${_endingPrice != null ? ' - ${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                decoration: TextDecoration.lineThrough),
                          ),
                        )
                      : SizedBox(),
                  Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      RatingBar(
                          rating: widget.product!.rating!.length > 0
                              ? double.parse(
                                  widget.product!.rating![0].average!)
                              : 0.0,
                          size: 18),
                    ],
                  ),
                ],
              ),
              widget.product!.description != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 15, right: 15, top: 15),
                        //   child: ListView.builder(
                        //     itemCount: widget.product!.choiceOptions!.length,
                        //     shrinkWrap: true,
                        //     physics: const NeverScrollableScrollPhysics(),
                        //     itemBuilder: (context, index) {
                        //       return Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Text(
                        //                 widget.product!.choiceOptions![index]
                        //                     .title!,
                        //                 style: rubikMedium.copyWith(
                        //                     color: ColorResources.getTextColor(
                        //                         context),
                        //                     fontSize:
                        //                         Dimensions.FONT_SIZE_LARGE)),
                        //             const SizedBox(
                        //                 height: Dimensions
                        //                     .PADDING_SIZE_EXTRA_SMALL),
                        //             GridView.builder(
                        //               gridDelegate:
                        //                   const SliverGridDelegateWithFixedCrossAxisCount(
                        //                 crossAxisCount: 5,
                        //                 crossAxisSpacing: 0,
                        //                 mainAxisSpacing: 0,
                        //                 childAspectRatio: (0.5 / 0.50),
                        //                 mainAxisExtent: 50,
                        //               ),
                        //               shrinkWrap: true,
                        //               physics:
                        //                   const NeverScrollableScrollPhysics(),
                        //               itemCount: widget
                        //                   .product!
                        //                   .choiceOptions![index]
                        //                   .options!
                        //                   .length,
                        //               itemBuilder: (context, i) {
                        //                 ChoiceOption choiceOption = widget
                        //                     .product!.choiceOptions![index];
                        //                 return Stack(
                        //                   children: [
                        //                     InkWell(
                        //                       onTap: () {
                        //                         productProvider
                        //                             .setCartVariationIndex(
                        //                                 index, i);
                        //                         cartProvider.isExistInCart(
                        //                             widget.product!,
                        //                             productProvider
                        //                                 .variationIndex!);
                        //                       },
                        //                       child: Container(
                        //                         // height: 40,
                        //                         alignment: Alignment.center,
                        //                         // padding: const EdgeInsets
                        //                         //     .symmetric(
                        //                         //     vertical: Dimensions
                        //                         //         .PADDING_SIZE_EXTRA_SMALL,
                        //                         //     horizontal: Dimensions
                        //                         //         .PADDING_SIZE_EXTRA_SMALL),
                        //                         decoration: BoxDecoration(
                        //                           color: choiceOption.title! ==
                        //                                       'Color' ||
                        //                                   choiceOption.title! ==
                        //                                       'color'
                        //                               ? Helpers.selectColor(
                        //                                   choiceOption
                        //                                       .options![i]
                        //                                       .trim())
                        //                               : productProvider
                        //                                               .variationIndex![
                        //                                           index] !=
                        //                                       i
                        //                                   ? ColorResources
                        //                                       .getScaffoldBackgroundColor(
                        //                                           context)
                        //                                   : ColorResources
                        //                                       .SCAFFOLD_COLOR,
                        //                           // borderRadius:
                        //                           //     BorderRadius
                        //                           //         .circular(
                        //                           //             40),
                        //                           border: Border.all(
                        //                               color: Colors.black,
                        //                               width: 0.5),
                        //                           shape: BoxShape.circle,
                        //                         ),
                        //                         child: choiceOption.title! ==
                        //                                 'Color'
                        //                             ? SizedBox()
                        //                             : Text(
                        //                                 choiceOption.options![i]
                        //                                     .trim(),
                        //                                 maxLines: 1,
                        //                                 overflow: TextOverflow
                        //                                     .ellipsis,
                        //                                 style: rubikRegular
                        //                                     .copyWith(
                        //                                   color: productProvider
                        //                                                   .variationIndex![
                        //                                               index] !=
                        //                                           i
                        //                                       ? ColorResources
                        //                                           .getTextColor(
                        //                                               context)
                        //                                       : ColorResources
                        //                                           .getScaffoldBackgroundColor(
                        //                                               context),
                        //                                 ),
                        //                               ),
                        //                       ),
                        //                     ),
                        //                     (choiceOption.title! == 'Color' ||
                        //                                 choiceOption.title! ==
                        //                                     'color') &&
                        //                             productProvider
                        //                                         .variationIndex![
                        //                                     index] ==
                        //                                 i
                        //                         ? Positioned(
                        //                             top: 0,
                        //                             child: Container(
                        //                               // width: 20,
                        //                               // height: 20,
                        //                               child: Center(
                        //                                 child: Icon(
                        //                                   Icons.done_outlined,
                        //                                   color: Colors.white,
                        //                                   size: 20,
                        //                                 ),
                        //                               ),
                        //                               decoration: BoxDecoration(
                        //                                   borderRadius:
                        //                                       BorderRadius
                        //                                           .circular(50),
                        //                                   color: Colors.red),
                        //                             ))
                        //                         : SizedBox()
                        //                   ],
                        //                 );
                        //               },
                        //             ),
                        //             SizedBox(
                        //                 height: index !=
                        //                         widget.product!.choiceOptions!
                        //                                 .length -
                        //                             1
                        //                     ? Dimensions.PADDING_SIZE_LARGE
                        //                     : 0),
                        //           ]);
                        //     },
                        //   ),
                        // ),
                        SizedBox(height: 20),
                        Divider(
                          thickness: 1,
                        ),
                        Text(
                          getTranslated('description', context),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              Consumer(
                  builder: (context, LanguageProvider languageProvider, child) {
                String description = '';
                description = widget.product!.description ?? '';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: ColorResources.getHintColor(context),
                          fontSize: 14),
                    ),
                    widget.product!.description != null
                        ? SizedBox()
                        : SizedBox(),
                  ],
                );
              }),
              Padding(
                padding: const EdgeInsets.only(right: 15, top: 15),
                child: Row(children: [
                  Text('${getTranslated('total_amount', context)}:',
                      style: rubikMedium.copyWith(
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                          color: ColorResources.getTextColor(context))),
                  const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(
                      PriceConverter.convertPrice(context, _startingPrice,
                                  discount: widget.product!.discount,
                                  discountType: widget.product!.discountType) ==
                              PriceConverter.convertPrice(
                                  context, _startingPrice)
                          ? ""
                          : '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(
                          context, priceWithQuantityWithoutDiscount)}',
                      style: TextStyle(
                          color:
                              Provider.of<ThemeProvider>(context, listen: false)
                                      .darkTheme
                                  ? ColorResources.DISABLE_COLOR
                                  : ColorResources.COLOR_GREY,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough)),
                  const SizedBox(width: 1),
                  Text('${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(context, priceWithQuantity)}',
                      style: rubikBold.copyWith(
                        color: ColorResources.SCAFFOLD_COLOR,
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                      )),
                ]),
              ),
              SizedBox(
                height: 5,
              ),
              cartProvider.cartLoading == false
                  ? Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 30, bottom: 5),
                        child: CustomButton(
                          text: getTranslated('update_in_cart', context),
                          backgroundColor:
                              ColorResources.getPrimaryColor(context),
                          onTap: () {
                            int cartId = 0;
                            if (cartProvider.existInCart) {
                              cartId = cartProvider.matchedCartId!;
                            }

                            CartModel _cartModel = CartModel(
                                id: cartId,
                                productId: widget.product!.id,
                                product: widget.product,
                                quantity: productProvider.quantity,
                                variationIndex: productProvider.variationIndex);
                            cartProvider
                                .addToCartList(_cartModel, (message) {})
                                .then((value) {
                              cartProvider.initCartList(context);
                              cartProvider.initCartListProductIds(context);
                              showCustomSnackBar(
                                  getTranslated(
                                      'updated_successfully', context),
                                  context,
                                  isError: false);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        child: MaterialButton(
                          onPressed: () {
                            int cartId = 0;
                            if (cartProvider.existInCart) {
                              cartId = cartProvider.matchedCartId!;
                            }

                            cartProvider
                                .removeFromCartList(
                                    cartId, widget.product!.id!, (message) {})
                                .then((value) {
                              cartProvider.initCartList(context);
                              cartProvider.initCartListProductIds(context);
                              showCustomSnackBar(
                                  getTranslated(
                                      'delete_from_cart_successful', context),
                                  context,
                                  isError: false);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                          color: Colors.transparent,
                          elevation: 0,
                          minWidth: MediaQuery.of(context).size.width,
                          height: 50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: ColorResources.SCAFFOLD_COLOR,
                            ),
                          ),
                          child:
                              Text(getTranslated('delete_from_cart', context),
                                  style: TextStyle(
                                    color: ColorResources.SCAFFOLD_COLOR,
                                  )),
                        ),
                      ),
                    ])
                  : Padding(
                    padding: const EdgeInsets.all(25),
                    child: Center(
                        child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            ColorResources.SCAFFOLD_COLOR),
                      )),
                  ),
            ],
          ),
        ),
      );
    });
  }
}
