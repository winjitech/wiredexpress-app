import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/moq_setting_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/product_plan_discount_model.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';

class CartProductDetailsBottomSheet extends StatefulWidget {
  final ProductModel? product;
  final bool? fromSetMenu;
  final CartModel? cart;
  CartProductDetailsBottomSheet(
      {@required this.product, this.fromSetMenu = false, this.cart});

  @override
  State<CartProductDetailsBottomSheet> createState() =>
      _CartProductDetailsBottomSheetState();
}

class _CartProductDetailsBottomSheetState
    extends State<CartProductDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 0), () {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);

      productProvider.setQuantity(widget.cart!.quantity!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    // final String languageStr = getTranslated('set_language', context);
    return Consumer4<CartProvider, ProductProvider, ProfileProvider,
            SplashProvider>(
        builder: (context, cartProvider, productProvider, profileProvider,
            splashProvider, child) {
      ProductModel product = productProvider.productDetailsModel!;
      List<TiredPricingModel> tiredPricing = product.tiredPricing ?? [];
      MoqSettingModel? moqSetting = product.moqSetting;
      int minOrderQuantity = moqSetting?.minimumOrderQuantity ?? 1;
      ProductPlanDiscountModel? productPlanDiscountModel;
      if (isLoggedIn &&
          profileProvider.userInfoModel != null &&
          profileProvider.userInfoModel!.exclusiveDiscounts == 1) {
        List<ProductPlanDiscountModel> productPlanDiscount =
            product.productPlanDiscount ?? [];

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
              product.price!,
              productPlanDiscountModel.discount!,
              productPlanDiscountModel.discountType!)
          : PriceConverter.convertWithDiscount(context, product.price!,
              product.discount!, product.discountType!);

      double price = PriceConverter.getProductFinalPrice(context , tiredPricing,
              discountedOnProductPrice, productProvider.quantity ?? 1) ??
          0.0;

      double priceWithQuantity = price * productProvider.quantity!;
      double priceWithQuantityWithoutDiscount =
          price * productProvider.quantity!;

      DateTime currentTime =
          Provider.of<SplashProvider>(context, listen: false).currentTime;
      DateTime start =
          DateFormat('hh:mm:ss').parse(product.availableTimeStarts!);
      DateTime end = DateFormat('hh:mm:ss').parse(product.availableTimeEnds!);
      DateTime startTime = DateTime(currentTime.year, currentTime.month,
          currentTime.day, start.hour, start.minute, start.second);
      DateTime endTime = DateTime(currentTime.year, currentTime.month,
          currentTime.day, end.hour, end.minute, end.second);
      if (endTime.isBefore(startTime)) {
        endTime = endTime.add(const Duration(days: 1));
      }

      bool isAvailable = true;

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

                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          // color: ColorResources.getBackgroundColor(context),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(children: [
                        GestureDetector(
                          onTap: () {
                            if (productProvider.quantity! > minOrderQuantity) {
                              productProvider
                                  .setQuantity(productProvider.quantity! - 1);
                            }
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                color: ColorResources.getScaffoldColor(context),
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(
                              Icons.remove,
                              size: 20,
                              color: ColorResources.getScaffoldBackgroundColor(
                                  context),
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
                        GestureDetector(
                          onTap: () => productProvider
                              .setQuantity(productProvider.quantity! + 1),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                color: ColorResources.getScaffoldColor(context),
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(
                              Icons.add,
                              size: 20,
                              color: ColorResources.getScaffoldBackgroundColor(
                                  context),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              product.description != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                description = product.description ?? '';
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
                    product.description != null ? SizedBox() : SizedBox(),
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
                  if (((product.price! * productProvider.quantity!)) !=
                      priceWithQuantity)
                    Row(
                      children: [
                        Text(
                          "${splashProvider.configModel!.currencySymbol ?? '\$'}${Helpers.formatTextWithNum((product.price! * productProvider.quantity!).toString())}",
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
                    PriceConverter.convertPrice(context, priceWithQuantity),
                    style: TextStyle(
                        fontSize: 16,
                        color: ColorResources.getPrimaryColor(context),
                        fontWeight: FontWeight.w600),
                  ),
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
                            CartModel cartModel = CartModel(
                                id: widget.cart!.id!,
                                productId: product.id,
                                quantity: productProvider.quantity,
                                product: product,
                                tieredPricing:
                                    PriceConverter.getMatchedTieredPricingModel(context ,
                                        tiredPricing,
                                        productProvider.quantity ?? 1));

                            cartProvider.addToCartList(cartModel).then((value) {
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
                            cartProvider
                                .removeFromCartList(
                                    widget.cart!.id!, product.id!, (message) {})
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
                              color: ColorResources.getScaffoldColor(context),
                            ),
                          ),
                          child: Text(
                              getTranslated('delete_from_cart', context),
                              style: TextStyle(
                                color: ColorResources.getScaffoldColor(context),
                              )),
                        ),
                      ),
                    ])
                  : Padding(
                      padding: const EdgeInsets.all(25),
                      child: CustomCircularIndicator(
                          color: ColorResources.getScaffoldColor(context)),
                    ),
            ],
          ),
        ),
      );
    });
  }
}
