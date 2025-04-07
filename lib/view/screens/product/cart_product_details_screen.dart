import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/moq_setting_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';
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
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/rating_bar.dart';
import 'package:wired_express/view/base/single_cart_product_bottom_sheet.dart';
import 'package:wired_express/view/base/single_product_bottom_sheet.dart';
import 'package:wired_express/view/screens/home/widget/image_preview.dart';

class CartProductDetailsScreen extends StatefulWidget {
  final Product? product;
  final Function? callback;
  final CartModel? cart;
  final int cartIndex;
  CartProductDetailsScreen(
      {@required this.product, this.callback, this.cart, this.cartIndex = 0});
  @override
  _CartProductDetailsScreenState createState() =>
      _CartProductDetailsScreenState();
}

class _CartProductDetailsScreenState extends State<CartProductDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 0), () async {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);

      productProvider.setQuantity(widget.cart!.quantity!);

      await productProvider
          .getProductDetails(context, widget.product!.id!)
          .then((onValue) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    String? _image;
    final bool _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          actions: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8, right: 8),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Consumer<WishListProvider>(
                      builder: (context, wishList, child) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)),
                          child: IconButton(
                            onPressed: () =>
                            wishList.wishIdList.contains(widget.product!.id)
                                ? wishList.removeFromWishList(widget.product!,
                                    (message) {
                                  wishList.initWishList(context);
                                  wishList.initWishListProductIds(context);
                                })
                                : wishList.addToWishList(widget.product!,
                                    (message) {
                                  wishList.initWishList(context);
                                  wishList.initWishListProductIds(context);
                                }),
                            icon: _isLoggedIn
                                ? Icon(
                              wishList.wishIdList.contains(widget.product!.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: wishList.wishIdList
                                  .contains(widget.product!.id)
                                  ? ColorResources.getPrimaryColor(context)
                                  : Colors.white,
                            )
                                : const SizedBox(),
                          ),
                        );
                      }),
                ),
              ),
            )
          ],
          leading: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50)),
                      child:  Padding(
                        padding: EdgeInsets.all(14),
                        child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: ColorResources.getScaffoldColor(context),
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
        // backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
        key: _scaffoldKey,
        body: Consumer<CartProvider>(builder: (context, cartProvider, child) {
          return Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              if (productProvider.productDetailsLoading ||
                  productProvider.productDetailsModel == null) {
                return CustomCircularIndicator();
              }
              Product product = productProvider.productDetailsModel!;
              List<TiredPricingModel> tiredPricing = product.tiredPricing ?? [];
              MoqSettingModel? moqSetting = product.moqSetting;
              int minOrderQuantity = moqSetting?.minimumOrderQuantity ?? 1;

              double priceWithDiscount = PriceConverter.convertWithDiscount(
                  context, product.price!, product.discount!, product.discountType!);
              double price = PriceConverter.getProductFinalPrice(tiredPricing , priceWithDiscount , productProvider.quantity??1)??0.0;

              double priceWithQuantity =
                  price * productProvider.quantity!;
              double priceWithQuantityWithoutDiscount =
                  price * productProvider.quantity!;


              DateTime _currentTime =
                  Provider.of<SplashProvider>(context, listen: false)
                      .currentTime;
              DateTime _start =
                  DateFormat('hh:mm:ss').parse(product.availableTimeStarts!);
              DateTime _end =
                  DateFormat('hh:mm:ss').parse(product.availableTimeEnds!);
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
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           Navigator.pop(context);
                          //         },
                          //         child: Container(
                          //             decoration: BoxDecoration(
                          //                 color: Colors.white,
                          //                 borderRadius:
                          //                     BorderRadius.circular(50)),
                          //             child: Padding(
                          //               padding: const EdgeInsets.all(14),
                          //               child: Icon(
                          //                 Icons.arrow_back_ios_new_outlined,
                          //                 color: ColorResources.getScaffoldColor(context),
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
                          GestureDetector(
                            onTap: () {
                              String url =
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image}';
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ImagePreview(imageURL: url)));
                            },
                            child: Image.network(
                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image}',
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
                                          product.name!,
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
                                      //   AppConstants.CURRENCY +
                                      //       product.price!.toString(),
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
                                            '${PriceConverter.convertPrice(context, price, discount: product.discount, discountType: product.discountType)}',
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
                                            GestureDetector(
                                              onTap: () {
                                                if (productProvider.quantity! >
                                                    minOrderQuantity) {
                                                  productProvider.setQuantity(
                                                      productProvider
                                                              .quantity! -
                                                          1);
                                                }
                                              },
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    color: ColorResources
                                                        .getScaffoldColor(context),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                child:  Icon(
                                                  Icons.remove,
                                                  size: 20,
                                                  color: ColorResources
                                                      .getScaffoldBackgroundColor(context),
                                                ),
                                              ),
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
                                            GestureDetector(
                                              onTap: () => productProvider
                                                  .setQuantity(productProvider
                                                          .quantity! +
                                                      1),
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    color: ColorResources
                                                        .getScaffoldColor(context),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                child:  Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: ColorResources
                                                      .getScaffoldBackgroundColor(context),
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
                                                '${PriceConverter.convertPrice(context, price)}',
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
                                              rating: product.rating!.length > 0
                                                  ? double.parse(product
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
                                          price == priceWithDiscount
                                              ? ""
                                              : PriceConverter.convertPrice(
                                                  context,
                                                  priceWithQuantityWithoutDiscount),
                                          style: const TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              decoration:
                                                  TextDecoration.lineThrough)),
                                      const SizedBox(width: 1),
                                      Text(
                                          PriceConverter.convertPrice(
                                              context, priceWithQuantity),
                                          style: rubikBold.copyWith(
                                            color:
                                                ColorResources.getScaffoldColor(context),
                                            fontSize:
                                                Dimensions.FONT_SIZE_LARGE,
                                          )),
                                    ]),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  cartProvider.cartLoading == false
                                      ? Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 30,
                                                bottom: 5),
                                            child: CustomButton(
                                              text: getTranslated(
                                                  'update_in_cart', context),
                                              backgroundColor: ColorResources
                                                  .getPrimaryColor(context),
                                              onTap: () {
                                                CartModel _cartModel =
                                                    CartModel(
                                                        id: widget.cart!.id!,
                                                        productId: product.id,
                                                        product: product,
                                                        quantity:
                                                            productProvider
                                                                .quantity);
                                                cartProvider
                                                    .addToCartList(_cartModel,
                                                        (message) {})
                                                    .then((value) {
                                                  cartProvider
                                                      .initCartList(context);
                                                  cartProvider
                                                      .initCartListProductIds(
                                                          context);
                                                  showCustomSnackBar(
                                                      getTranslated(
                                                          'updated_successfully',
                                                          context),
                                                      context,
                                                      isError: false);
                                                  Navigator.pop(context);
                                                });
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 5,
                                                bottom: 5),
                                            child: MaterialButton(
                                              onPressed: () {
                                                cartProvider
                                                    .removeFromCartList(
                                                        widget.cart!.id!,
                                                        product.id!,
                                                        (message) {})
                                                    .then((value) {
                                                  cartProvider
                                                      .initCartList(context);
                                                  cartProvider
                                                      .initCartListProductIds(
                                                          context);
                                                  showCustomSnackBar(
                                                      getTranslated(
                                                          'delete_from_cart_successful',
                                                          context),
                                                      context,
                                                      isError: false);
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Text(
                                                  getTranslated(
                                                      'delete_from_cart',
                                                      context),
                                                  style:  TextStyle(
                                                    color: ColorResources
                                                        .getScaffoldColor(context),
                                                  )),
                                              color: Colors.transparent,
                                              elevation: 0,
                                              minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 50,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side:  BorderSide(
                                                  color: ColorResources
                                                      .getScaffoldColor(context),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ])
                                      :  CustomCircularIndicator(
                                          color: ColorResources.getScaffoldColor(context)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          useSafeArea: true,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) =>
                              SingleCartProductDetailsBottomSheet(
                                  product: product, cart: widget.cart!),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
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
