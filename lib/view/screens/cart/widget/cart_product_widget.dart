// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:wired_express/data/helper/helpers.dart';
// import 'package:wired_express/data/model/response/cart_model.dart';
// import 'package:wired_express/data/model/response/product_model.dart';
// import 'package:wired_express/helper/price_converter.dart';
// import 'package:wired_express/helper/responsive_helper.dart';
// import 'package:wired_express/localization/language_constrants.dart';
// import 'package:wired_express/provider/cart_provider.dart';
// import 'package:wired_express/provider/product_provider.dart';
// import 'package:wired_express/provider/splash_provider.dart';
// import 'package:wired_express/provider/theme_provider.dart';
// import 'package:wired_express/utill/app_constants.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:wired_express/utill/dimensions.dart';
// import 'package:wired_express/utill/images.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:wired_express/view/base/rating_bar.dart';
// import 'package:wired_express/view/screens/home/widget/cart_bottom_sheet.dart';
// import 'package:provider/provider.dart';
// import 'package:wired_express/view/screens/product/cart_product_details_screen.dart';
//
// class CartProductWidget extends StatelessWidget {
//   final CartModel? cart;
//   final int? cartIndex;
//   final bool? isAvailable;
//   CartProductWidget(
//       {@required this.cart,
//       @required this.cartIndex,
//       @required this.isAvailable});
//
//   @override
//   Widget build(BuildContext context) {
//     print('cart here -- ${jsonEncode(cart)}');
//     final productProvider =
//         Provider.of<ProductProvider>(context, listen: false);
//     Product product = cart!.product!;
//     Variation _variation = Variation();
//
//     String variationType =
//         Helpers.getVariationType(product, cart!.variationIndex!);
//
//     double price = product.price!;
//     String? _url;
//     for (Variation variation in product.variations!) {
//       if (variation.type == variationType) {
//         price = variation.price!;
//         _variation = variation;
//         break;
//       }
//     }
//     double priceWithDiscount = PriceConverter.convertWithDiscount(
//         context, price, product.discount!, product.discountType!);
//
//     double priceWithQuantity = priceWithDiscount * cart!.quantity!;
//     double test = price * cart!.quantity!;
//     return InkWell(
//       onTap: () {
//         Provider.of<ProductProvider>(context, listen: false)
//             .initCartData(cart!.quantity!, cart!.variationIndex!);
//         Provider.of<CartProvider>(context, listen: false)
//             .isExistInCart(cart!.product!, productProvider.variationIndex!);
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext? context) => CartProductDetailsScreen(
//                       product: cart!.product!,
//                       cartIndex: cartIndex!,
//                       cart: cart!,
//                       callback: (CartModel cartModel) {
//                         ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
//                             content:
//                                 Text(getTranslated('updated_in_cart', context)),
//                             backgroundColor: Colors.green));
//                       },
//                     )));
//         // : showDialog(
//         //     context: context,
//         //     builder: (con) => Dialog(
//         //           child: CartBottomSheet(
//         //             product: cart!.product!,
//         //             cartIndex: cartIndex!,
//         //             cart: cart!,
//         //             callback: (CartModel cartModel) {
//         //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         //                   content: Text(
//         //                       getTranslated('updated_in_cart', context)),
//         //                   backgroundColor: Colors.green));
//         //             },
//         //           ),
//         //         ));
//       },
//       child: Container(
//         margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
//         decoration: BoxDecoration(
//             color: Colors.red, borderRadius: BorderRadius.circular(10)),
//         child: Stack(children: [
//           Positioned(
//             top: 0,
//             bottom: 0,
//             right: 0,
//             left: 0,
//             child:
//                 Icon(Icons.delete, color: ColorResources.COLOR_WHITE, size: 50),
//           ),
//           Dismissible(
//             key: Key(cart!.product!.id.toString()),
//             onDismissed: (DismissDirection direction) {
//               Provider.of<CartProvider>(context, listen: false)
//                   .removeFromCart(cart!);
//               Provider.of<CartProvider>(context, listen: false)
//                   .removeFromCartList(
//                       cart!.id!, cart!.productId!, (message) {});
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(
//                   vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
//                   horizontal: Dimensions.PADDING_SIZE_SMALL),
//               decoration: BoxDecoration(
//                   color: ColorResources.getScaffoldBackgroundColor(context),
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Provider.of<ThemeProvider>(context).darkTheme
//                           ? Colors.black.withOpacity(0.4)
//                           : Colors.grey[300]!,
//                       blurRadius: 5,
//                       spreadRadius: 1,
//                     )
//                   ]),
//               child: Column(
//                 children: [
//                   Row(children: [
//                     Stack(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: FadeInImage.assetNetwork(
//                             placeholder: Images.placeholder_image,
//                             image:
//                                 '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${cart!.product!.image}',
//                             height: 70,
//                             width: 85,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         isAvailable!
//                             ? SizedBox()
//                             : Positioned(
//                                 top: 0,
//                                 left: 0,
//                                 bottom: 0,
//                                 right: 0,
//                                 child: Container(
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: Colors.black.withOpacity(0.6)),
//                                   child: Text(
//                                       getTranslated(
//                                           'not_available_now_break', context),
//                                       textAlign: TextAlign.center,
//                                       style: rubikRegular.copyWith(
//                                         color:
//                                             Provider.of<ThemeProvider>(context)
//                                                     .darkTheme
//                                                 ? Colors.black
//                                                 : Colors.white,
//                                         fontSize: 8,
//                                       )),
//                                 ),
//                               ),
//                       ],
//                     ),
//                     const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
//                     Expanded(
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text('${cart!.product!.name}',
//                                 style: rubikMedium.copyWith(
//                                     color:
//                                         ColorResources.getTextColor(context)),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis),
//                             const SizedBox(height: 5),
//                             RatingBar(
//                                 rating: cart!.product!.rating!.length > 0
//                                     ? double.parse(
//                                         cart!.product!.rating![0].average!)
//                                     : 0.0,
//                                 size: 12),
//                             const SizedBox(height: 5),
//                           ]),
//                     ),
//                     product.discount == 0
//                         ? SizedBox()
//                         : Text(
//                             '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${test}',
//                             style: rubikMedium.copyWith(
//                               color: Provider.of<ThemeProvider>(context,
//                                           listen: false)
//                                       .darkTheme
//                                   ? ColorResources.DISABLE_COLOR
//                                   : ColorResources.COLOR_GREY,
//                               decoration: TextDecoration.lineThrough,
//                               fontSize: 13,
//                             ),
//                           ),
//                     SizedBox(
//                       width: 8,
//                     ),
//                     Text('${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${priceWithQuantity}',
//                         style: TextStyle(
//                             color: ColorResources.getPrimaryColor(context),
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500)),
//                   ]),
//                 ],
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/screens/signle_product_screen/single_product_cart_screen.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel? cart;
  final int? cartIndex;
  final bool? isAvailable;
  final bool? fromSubmitOrder;

  CartProductWidget({
    @required this.cart,
    @required this.cartIndex,
    @required this.isAvailable,
    this.fromSubmitOrder = false,
  });

  @override
  Widget build(BuildContext context) {
    print('cart here -- ${jsonEncode(cart)}');
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    Product product = cart!.product!;
    Variation _variation = Variation();

    String variationType =
        Helpers.getVariationType(product, cart!.variationIndex!);

    double price = product.price!;
    String? _url;
    for (Variation variation in product.variations!) {
      if (variation.type == variationType) {
        price = variation.price!;
        _variation = variation;
        break;
      }
    }
    double priceWithDiscount = PriceConverter.convertWithDiscount(
        context, price, product.discount!, product.discountType!);

    double priceWithQuantity = priceWithDiscount * cart!.quantity!;
    double test = price * cart!.quantity!;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            return fromSubmitOrder == true
                ? InkWell(
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          horizontal: Dimensions.PADDING_SIZE_SMALL,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                               // color: Colors.grey[400],
                              ),
                              width: 100,
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.network(
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image}',
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          '${cart!.quantity!} items',
                                          style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${priceWithQuantity}',
                                        style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      Provider.of<ProductProvider>(context, listen: false)
                          .initCartData(cart!.quantity!, cart!.variationIndex!);
                      Provider.of<CartProvider>(context, listen: false)
                          .isExistInCart(
                              cart!.product!, productProvider.variationIndex!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext? context) =>
                              SingleProductCartScreen(
                            product: cart!.product!,
                            cartIndex: cartIndex!,
                            cart: cart!,
                            callback: (CartModel cartModel) {
                              ScaffoldMessenger.of(context!).showSnackBar(
                                SnackBar(
                                  content: Text(getTranslated(
                                      'updated_in_cart', context)),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          horizontal: Dimensions.PADDING_SIZE_SMALL,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Provider.of<ThemeProvider>(context).darkTheme
                                        ? Colors.black.withOpacity(0.4)
                                        : Colors.grey[300]!,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  )
                                ],
                                color: Colors.white,
                              ),
                              width: 100,
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.network(
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}',
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      '${cart!.quantity!} items',
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${priceWithQuantity}',
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        cart!.quantity! == 1
                                            ? InkWell(
                                                onTap: () {
                                                  Provider.of<CartProvider>(
                                                          context,
                                                          listen: false)
                                                      .removeFromCart(cart!);
                                                  Provider.of<CartProvider>(
                                                          context,
                                                          listen: false)
                                                      .removeFromCartList(
                                                          cart!.id!,
                                                          cart!.productId!,
                                                          (message) {});
                                                  showCustomSnackBar(
                                                      getTranslated(
                                                          'removed_cart_successfully',
                                                          context),
                                                      context,
                                                      isError: false);
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
                                                  child: Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                    color: ColorResources
                                                        .COLOR_WHITE,
                                                  ),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  if (cart!.quantity! > 1) {
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .updateQuantity(
                                                            cartIndex!,
                                                            cart!.quantity! -
                                                                1);
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
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 20,
                                                    color: ColorResources
                                                        .COLOR_WHITE,
                                                  ),
                                                ),
                                              ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            cart!.quantity.toString(),
                                            style: rubikMedium.copyWith(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  ColorResources.getTextColor(
                                                      context),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Provider.of<CartProvider>(context,
                                                    listen: false)
                                                .updateQuantity(cartIndex!,
                                                    cart!.quantity! + 1);
                                          },
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color:
                                                  ColorResources.SCAFFOLD_COLOR,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 20,
                                              color: ColorResources.COLOR_WHITE,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          },
        );
      },
    );
  }
}
// class CartProductWidget extends StatelessWidget {
//   final CartModel? cart;
//   final int? cartIndex;
//   final bool? isAvailable;
//   CartProductWidget(
//       {@required this.cart,
//       @required this.cartIndex,
//       @required this.isAvailable});
//
//   @override
//   Widget build(BuildContext context) {
//     print('cart here -- ${jsonEncode(cart)}');
//     final productProvider =
//         Provider.of<ProductProvider>(context, listen: false);
//     Product product = cart!.product!;
//     Variation _variation = Variation();
//
//     String variationType =
//         Helpers.getVariationType(product, cart!.variationIndex!);
//
//     double price = product.price!;
//     String? _url;
//     for (Variation variation in product.variations!) {
//       if (variation.type == variationType) {
//         price = variation.price!;
//         _variation = variation;
//         break;
//       }
//     }
//     double priceWithDiscount = PriceConverter.convertWithDiscount(
//         context, price, product.discount!, product.discountType!);
//
//     double priceWithQuantity = priceWithDiscount * cart!.quantity!;
//     double test = price * cart!.quantity!;
//     return Consumer<CartProvider>(builder: (context, cartProvider, child) {
//       return Consumer<ProductProvider>(
//           builder: (context, productProvider, child) {
//         return InkWell(
//           onTap: () {
//             Provider.of<ProductProvider>(context, listen: false)
//                 .initCartData(cart!.quantity!, cart!.variationIndex!);
//             Provider.of<CartProvider>(context, listen: false)
//                 .isExistInCart(cart!.product!, productProvider.variationIndex!);
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext? context) =>
//
//                         // CartProductDetailsScreen(
//                         //   product: cart!.product!,
//                         //   cartIndex: cartIndex!,
//                         //   cart: cart!,
//                         //   callback: (CartModel cartModel) {
//                         //     ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
//                         //         content:
//                         //             Text(getTranslated('updated_in_cart', context)),
//                         //         backgroundColor: Colors.green));
//                         //   },
//                         // )
//
//                         SingleProductCartScreen(
//                           product: cart!.product!,
//                           cartIndex: cartIndex!,
//                           cart: cart!,
//                           callback: (CartModel cartModel) {
//                             ScaffoldMessenger.of(context!).showSnackBar(
//                                 SnackBar(
//                                     content: Text(getTranslated(
//                                         'updated_in_cart', context)),
//                                     backgroundColor: Colors.green));
//                           },
//                         )));
//           },
//           child: Container(
//             margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
//             child: Container(
//               padding: EdgeInsets.symmetric(
//                   vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
//                   horizontal: Dimensions.PADDING_SIZE_SMALL),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.grey[400]),
//                     width: 100,
//                     height: 100,
//                     child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Image.network(
//                         '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product!.image}',
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           product.name!,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600, fontSize: 18),
//                         ),
//                         SizedBox(
//                           height: 30,
//                         ),
//                         // Padding(
//                         //   padding:
//                         //       const EdgeInsets.only(left: 15, right: 15, top: 15),
//                         //   child: Row(
//                         //     children: [
//                         //       Container(
//                         //         decoration: BoxDecoration(
//                         //             color:
//                         //                 ColorResources.getBackgroundColor(context),
//                         //             borderRadius: BorderRadius.circular(5)),
//                         //         child: Row(children: [
//                         //           InkWell(
//                         //             onTap: () {
//                         //               if (productProvider.quantity! > 1) {
//                         //                 productProvider.setQuantity(false);
//                         //               }
//                         //             },
//                         //             child: Padding(
//                         //               padding: EdgeInsets.symmetric(
//                         //                   horizontal: Dimensions.PADDING_SIZE_SMALL,
//                         //                   vertical:
//                         //                       Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                         //               child: Icon(
//                         //                 Icons.remove,
//                         //                 size: 20,
//                         //                 color: ColorResources.getTextColor(context),
//                         //               ),
//                         //             ),
//                         //           ),
//                         //           Text(productProvider.quantity.toString(),
//                         //               style: rubikMedium.copyWith(
//                         //                   color:
//                         //                       ColorResources.getTextColor(context),
//                         //                   fontSize:
//                         //                       Dimensions.FONT_SIZE_EXTRA_LARGE)),
//                         //           InkWell(
//                         //             onTap: () => productProvider.setQuantity(true),
//                         //             child: Padding(
//                         //               padding: EdgeInsets.symmetric(
//                         //                   horizontal: Dimensions.PADDING_SIZE_SMALL,
//                         //                   vertical:
//                         //                       Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                         //               child: Icon(
//                         //                 Icons.add,
//                         //                 size: 20,
//                         //                 color: ColorResources.getTextColor(context),
//                         //               ),
//                         //             ),
//                         //           ),
//                         //         ]),
//                         //       ),
//                         //     ],
//                         //   ),
//                         // ),
//                         Align(
//                           alignment: Alignment.bottomLeft,
//                           child: Text(
//                             '${cart!.quantity!} items',
//                             style:
//                                 TextStyle(color: Colors.black38, fontSize: 18),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Expanded(
//                     child: Column(
//                       children: [
//                         Text(
//                           '${Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol}${priceWithQuantity}',
//                           style: TextStyle(color: Colors.black38, fontSize: 18),
//                         ),
//                         SizedBox(
//                           height: 40,
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                               // color: ColorResources.getBackgroundColor(context),
//                               borderRadius: BorderRadius.circular(5)),
//                           child: Row(children: [
//                             InkWell(
//                               onTap: () {},
//                               child: Container(
//                                 width: 25,
//                                 height: 25,
//                                 decoration: BoxDecoration(
//                                     color: ColorResources.SCAFFOLD_COLOR,
//                                     borderRadius: BorderRadius.circular(50)),
//                                 child: Icon(
//                                   Icons.remove,
//                                   size: 20,
//                                   color: ColorResources.COLOR_WHITE,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10),
//                               child: Text(cart!.quantity.toString(),
//                                   style: rubikMedium.copyWith(
//                                     fontSize: 25,
//                                     fontWeight: FontWeight.w500,
//                                     color: ColorResources.getTextColor(context),
//                                   )),
//                             ),
//                             InkWell(
//                               onTap: () {},
//                               child: Container(
//                                 width: 25,
//                                 height: 25,
//                                 decoration: BoxDecoration(
//                                     color: ColorResources.SCAFFOLD_COLOR,
//                                     borderRadius: BorderRadius.circular(50)),
//                                 child: Icon(
//                                   Icons.add,
//                                   size: 20,
//                                   color: ColorResources.COLOR_WHITE,
//                                 ),
//                               ),
//                             ),
//                           ]),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       });
//     });
//   }
// }
