import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wired_express/data/model/response/userinfo_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/banner_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/subscription_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/custom_main_appbar.dart';
import 'package:wired_express/view/screens/drawer/drawer_screen.dart';
import 'package:wired_express/view/screens/home/widget/banner_view.dart';
import 'package:wired_express/view/screens/home/widget/category_product_view.dart';
import 'package:wired_express/view/screens/nearby_electricians/nearby_electricians_screen.dart';
import 'package:wired_express/view/screens/search/widget/filter_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<void> _loadData(BuildContext context, bool reload) async {
    final authProvider =
        Provider.of<CustomAuthProvider>(context, listen: false);
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final subscriptionProvider =
        Provider.of<SubscriptionProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final wishListProvider =
        Provider.of<WishListProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final bannerProvider = Provider.of<BannerProvider>(context, listen: false);
    final placeOrder = Provider.of<PlaceOrderProvider>(context, listen: false);
    final location = Provider.of<LocationProvider>(context, listen: false);

    if (authProvider.isLoggedIn()!) {
      UserInfoModel? userInfo = profileProvider.userInfoModel;

      if (userInfo != null) {
        String? subscriptionExpireDate = userInfo.subscriptionExpireDate;
        if (subscriptionExpireDate != null) {
          DateTime expireDate = DateTime.parse(subscriptionExpireDate);
          DateTime now = DateTime.now();
          DateTime yesterday = DateTime(now.year, now.month, now.day)
              .subtract(const Duration(days: 1));

          bool isExpiredYesterday = expireDate.year == yesterday.year &&
              expireDate.month == yesterday.month &&
              expireDate.day == yesterday.day;
          if (isExpiredYesterday) {
            String? subscriptionId =
                userInfo.userSubscription?.paypalSubscriptionId ??
                    userInfo.userSubscription?.stripeSubscriptionId;
            if (subscriptionId != null &&
                userInfo.subscriptionWayType != 'stripe') {
              subscriptionProvider
                  .subscriptionDetails(context, subscriptionId)
                  .then((_) {
                if (subscriptionProvider.subscriptionStatus == "CANCELLED") {
                  subscriptionProvider
                      .cancelSubscription(context, subscriptionId)
                      .then((_) => profileProvider.getUserInfo(context));
                }
              });
            } else if (userInfo.subscriptionWayType == 'stripe') {
              subscriptionProvider.stripeSubscriptionDetails(context).then((_) {
                if (subscriptionProvider.subscriptionStatus == "canceled") {
                  subscriptionProvider
                      .stripeCancelSubscription(context)
                      .then((_) => profileProvider.getUserInfo(context));
                }
              });
            }
          }
        }

        // if (userInfo.freeDelivery == 1) {
        //   _showFreeDeliverySnackBar();
        // }

        if (userInfo.nearbyElectricians == 1 &&
            location.addressList?.isNotEmpty == true) {
          final userAddressId = authProvider.getUserAddressId();
          final matchedAddress = location.addressList!.firstWhere(
            (element) =>
                element.id ==
                (userAddressId == 0
                    ? location.addressList![0].id
                    : userAddressId),
            orElse: () => location.addressList![0],
          );

          splashProvider.getNearbyElectricians(
            context,
            matchedAddress.latitude!,
            matchedAddress.longitude!,
          );
        }
      }

      subscriptionProvider.getSubscriptionPlans(context);
      profileProvider.getUserInfo(context);

      location.initAddressList(context);
      wishListProvider.initWishListProductIds(context);
      cartProvider.initCartList(context);
      cartProvider.initCartListProductIds(context);
    }

    categoryProvider.getCategoryList(context, reload);
    bannerProvider.getBannerList(context, reload);
    placeOrder.getRunningOrderList(context);

    if (placeOrder.runningOrderList?.isNotEmpty ?? false) {
      await placeOrder.runningOrderList!.first;
    }

    await categoryProvider.getCategoryFeaturedList(context, reload).then((_) {
      final featuredList = categoryProvider.categoryFeaturedList;
      if (featuredList?.isNotEmpty ?? false) {
        final firstCategory = featuredList!.first;
        categoryProvider.setCategory(firstCategory);
        categoryProvider.clearCategoryProductListOffset();
        categoryProvider.getCategoryProductList(
            context, "1", firstCategory.id.toString());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 0), () async => _loadData(context, false));
  }

  final advancedDrawerController = AdvancedDrawerController();
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return AdvancedDrawer(
        rtlOpening: false,
        openRatio: 0.55,
        openScale: 0.80,
        backdrop: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: IconButton(
                    onPressed: () => closeDrawer(),
                    icon: Icon(Icons.close,
                        color: ColorResources.getTextColor(context),
                        size: 36)))),
        childDecoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
        controller: advancedDrawerController,
        animationCurve: Curves.easeInOutExpo,
        animationDuration: const Duration(milliseconds: 400),
        backdropColor: ColorResources.getTextFieldFillColor(context),
        drawer: DrawerScreen(),
        child: Scaffold(
            backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
            key: _scaffoldKey,
            appBar: CustomMainAppBar(
                onMenuPressed: () => showDrawer(),
                title: getTranslated('shopping', context)),
            body: Consumer4<CategoryProvider, ProfileProvider, SplashProvider,
                    CustomAuthProvider>(
                builder: (context, categoryProvider, profileProvider,
                    splashProvider, authProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Consumer<BannerProvider>(
                          builder: (context, banner, child) {
                            return BannerView();
                          },
                        ),
                      ),
                      SliverToBoxAdapter(child: Consumer4<
                              CategoryProvider,
                              ProfileProvider,
                              SplashProvider,
                              CustomAuthProvider>(
                          builder: (context, categoryProvider, profileProvider,
                              splashProvider, authProvider, child) {
                        return Column(children: [
                          const SizedBox(height: 20),
                          if (authProvider.isLoggedIn()! &&
                              profileProvider
                                      .userInfoModel?.hasActiveSubscription ==
                                  true)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.amber[700],
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: ColorResources.getBoxShadow(
                                              context),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2))
                                    ]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.white, size: 24),
                                    const SizedBox(width: 10),
                                    Text(
                                        getTranslated(
                                            'your_active_subscription_plan_place',
                                            context),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16))
                                  ],
                                ),
                              ),
                            ),
                          if (authProvider.isLoggedIn()! &&
                              profileProvider
                                      .userInfoModel?.nearbyElectricians ==
                                  1 &&
                              splashProvider.nearbyElectriciansList != null &&
                              splashProvider.nearbyElectriciansList!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            NearbyElectriciansScreen(
                                                electricians: splashProvider
                                                    .nearbyElectriciansList!))),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color:
                                          ColorResources.getCardColor(context),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: ColorResources.getBoxShadow(
                                                context),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 2))
                                      ]),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          getTranslated(
                                              'nearby_electricians', context),
                                          style: TextStyle(
                                              color:
                                                  ColorResources.getTextColor(
                                                      context),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          categoryProvider.categoryFeaturedList == null
                              ? const SizedBox()
                              : FilterWidget(categoryProvider),
                          const SizedBox(height: 20),
                          CategoryProductView(
                            scrollController: scrollController,
                          ),
                        ]);
                      })),
                    ]),
              );
            })));
  }

  void showDrawer() {
    if (mounted) {
      Provider.of<PlaceOrderProvider>(context, listen: false)
          .getRunningOrderList(context)
          .then((value) =>
              Provider.of<PlaceOrderProvider>(context, listen: false)
                          .runningOrderList ==
                      null
                  ? Provider.of<ProfileProvider>(context, listen: false)
                      .getUserInfo(context)
                  : Provider.of<PlaceOrderProvider>(context, listen: false)
                      .runningOrderList![0]);
      advancedDrawerController.showDrawer();
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }
  }

  void closeDrawer() {
    if (mounted) {
      advancedDrawerController.hideDrawer();
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }
  }

  void _showFreeDeliverySnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.zero,
        content: Shimmer(
          duration: const Duration(seconds: 2),
          enabled: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: const Icon(
                      Icons.local_shipping,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    getTranslated('you_have_free_delivery', context),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 20),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}
