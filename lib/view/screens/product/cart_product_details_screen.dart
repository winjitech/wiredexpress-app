import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wired_express/provider/auth_provider.dart';

import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/language_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/screens/home/widget/image_preview.dart';
import 'package:wired_express/utill/color_resources.dart';

class CartProductDetailsScreen extends StatelessWidget {
  final Product? product;
  final bool? fromSetMenu;
  final Function? callback;
  final CartModel? cart;
  final int cartIndex;
  CartProductDetailsScreen(
      {@required this.product,
      this.fromSetMenu = false,
      this.callback,
      this.cart,
      this.cartIndex = 0});

  @override
  Widget build(BuildContext context) {
    bool fromCart = cart != null;
    fromCart
        ? Provider.of<ProductProvider>(context, listen: false)
            .initCartData(cart!.quantity!, cart!.variationIndex!)
        : Provider.of<ProductProvider>(context, listen: false)
            .initData(product!);

    Variation _variation = Variation();
    String? _image;
    final bool _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      appBar: CustomAppBar(title: 'Product Details'),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
            double? _startingPrice;
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
                _url =
                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/$_image!}';
                break;
              }
            }

            double priceWithDiscount = PriceConverter.convertWithDiscount(
                context, price, product!.discount!, product!.discountType!);

            double priceWithQuantity =
                priceWithDiscount * productProvider.quantity!;
            double priceWithQuantityWithoutDiscount =
                price * productProvider.quantity!;

            DateTime _currentTime =
                Provider.of<SplashProvider>(context, listen: false).currentTime;
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
            DateTime _endTime = DateTime(_currentTime.year, _currentTime.month,
                _currentTime.day, _end.hour, _end.minute, _end.second);
            if (_endTime.isBefore(_startTime)) {
              _endTime = _endTime.add(Duration(days: 1));
            }
            // bool _isAvailable = _currentTime.isAfter(_startTime) &&
            //     _currentTime.isBefore(_endTime);
            bool _isAvailable = true;

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

            return Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      //  physics: BouncingScrollPhysics(),
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(60),
                                      bottomRight: Radius.circular(60),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Provider.of<ThemeProvider>(context)
                                                    .darkTheme
                                                ? Colors.black.withOpacity(0.4)
                                                : Colors.grey[300]!,
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      )
                                    ]),
                                child: GestureDetector(
                                  onTap: () {
                                    String url =
                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}';
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ImagePreview(imageURL: url)));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(60),
                                      bottomRight: Radius.circular(60),
                                    ),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.loading,
                                      image:
                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}',
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text('${product!.name}',
                                          style: TextStyle(
                                              color:
                                                  ColorResources.getTextColor(
                                                      context),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Consumer<WishListProvider>(
                                        builder: (context, wishList, child) {
                                      return IconButton(
                                        onPressed: () {
                                          wishList.wishIdList
                                                  .contains(product!.id)
                                              ? wishList.removeFromWishList(
                                                  product!, (message) {})
                                              : wishList.addToWishList(
                                                  product!, (message) {});
                                        },
                                        icon: _isLoggedIn
                                            ? Icon(
                                                wishList.wishIdList
                                                        .contains(product!.id)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: wishList.wishIdList
                                                        .contains(product!.id)
                                                    ? ColorResources
                                                        .getPrimaryColor(
                                                            context)
                                                    : ColorResources
                                                        .getHintColor(context),
                                              )
                                            : SizedBox(),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 15),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: product!.choiceOptions!.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              product!
                                                  .choiceOptions![index].title!,
                                              style: rubikMedium.copyWith(
                                                  color: ColorResources
                                                      .getTextColor(context),
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_LARGE)),
                                          const SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          GridView.builder(
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 10,
                                              childAspectRatio: (1 / 0.25),
                                            ),
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: product!
                                                .choiceOptions![index]
                                                .options!
                                                .length,
                                            itemBuilder: (context, i) {
                                              return InkWell(
                                                onTap: () {
                                                  productProvider
                                                      .setCartVariationIndex(
                                                          index, i);
                                                  cartProvider.isExistInCart(
                                                      product!,
                                                      productProvider
                                                          .variationIndex!);
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                  decoration: BoxDecoration(
                                                    color: productProvider
                                                                    .variationIndex![
                                                                index] !=
                                                            i
                                                        ? ColorResources
                                                            .getScaffoldBackgroundColor(
                                                                context)
                                                        : ColorResources
                                                            .getPrimaryColor(
                                                                context),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: productProvider
                                                                    .variationIndex![
                                                                index] !=
                                                            i
                                                        ? Border.all(
                                                            color: ColorResources
                                                                .BORDER_COLOR,
                                                            width: 2)
                                                        : null,
                                                  ),
                                                  child: Text(
                                                    product!
                                                        .choiceOptions![index]
                                                        .options![i]
                                                        .trim(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        rubikRegular.copyWith(
                                                      color: productProvider
                                                                      .variationIndex![
                                                                  index] !=
                                                              i
                                                          ? ColorResources
                                                              .getTextColor(
                                                                  context)
                                                          : ColorResources
                                                              .getScaffoldBackgroundColor(
                                                                  context),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                              height: index !=
                                                      product!.choiceOptions!
                                                              .length -
                                                          1
                                                  ? Dimensions
                                                      .PADDING_SIZE_LARGE
                                                  : 0),
                                        ]);
                                  },
                                ),
                              ),
                              product!.choiceOptions!.length > 0
                                  ? SizedBox(
                                      height: Dimensions.PADDING_SIZE_LARGE)
                                  : SizedBox(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 15),
                                child: Row(
                                  children: [
                                    Text(
                                        '${'${PriceConverter.convertPrice(context, _startingPrice, discount: product!.discount, discountType: product!.discountType)}'
                                            '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product!.discount, discountType: product!.discountType)}' : ''}'}',
                                        style: TextStyle(
                                            color: ColorResources.getTextColor(
                                                context),
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    SizedBox(width: 20),
                                    Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                          color:
                                              ColorResources.getBackgroundColor(
                                                  context),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(children: [
                                        InkWell(
                                          onTap: () {
                                            if (productProvider.quantity! > 1) {
                                              productProvider
                                                  .setQuantity(false);
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_SMALL,
                                                vertical: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL),
                                            child: Icon(
                                              Icons.remove,
                                              size: 20,
                                              color:
                                                  ColorResources.getTextColor(
                                                      context),
                                            ),
                                          ),
                                        ),
                                        Text(
                                            productProvider.quantity.toString(),
                                            style: rubikMedium.copyWith(
                                                color:
                                                    ColorResources.getTextColor(
                                                        context),
                                                fontSize: Dimensions
                                                    .FONT_SIZE_EXTRA_LARGE)),
                                        InkWell(
                                          onTap: () =>
                                              productProvider.setQuantity(true),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_SMALL,
                                                vertical: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL),
                                            child: Icon(
                                              Icons.add,
                                              size: 20,
                                              color:
                                                  ColorResources.getTextColor(
                                                      context),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                              price > priceWithDiscount
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Text(
                                        '${PriceConverter.convertPrice(context, _startingPrice)}'
                                        '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                                        style: TextStyle(
                                            color: Provider.of<ThemeProvider>(
                                                        context,
                                                        listen: false)
                                                    .darkTheme
                                                ? ColorResources.DISABLE_COLOR
                                                : ColorResources.COLOR_GREY,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    )
                                  : SizedBox(),
                              Consumer(builder: (context,
                                  LanguageProvider languageProvider, child) {
                                String description = '';
                                description = product!.description ?? '';
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(description,
                                          style: TextStyle(
                                              color:
                                                  ColorResources.getHintColor(
                                                      context),
                                              fontSize: 14),
                                          maxLines: 4),
                                      product!.description != null
                                          ? product!.description!.length > 200
                                              ? GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              ColorResources
                                                                  .getScaffoldBackgroundColor(
                                                                      context),
                                                          content: Text(
                                                              description,
                                                              style: TextStyle(
                                                                  color: ColorResources
                                                                      .getTextColor(
                                                                          context),
                                                                  fontSize:
                                                                      10)),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text(
                                                      getTranslated(
                                                          'see_more', context),
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor)))
                                              : SizedBox()
                                          : SizedBox(),
                                    ],
                                  ),
                                );
                              }),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 15),
                                child: Row(children: [
                                  Text(
                                      '${getTranslated('total_amount', context)}:',
                                      style: rubikMedium.copyWith(
                                          color: ColorResources.getTextColor(
                                              context),
                                          fontSize:
                                              Dimensions.FONT_SIZE_LARGE)),
                                  const SizedBox(
                                      width:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(
                                      PriceConverter.convertPrice(context,
                                          priceWithQuantityWithoutDiscount),
                                      style: TextStyle(
                                          color: Provider.of<ThemeProvider>(
                                                      context,
                                                      listen: false)
                                                  .darkTheme
                                              ? ColorResources.DISABLE_COLOR
                                              : ColorResources.COLOR_GREY,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          decoration:
                                              TextDecoration.lineThrough)),
                                  const SizedBox(width: 1),
                                  Text(
                                      PriceConverter.convertPrice(
                                          context, priceWithQuantity),
                                      style: rubikBold.copyWith(
                                        color: ColorResources.getPrimaryColor(
                                            context),
                                        fontSize: Dimensions.FONT_SIZE_LARGE,
                                      )),
                                ]),
                              ),
                              // _isLoggedIn
                              //     ?
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
                                          backgroundColor:
                                              ColorResources.getPrimaryColor(
                                                  context),
                                          onTap: () {
                                            int cartId = 0;
                                            if (cartProvider.existInCart) {
                                              cartId =
                                                  cartProvider.matchedCartId!;
                                            }

                                            CartModel _cartModel = CartModel(
                                                id: cartId,
                                                productId: product!.id,
                                                product: product,
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
                                            bottom: 30),
                                        child: MaterialButton(
                                          onPressed: () {
                                            int cartId = 0;
                                            if (cartProvider.existInCart) {
                                              cartId =
                                                  cartProvider.matchedCartId!;
                                            }

                                            cartProvider
                                                .removeFromCartList(cartId,
                                                    product!.id!, (message) {})
                                                .then((value) {
                                              cartProvider
                                                  .initCartList(context);
                                              cartProvider
                                                  .initCartListProductIds(
                                                      context);
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Text(
                                              getTranslated(
                                                  'delete_from_cart', context),
                                              style: TextStyle(
                                                color: ColorResources
                                                    .getPrimaryColor(context),
                                              )),
                                          color: ColorResources
                                              .getScaffoldBackgroundColor(
                                                  context),
                                          elevation: 0,
                                          minWidth: MediaQuery.of(context).size.width,
                                          height: 50,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: ColorResources
                                                  .getPrimaryColor(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ])
                                  : Center(
                                      child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              ColorResources.getPrimaryColor(
                                                  context)),
                                    ))

                              // : SizedBox(height:20)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
        },
      ),
    );
  }
}
