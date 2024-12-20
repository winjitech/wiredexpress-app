import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/rating_bar.dart';
import 'package:wired_express/view/base/single_product_bottom_sheet.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';
import 'package:wired_express/view/screens/home/widget/image_preview.dart';

class SingleProductScreen extends StatefulWidget {
  final Product? product;
  final bool? fromSetMenu;
  final Function? callback;
  final CartModel? cart;
  final int cartIndex;
  SingleProductScreen(
      {@required this.product,
      this.fromSetMenu = false,
      this.callback,
      this.cart,
      this.cartIndex = 0});
  @override
  _SingleProductScreenState createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () async {});
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
    return Scaffold(
        // backgroundColor: Colors.grey[400],
        appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          leading: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8),
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50)),
                      child: const Padding(
                        padding: EdgeInsets.all(14),
                        child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: ColorResources.SCAFFOLD_COLOR,
                          size: 19,
                        ),
                      )),
                ),
              ),
            ),
          ),
          backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
        ),
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
        key: _scaffoldKey,
        body: Consumer<CartProvider>(builder: (context, cartProvider, child) {
          return Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
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

              double priceWithDiscount = PriceConverter.convertWithDiscount(
                  context,
                  price,
                  widget.product!.discount!,
                  widget.product!.discountType!);

              double priceWithQuantity =
                  priceWithDiscount * productProvider.quantity!;
              double priceWithQuantityWithoutDiscount =
                  price * productProvider.quantity!;

              DateTime _currentTime =
                  Provider.of<SplashProvider>(context, listen: false)
                      .currentTime;
              DateTime _start = DateFormat('hh:mm:ss')
                  .parse(widget.product!.availableTimeStarts!);
              DateTime _end = DateFormat('hh:mm:ss')
                  .parse(widget.product!.availableTimeEnds!);
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
                _endTime = _endTime.add(const Duration(days: 1));
              }

              bool _isAvailable = true;

              return Scrollbar(
                child: SingleChildScrollView(
                  child: Center(
                      child: Column(
                    children: [
                      Column(
                        children: [
                          // SafeArea(
                          //   child: Align(
                          //     alignment: Alignment.topLeft,
                          //     child: Padding(
                          //       padding:
                          //           const EdgeInsets.only(top: 10, left: 15),
                          //       child: InkWell(
                          //         onTap: () {
                          //           Navigator.pop(context);
                          //         },
                          //         child: Container(
                          //             decoration: BoxDecoration(
                          //                 color: Colors.grey[400],
                          //                 borderRadius:
                          //                     BorderRadius.circular(50)),
                          //             child: Padding(
                          //               padding: const EdgeInsets.all(14),
                          //               child: Icon(
                          //                 Icons.arrow_back_ios_new_outlined,
                          //                 color: ColorResources.SCAFFOLD_COLOR,
                          //                 size: 19,
                          //               ),
                          //             )),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Consumer<WishListProvider>(
                                builder: (context, wishList, child) {
                              return IconButton(
                                onPressed: () {
                                  wishList.wishIdList
                                          .contains(widget.product!.id)
                                      ? wishList.removeFromWishList(
                                          widget.product!, (message) {})
                                      : wishList.addToWishList(
                                          widget.product!, (message) {});
                                },
                                icon: _isLoggedIn
                                    ? Icon(
                                        wishList.wishIdList
                                                .contains(widget.product!.id)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: wishList.wishIdList
                                                .contains(widget.product!.id)
                                            ? ColorResources.getPrimaryColor(
                                                context)
                                            : Colors.grey[200],
                                      )
                                    : const SizedBox(),
                              );
                            }),
                          ),
                          InkWell(
                            onTap: () {
                              String url =
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${widget.product!.image}';
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ImagePreview(imageURL: url)));
                            },
                            child: Image.network(
                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${widget.product!.image}',
                              fit: BoxFit.cover,
                              height: 300,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   'Smartwatch',
                                  //   style: TextStyle(
                                  //       color: Colors.white70, fontSize: 16),
                                  // ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.product!.name!,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(
                                              color: Colors.black45,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   width: 15,
                                      // ),
                                      // Text(
                                      //   Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol +
                                      //       widget.product!.price!.toString(),
                                      //   style: TextStyle(
                                      //       color: Colors.grey[200],
                                      //       fontWeight: FontWeight.bold,
                                      //       fontSize: 20),
                                      // )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(),
                                    child: Row(
                                      children: [
                                        Text(
                                            '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${'${PriceConverter.convertPrice(context, _startingPrice, discount: widget.product!.discount, discountType: widget.product!.discountType)}'
                                                '${_endingPrice != null ? ' - ${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(context, _endingPrice, discount: widget.product!.discount, discountType: widget.product!.discountType)}' : ''}'}',
                                            style: TextStyle(
                                                color:
                                                    ColorResources.getTextColor(
                                                        context),
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                        const SizedBox(width: 20),
                                        const Spacer(),
                                        Container(
                                          decoration: BoxDecoration(
                                              // color: ColorResources.getBackgroundColor(context),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(children: [
                                            InkWell(
                                              onTap: () {
                                                if (productProvider.quantity! >
                                                    1) {
                                                  productProvider
                                                      .setQuantity(false);
                                                }
                                              },
                                              child: Container(
                                                  width: 25,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      color: ColorResources
                                                          .SCAFFOLD_COLOR,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  child: const Icon(Icons.remove,
                                                      size: 20,
                                                      color: ColorResources
                                                          .COLOR_WHITE)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                  productProvider.quantity
                                                      .toString(),
                                                  style: rubikMedium.copyWith(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w500,
                                                    color: ColorResources
                                                        .getTextColor(context),
                                                  )),
                                            ),
                                            InkWell(
                                              onTap: () => productProvider
                                                  .setQuantity(true),
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    color: ColorResources
                                                        .SCAFFOLD_COLOR,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: ColorResources
                                                      .COLOR_WHITE,
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      price > priceWithDiscount
                                          ? Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Text(
                                                '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(context, _startingPrice)}'
                                                '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                                                style: const TextStyle(
                                                    color: Colors.black45,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 16,
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              ),
                                            )
                                          : const SizedBox(),
                                      Column(
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          RatingBar(
                                              rating: widget.product!.rating!
                                                          .length >
                                                      0
                                                  ? double.parse(widget.product!
                                                      .rating![0].average!)
                                                  : 0.0,
                                              size: 18),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 15, right: 15, top: 0),
                                  //   child: ListView.builder(
                                  //     shrinkWrap: true,
                                  //     itemCount:
                                  //         widget.product!.choiceOptions!.length,
                                  //     physics:
                                  //         const NeverScrollableScrollPhysics(),
                                  //     itemBuilder: (context, index) {
                                  //       return Column(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.start,
                                  //           children: [
                                  //             Text(
                                  //                 widget
                                  //                     .product!
                                  //                     .choiceOptions![index]
                                  //                     .title!,
                                  //                 style: rubikMedium.copyWith(
                                  //                     color: ColorResources
                                  //                         .getTextColor(
                                  //                             context),
                                  //                     fontSize: Dimensions
                                  //                         .FONT_SIZE_LARGE)),
                                  //             const SizedBox(
                                  //                 height: Dimensions
                                  //                     .PADDING_SIZE_EXTRA_SMALL),
                                  //             GridView.builder(
                                  //               gridDelegate:
                                  //                   const SliverGridDelegateWithFixedCrossAxisCount(
                                  //                 crossAxisCount: 5,
                                  //                 crossAxisSpacing: 0,
                                  //                 mainAxisSpacing: 0,
                                  //                 childAspectRatio:
                                  //                     (0.5 / 0.50),
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
                                  //                 ChoiceOption choiceOption =
                                  //                     widget.product!
                                  //                             .choiceOptions![
                                  //                         index];
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
                                  //                         alignment:
                                  //                             Alignment.center,
                                  //                         // padding: const EdgeInsets
                                  //                         //     .symmetric(
                                  //                         //     vertical: Dimensions
                                  //                         //         .PADDING_SIZE_EXTRA_SMALL,
                                  //                         //     horizontal: Dimensions
                                  //                         //         .PADDING_SIZE_EXTRA_SMALL),
                                  //                         decoration:
                                  //                             BoxDecoration(
                                  //                           color: choiceOption
                                  //                                           .title! ==
                                  //                                       'Color' ||
                                  //                                   choiceOption
                                  //                                           .title! ==
                                  //                                       'color'
                                  //                               ? Helpers.selectColor(
                                  //                                   choiceOption
                                  //                                       .options![
                                  //                                           i]
                                  //                                       .trim())
                                  //                               : productProvider.variationIndex![
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
                                  //                               color: Colors
                                  //                                   .black,
                                  //                               width: 0.5),
                                  //                           shape:
                                  //                               BoxShape.circle,
                                  //                         ),
                                  //                         child: choiceOption
                                  //                                     .title! ==
                                  //                                 'Color'
                                  //                             ? SizedBox()
                                  //                             : Text(
                                  //                                 choiceOption
                                  //                                     .options![
                                  //                                         i]
                                  //                                     .trim(),
                                  //                                 maxLines: 1,
                                  //                                 overflow:
                                  //                                     TextOverflow
                                  //                                         .ellipsis,
                                  //                                 style: rubikRegular
                                  //                                     .copyWith(
                                  //                                   color: productProvider.variationIndex![index] !=
                                  //                                           i
                                  //                                       ? ColorResources.getTextColor(
                                  //                                           context)
                                  //                                       : ColorResources.getScaffoldBackgroundColor(
                                  //                                           context),
                                  //                                 ),
                                  //                               ),
                                  //                       ),
                                  //                     ),
                                  //                     (choiceOption.title! ==
                                  //                                     'Color' ||
                                  //                                 choiceOption
                                  //                                         .title! ==
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
                                  //                                   Icons
                                  //                                       .done_outlined,
                                  //                                   color: Colors
                                  //                                       .white,
                                  //                                   size: 20,
                                  //                                 ),
                                  //                               ),
                                  //                               decoration: BoxDecoration(
                                  //                                   borderRadius:
                                  //                                       BorderRadius.circular(
                                  //                                           50),
                                  //                                   color: Colors
                                  //                                       .red),
                                  //                             ))
                                  //                         : SizedBox()
                                  //                   ],
                                  //                 );
                                  //               },
                                  //             ),
                                  //             SizedBox(
                                  //                 height: index !=
                                  //                         widget
                                  //                                 .product!
                                  //                                 .choiceOptions!
                                  //                                 .length -
                                  //                             1
                                  //                     ? Dimensions
                                  //                         .PADDING_SIZE_LARGE
                                  //                     : 0),
                                  //             SizedBox(height: 20),
                                  //           ]);
                                  //     },
                                  //   ),
                                  // ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, top: 5),
                                    child: Row(children: [
                                      Text(
                                          '${getTranslated('total_amount', context)}:',
                                          style: rubikMedium.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_LARGE,
                                              color:
                                                  ColorResources.getTextColor(
                                                      context))),
                                      const SizedBox(
                                          width: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      Text(
                                          PriceConverter.convertPrice(
                                                      context, _startingPrice,
                                                      discount: widget
                                                          .product!.discount,
                                                      discountType: widget
                                                          .product!
                                                          .discountType) ==
                                                  PriceConverter.convertPrice(
                                                      context, _startingPrice)
                                              ? ""
                                              : '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(
                                              context,
                                              priceWithQuantityWithoutDiscount)}',
                                          style: const TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              decoration:
                                                  TextDecoration.lineThrough)),
                                      const SizedBox(width: 1),
                                      Text(
                                          '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${PriceConverter.convertPrice(
                                              context, priceWithQuantity)}',
                                          style: rubikBold.copyWith(
                                            color:
                                                ColorResources.SCAFFOLD_COLOR,
                                            fontSize:
                                                Dimensions.FONT_SIZE_LARGE,
                                          )),
                                    ]),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                              if(_isLoggedIn)    cartProvider.cartLoading == true
                                      ? Center(
                                          child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  ColorResources
                                                      .SCAFFOLD_COLOR),
                                        ))
                                      : CustomButton(
                                          text: getTranslated(
                                              'add_to_cart', context),
                                          onTap: () {
                                            if(_isLoggedIn){
                                              int cartId = 0;

                                              if (fromCart) {
                                                cartId = widget.cart!.id!;
                                              }

                                              CartModel _cartModel = CartModel(
                                                  id: cartId,
                                                  productId: widget.product!.id,
                                                  product: widget.product,
                                                  quantity:
                                                  productProvider.quantity,
                                                  variationIndex: productProvider
                                                      .variationIndex);

                                              cartProvider
                                                  .addToCartList(
                                                  _cartModel, (message) {})
                                                  .then((value) {
                                                cartProvider
                                                    .initCartList(context);
                                                cartProvider
                                                    .initCartListProductIds(
                                                    context);
                                                showCustomSnackBar(
                                                    getTranslated(
                                                        'added_cart_successfully',
                                                        context),
                                                    context,
                                                    isError: false);
                                                Navigator.pop(context);
                                              });
                                            }else{
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext context) => LoginScreen()));
                                            }

                                          },
                                        )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            useSafeArea: true,
                            isScrollControlled: true,backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return SingleProductDetailsBottomSheet(
                                product: widget.product!,
                                callback: (CartModel cartModel) {
                                  ScaffoldMessenger.of(context!).showSnackBar(
                                      SnackBar(
                                          content: Text(getTranslated(
                                              'added_to_cart', context)),
                                          backgroundColor: Colors.green));
                                },
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(26),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(getTranslated('specification', context),
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black45)),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 15,
                                  color: Colors.black45,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
                ),
              );
            },
          );
        }));
  }
}
