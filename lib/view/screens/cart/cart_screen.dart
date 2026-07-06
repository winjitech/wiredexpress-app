import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/body/place_order_body.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/product_plan_discount_model.dart';
import 'package:wired_express/data/model/response/tiered_pricing_model.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/coupon_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_main_appbar.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/no_data_found_view.dart';
import 'package:wired_express/view/base/no_data_screen.dart';
import 'package:wired_express/view/base/not_logged_in_screen.dart';
import 'package:wired_express/view/screens/cart/widget/cart_product_widget.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/screens/cart/widget/choose_delivery_address_view.dart';
import 'package:wired_express/view/screens/cart/widget/discount_view.dart';
import 'package:wired_express/view/screens/checkout/checkout_screen.dart';
import 'package:wired_express/view/screens/drawer/drawer_screen.dart';
import 'package:wired_express/view/screens/home/widget/home_header_widget.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final advancedDrawerController = AdvancedDrawerController();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 0), () {
      final bool isLoggedIn =
          Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
      if (isLoggedIn) {
        int? id = Provider.of<CustomAuthProvider>(context, listen: false)
            .getUserAddressId();
        print("--------------$id");

        Provider.of<CartProvider>(context, listen: false).initCartList(context);
        Provider.of<LocationProvider>(context, listen: false)
            .initAddressList(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final bool isLoggedIn =
    Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    return AdvancedDrawer(
      rtlOpening: false,
      openRatio: 0.55,
      openScale: 0.80,
      backdrop: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(15.r),
        child: IconButton(
            onPressed: () => closeDrawer(),
            icon: Icon(
              Icons.close,
              color: ColorResources.getTextColor(context),
              size: 36.sp,
            )),
      )),
      childDecoration: BoxDecoration(borderRadius: BorderRadius.circular(40.r)),
      controller: advancedDrawerController,
      animationCurve: Curves.easeInOutExpo,
      animationDuration: const Duration(milliseconds: 400),
      backdropColor: ColorResources.getTextFieldFillColor(context),
      drawer: DrawerScreen(),
      child: Scaffold(
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
        key: scaffoldKey,
        body: Column(
          children: [
            HomeHeaderWidget(onMenuPressed: () => showDrawer(), title: 'cart'),
            Expanded(
              child: isLoggedIn
                  ? Padding(
                      padding: EdgeInsets.all(5.r),
                      child: Consumer5<ProfileProvider, CartProvider, SplashProvider,
                          CustomAuthProvider, CouponProvider>(
                        builder: (context, profileProvider, cartProvider,
                            splashProvider, authProvider, couponProvider, child) {
                          if (cartProvider.cartListLoading! ||
                              cartProvider.cartListIdsLoading!) {
                            return CustomCircularIndicator();
                          }
                          bool hasServiceOnCart = false ;
                          bool haveFreeDelivery =
                              profileProvider.userInfoModel != null &&
                                  profileProvider.userInfoModel!.freeDelivery == 1;
                          String currency =
                              splashProvider.configModel!.currencySymbol ?? '\$';
                          double totalUserPoints = double.parse(
                              Provider.of<ProfileProvider>(context, listen: false)
                                  .userInfoModel!
                                  .purchasesPoints!);
                          double totalItemsPrice = 0.0;
                          double totalItemsPriceAfterDiscOnProducts = 0.0;
                          double totalProductsPrice = 0.0;

                          double totalOrderPrice = 0.0;
                          double subTotalOrderPrice = 0.0;

                          double couponDiscountAmount = 0.0;
                          double usePointsDiscountAmount = 0.0;
                          double totalTax = 0.0;
                          double totalTiredPricing = 0.0;
                          double totalDiscountOnProducts = 0.0;

                          double officialDeliveryFees = double.parse(
                              splashProvider.configModel!.deliveryCharge ?? "0.0");
                          double deliveryCharge =
                              haveFreeDelivery ? 0.0 : officialDeliveryFees;
                          double ppuPurchase = double.parse(
                              splashProvider.configModel!.ppuPurchase ?? "0.0");
                          double ppuEarn = double.parse(
                              splashProvider.configModel!.ppuEarn ?? "0.0");
                          double totalPointsDiscountAmount =
                              totalUserPoints * ppuPurchase;

                          print("ppuPurchase == $ppuPurchase");
                          print("ppuEarn == $ppuEarn");

                          print(
                              "totalPointsDiscountAmount == $totalPointsDiscountAmount");
                          double remainingUserPoints = totalUserPoints;

                          cartProvider.cartList.forEach((cart) {
                            ProductModel product = cart.product!;

                            List<TiredPricingModel> tiredPricing =
                                product.tiredPricing ?? [];

                            if(product.isService==1){
                              hasServiceOnCart = true ;
                            }

                            TiredPricingModel? tiredPricingModel;
                            ProductPlanDiscountModel? productPlanDiscountModel;
                            if (isLoggedIn &&
                                profileProvider.userInfoModel != null &&
                                profileProvider.userInfoModel!.exclusiveDiscounts ==
                                    1) {
                              List<ProductPlanDiscountModel> productPlanDiscount =
                                  product.productPlanDiscount ?? [];

                              try {
                                productPlanDiscountModel =
                                    productPlanDiscount.firstWhere(
                                  (discount) =>
                                      discount.planId ==
                                      profileProvider
                                          .userInfoModel!.userSubscription!.planId,
                                  orElse: () => ProductPlanDiscountModel(),
                                );
                              } catch (e) {
                                print("Error finding discount: $e");
                                productPlanDiscountModel = ProductPlanDiscountModel();
                              }
                            }
                            double originalPrice = product.price!;

                            double priceAfterProductPlanDiscount =
                                productPlanDiscountModel != null &&
                                        productPlanDiscountModel.planId != null
                                    ? PriceConverter.convertWithDiscount(
                                        context,
                                        originalPrice,
                                        productPlanDiscountModel.discount!,
                                        productPlanDiscountModel.discountType!)
                                    : originalPrice;
                            print(
                                "priceAfterProductPlanDiscount -- $priceAfterProductPlanDiscount");
                            double priceAfterNormalDiscountOnProduct =
                                PriceConverter.convertWithDiscount(
                                    context,
                                    originalPrice,
                                    product.discount!,
                                    product.discountType!);
                            print(
                                "priceAfterNormalDiscountOnProduct -- $priceAfterNormalDiscountOnProduct");

                            double priceAfterTiredPricing =
                                PriceConverter.getProductFinalPrice(
                                        context,
                                        tiredPricing,
                                        originalPrice,
                                        cart.quantity ?? 1) ??
                                    0.0;
                            print(
                                "priceAfterTiredPricing -- $priceAfterTiredPricing");
                            double finalPriceWithoutQuantity = min(
                              priceAfterProductPlanDiscount,
                              min(priceAfterNormalDiscountOnProduct,
                                  priceAfterTiredPricing),
                            );
                            print(
                                "finalPriceWithoutQuantity -- $finalPriceWithoutQuantity");
                            double finalPriceWithQuantity =
                                finalPriceWithoutQuantity * cart.quantity!;
                            double originalPriceWithQuantity =
                                originalPrice * cart.quantity!;
                            if (finalPriceWithoutQuantity == priceAfterTiredPricing) {
                              tiredPricingModel =
                                  PriceConverter.getMatchedTieredPricingModel(
                                      context, tiredPricing, cart.quantity ?? 1);
                            } else if (finalPriceWithoutQuantity ==
                                priceAfterProductPlanDiscount) {
                              totalDiscountOnProducts = totalDiscountOnProducts +
                                  (PriceConverter.calculateDiscountAmount(
                                          context,
                                          originalPrice,
                                          productPlanDiscountModel!.discount ?? 0.0,
                                          productPlanDiscountModel.discountType ??
                                              "amount") *
                                      cart.quantity!);
                            } else if (finalPriceWithoutQuantity ==
                                priceAfterNormalDiscountOnProduct) {
                              totalDiscountOnProducts = totalDiscountOnProducts +
                                  (PriceConverter.calculateDiscountAmount(
                                          context,
                                          originalPrice,
                                          product.discount ?? 0.0,
                                          product.discountType ?? "amount") *
                                      cart.quantity!);
                            }

                            double taxAmount =
                                    PriceConverter.calculateTaxAmount(
                                            finalPriceWithoutQuantity,
                                            product.tax!,
                                            product.taxType!)
                                    *

                                cart.quantity!;

                            print(
                                "finalPriceWithQuantity == $finalPriceWithQuantity");

                            totalProductsPrice =
                                totalProductsPrice + finalPriceWithQuantity;
                            totalTax = totalTax + taxAmount;
                            totalItemsPriceAfterDiscOnProducts =
                                totalItemsPriceAfterDiscOnProducts +
                                    originalPriceWithQuantity;

                            totalTiredPricing = totalTiredPricing +
                                (tiredPricingModel != null &&
                                        tiredPricingModel.discountPrice != null
                                    ? (double.parse(
                                            tiredPricingModel.discountPrice!) *
                                        cart.quantity!)
                                    : 0);
                            totalItemsPrice =
                                totalItemsPrice + (originalPriceWithQuantity);
                          });


                          print("hasServiceOnCart === $hasServiceOnCart");
                          subTotalOrderPrice = totalProductsPrice + totalTax;
                          if (couponProvider.couponDiscount == null &&
                              !couponProvider.useLoyaltyPoints!) {
                            print("CASE 1");
                            subTotalOrderPrice = subTotalOrderPrice;
                          } else if (couponProvider.couponDiscount != null &&
                              !couponProvider.useLoyaltyPoints!) {
                            couponDiscountAmount = Helpers.applyDiscount(
                                couponProvider.couponDiscount!,
                                (totalProductsPrice + totalTax));
                            subTotalOrderPrice =
                                subTotalOrderPrice - couponDiscountAmount;
                            print("CASE 2");
                          } else if (couponProvider.couponDiscount == null &&
                              couponProvider.useLoyaltyPoints!) {
                            usePointsDiscountAmount =
                                couponProvider.useLoyaltyPointsAmount ?? 0.0;
                            subTotalOrderPrice =
                                subTotalOrderPrice - usePointsDiscountAmount;
                            print("CASE 3");
                            print(
                                "usePointsDiscountAmount == $usePointsDiscountAmount");
                          } else if (couponProvider.couponDiscount != null &&
                              couponProvider.useLoyaltyPoints!) {
                            usePointsDiscountAmount =
                                couponProvider.useLoyaltyPointsAmount ?? 0.0;
                            couponDiscountAmount = Helpers.applyDiscount(
                                couponProvider.couponDiscount!,
                                (totalProductsPrice + totalTax));
                            subTotalOrderPrice = subTotalOrderPrice -
                                usePointsDiscountAmount -
                                couponDiscountAmount;
                            print("CASE 4");
                          }

                          totalOrderPrice =
                              (subTotalOrderPrice > 0 ? subTotalOrderPrice : 0) +
                                  deliveryCharge;

                          if (couponProvider.useLoyaltyPoints!) {
                            double usedPoints =
                                couponProvider.useLoyaltyPointsAmount ?? 0.0;
                            if (usedPoints <= remainingUserPoints) {
                              remainingUserPoints = remainingUserPoints -
                                  (totalPointsDiscountAmount / ppuPurchase);
                            } else {
                              remainingUserPoints = 0;
                            }
                          }

                          print("totalOrderPrice == $totalOrderPrice");
                          print(
                              "totalDiscountOnProducts == $totalDiscountOnProducts");
                          print("remainingUserPoints == $remainingUserPoints");

                          return cartProvider.cartList.isNotEmpty
                              ? Column(
                                  children: [
                                    Expanded(
                                      child: Scrollbar(
                                        child: SingleChildScrollView(
                                          padding:  EdgeInsets.all(10.r),
                                          physics: const BouncingScrollPhysics(),
                                          child: Center(
                                            child: SizedBox(
                                              width:
                                                  MediaQuery.of(context).size.width,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ListView.builder(
                                                      padding: EdgeInsets.zero,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: cartProvider
                                                          .cartList.length,
                                                      itemBuilder: (context, index) =>
                                                          CartProductWidget(
                                                              cart: cartProvider
                                                                  .cartList[index],
                                                              cartIndex: index)),
                                                  ChooseDeliveryAddressView(),
                                                  DiscountView(
                                                      totalPointsDiscount:
                                                          totalPointsDiscountAmount,
                                                      couponDiscountAmount:
                                                          couponDiscountAmount,
                                                      totalOrderPrice:
                                                          totalOrderPrice),
                                                  _buildDetailRow(
                                                      context,
                                                      'items_price',
                                                      '$currency${Helpers.formatTextWithNum(totalItemsPrice.toString())}'),
                                                  _buildDetailRow(context, 'tax',
                                                      '$currency${Helpers.formatTextWithNum(totalTax.toString())}'),
                                                  _buildDetailRow(
                                                      context,
                                                      'delivery_fee',
                                                      '(+) $currency$deliveryCharge'),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15.w,
                                                            vertical: 5.h),
                                                    child: Divider(
                                                      color:
                                                          ColorResources.getTextColor(
                                                                  context)
                                                              .withOpacity(0.4),
                                                    ),
                                                  ),
                                                  _buildDetailRow(
                                                      context,
                                                      'total_products_discount',
                                                      '(-) $currency${Helpers.formatTextWithNum(totalDiscountOnProducts.toString())}'),
                                                  _buildDetailRow(
                                                      context,
                                                      'tiered_pricing_discount',
                                                      '(-) $currency${Helpers.formatTextWithNum(totalTiredPricing.toString())}'),
                                                  if (couponDiscountAmount != 0.0)
                                                    _buildDetailRow(
                                                        context,
                                                        'coupon_discount',
                                                        '(-)  $currency${Helpers.formatTextWithNum(couponDiscountAmount.toString())}'),
                                                  if (usePointsDiscountAmount != 0.0)
                                                    _buildDetailRow(
                                                        context,
                                                        'loyalty_points_discount',
                                                        '(-)  $currency${Helpers.formatTextWithNum(usePointsDiscountAmount.toString())}'),
                                                  // if (haveFreeDelivery)
                                                  //   _buildDetailRow(
                                                  //       context,
                                                  //       'free_delivery',
                                                  //       '(-)  $currency${Helpers.formatTextWithNum(officialDeliveryFees.toString())}'),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15.w,
                                                            vertical: 5.h),
                                                    child: Divider(
                                                      color:
                                                          ColorResources.getTextColor(
                                                                  context)
                                                              .withOpacity(0.4),
                                                    ),
                                                  ),
                                                  _buildDetailRow(
                                                      context,
                                                      'total_price',
                                                      '$currency${Helpers.formatTextWithNum(totalOrderPrice.toString())}',
                                                      color: ColorResources
                                                          .getPrimaryColor(context)),
                                                  if (couponProvider
                                                      .useLoyaltyPoints!)
                                                    Center(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(vertical: 10.h),
                                                        child:Text(
                                                          '"${getTranslated('you_have', context)} ${Helpers.formatTextWithNum(totalUserPoints.toString())} ${getTranslated('points', context)}, ($currency${Helpers.formatTextWithNum(usePointsDiscountAmount.toString())} ${getTranslated('off', context)}), ${getTranslated('remaining_points:', context)} ${Helpers.formatTextWithNum((remainingUserPoints).toString())}"',
                                                          textAlign: TextAlign.center,
                                                          style: AppTextStyles.h6(context).copyWith(
                                                            color: ColorResources.getSecondaryColor(context),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(10.r),
                                      child: CustomButton(
                                        text: getTranslated('place_order', context),
                                        onTap: () {
                                          if (authProvider.getUserAddressId() == 0) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'select_address_required',
                                                    context),
                                                context);
                                            return;
                                          }
                                          List<CartModel>? cartList =
                                              cartProvider.cartList;
                                          List<ProductCart> carts =
                                              cartList.map((cart) {
                                            ProductModel product = cart.product!;
                                            List<TiredPricingModel> tiredPricing =
                                                product.tiredPricing ?? [];

                                            TiredPricingModel? tiredPricingModel;
                                            ProductPlanDiscountModel?
                                                productPlanDiscountModel;
                                            if (isLoggedIn &&
                                                profileProvider.userInfoModel !=
                                                    null &&
                                                profileProvider.userInfoModel!
                                                        .exclusiveDiscounts ==
                                                    1) {
                                              List<ProductPlanDiscountModel>
                                                  productPlanDiscount =
                                                  product.productPlanDiscount ?? [];

                                              try {
                                                productPlanDiscountModel =
                                                    productPlanDiscount.firstWhere(
                                                  (discount) =>
                                                      discount.planId ==
                                                      profileProvider.userInfoModel!
                                                          .userSubscription!.planId,
                                                  orElse: () =>
                                                      ProductPlanDiscountModel(),
                                                );
                                              } catch (e) {
                                                print("Error finding discount: $e");
                                                productPlanDiscountModel =
                                                    ProductPlanDiscountModel();
                                              }
                                            }
                                            double originalPrice = product.price!;

                                            double priceAfterProductPlanDiscount =
                                                productPlanDiscountModel != null &&
                                                        productPlanDiscountModel
                                                                .planId !=
                                                            null
                                                    ? PriceConverter
                                                        .convertWithDiscount(
                                                            context,
                                                            originalPrice,
                                                            productPlanDiscountModel
                                                                .discount!,
                                                            productPlanDiscountModel
                                                                .discountType!)
                                                    : originalPrice;
                                            print(
                                                "priceAfterProductPlanDiscount -- $priceAfterProductPlanDiscount");
                                            double priceAfterNormalDiscountOnProduct =
                                                PriceConverter.convertWithDiscount(
                                                    context,
                                                    originalPrice,
                                                    product.discount!,
                                                    product.discountType!);
                                            print(
                                                "priceAfterNormalDiscountOnProduct -- $priceAfterNormalDiscountOnProduct");

                                            double priceAfterTiredPricing =
                                                PriceConverter.getProductFinalPrice(
                                                        context,
                                                        tiredPricing,
                                                        originalPrice,
                                                        cart.quantity ?? 1) ??
                                                    0.0;
                                            print(
                                                "priceAfterTiredPricing -- $priceAfterTiredPricing");
                                            double finalPriceWithoutQuantity = min(
                                              priceAfterProductPlanDiscount,
                                              min(priceAfterNormalDiscountOnProduct,
                                                  priceAfterTiredPricing),
                                            );
                                            print(
                                                "finalPriceWithoutQuantity -- $finalPriceWithoutQuantity");
                                            double finalPriceWithQuantity =
                                                finalPriceWithoutQuantity *
                                                    cart.quantity!;
                                            double originalPriceWithQuantity =
                                                originalPrice * cart.quantity!;
                                            double discountAmount = 0.0;
                                            if (finalPriceWithoutQuantity ==
                                                priceAfterTiredPricing) {
                                              tiredPricingModel = PriceConverter
                                                  .getMatchedTieredPricingModel(
                                                      context,
                                                      tiredPricing,
                                                      cart.quantity ?? 1);
                                            } else if (finalPriceWithoutQuantity ==
                                                priceAfterProductPlanDiscount) {
                                              discountAmount = PriceConverter
                                                      .calculateDiscountAmount(
                                                          context,
                                                          originalPrice,
                                                          productPlanDiscountModel!
                                                                  .discount ??
                                                              0.0,
                                                          productPlanDiscountModel
                                                                  .discountType ??
                                                              "amount") *
                                                  cart.quantity!;
                                            } else if (finalPriceWithoutQuantity ==
                                                priceAfterNormalDiscountOnProduct) {
                                              discountAmount = PriceConverter
                                                      .calculateDiscountAmount(
                                                          context,
                                                          originalPrice,
                                                          product.discount ?? 0.0,
                                                          product.discountType ??
                                                              "amount") *
                                                  cart.quantity!;
                                            }
                                            double taxAmount = double.parse(Helpers
                                                    .formatTextWithNum(PriceConverter
                                                            .convertPercentageToAmount(
                                                                finalPriceWithQuantity,
                                                                product.tax!)
                                                        .toString())) *
                                                cart.quantity!;

                                            return ProductCart(
                                              productId: product.id.toString(),
                                              price:
                                                  finalPriceWithQuantity.toString(),
                                              discountAmount: discountAmount,
                                              quantity: cart.quantity!,
                                              taxAmount: taxAmount,
                                              tieredPricing: tiredPricingModel,
                                            );
                                          }).toList();

                                          PlaceOrderBody placeOrder = PlaceOrderBody(
                                              cart: carts,
                                              couponDiscountAmount:
                                                  couponDiscountAmount,
                                              usePointsDiscountAmount:
                                                  usePointsDiscountAmount,
                                              couponDiscountTitle: '',
                                              couponCode: couponProvider
                                                      .couponDiscount?.code ??
                                                  "",
                                              totalTaxAmount: totalTax.toString(),
                                              orderAmount: totalOrderPrice,
                                              deliveryAddressId:
                                                  authProvider.getUserAddressId()!,
                                              orderType: 'cart',
                                              paymentMethod: '',
                                              orderNote: "",
                                              usePoints:
                                                  couponProvider.useLoyaltyPoints!
                                                      ? 1
                                                      : 0,
                                              remainingUserPoints:
                                                  remainingUserPoints,
                                              deliveryCharge: deliveryCharge,
                                              priorityDelivery: profileProvider
                                                      .userInfoModel!
                                                      .priorityBulkOrderFulfillment ??
                                                  0, cardId: '', deliveryDate: '', deliveryTime: '');

                                          print(
                                              "placeOrder == ${placeOrder.toJson()}");

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    CheckoutScreen(
                                                        orderBody: placeOrder)),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : NoDataFoundView(text: 'cart_is_empty', showIcon: false);
                        },
                      ),
                    )
                  : NotLoggedInScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String labelKey, String value,
      {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            getTranslated(labelKey, context),
            style: AppTextStyles.h4(context).copyWith(
              fontWeight: FontWeight.w600,
              color: ColorResources.getTextColor(context).withOpacity(0.9),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.h4(context).copyWith(
                fontWeight: FontWeight.w600,
                color: color ?? ColorResources.getTextColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDrawer() {
    if (mounted) {
      advancedDrawerController.showDrawer();
    }
  }

  void closeDrawer() {
    if (mounted) {
      advancedDrawerController.hideDrawer();
    }
  }
}
