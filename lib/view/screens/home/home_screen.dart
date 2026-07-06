import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/subscription_model.dart';
import 'package:wired_express/data/model/response/user_subscription_model.dart';
import 'package:wired_express/data/model/response/userinfo_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/home_provider.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/no_data_found_view.dart';
import 'package:wired_express/view/screens/product/widget/product_widget.dart';
import 'package:wired_express/view/base/shimmer/product_shimmer.dart';
import 'package:wired_express/view/screens/categories/widget/categories_view.dart';
import 'package:wired_express/view/screens/drawer/drawer_screen.dart';
import 'package:wired_express/view/screens/home/widget/banner_view.dart';
import 'package:wired_express/view/screens/home/widget/home_header_widget.dart';
import 'package:wired_express/view/screens/nearby_electricians/nearby_electricians_screen.dart';
import 'package:wired_express/view/screens/product/widget/featured_products_view.dart';
import 'package:wired_express/view/screens/search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    Timer(const Duration(seconds: 0), () async {
      final homeProv = Provider.of<HomeProvider>(context, listen: false);
      homeProv.loadData(context);
    });
  }
  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
  void _onScroll() async {
    if (!_scrollController.hasClients || _isLoadingMore) return;

    final prov = context.read<ProductProvider>();

    const threshold = 200.0;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - threshold) {

      if (!prov.bottomFeaturedProductsLoading &&
          (prov.featuredProductsList?.length ?? 0) <
              (prov.totalFeaturedProductsSize ?? 0)) {

        _isLoadingMore = true;

        final nextOffset =
            (int.tryParse(prov.featuredProductsOffset ?? "1") ?? 1) + 1;

        prov.showBottomFeaturedProductsLoader();

        await prov.getFeaturedProducts(
          context,
          nextOffset.toString(),
        );

        _isLoadingMore = false;
      }
    }
  }
  final advancedDrawerController = AdvancedDrawerController();
  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
        rtlOpening: false,
        openRatio: 0.55,
        openScale: 0.80,
        backdrop: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(15.r),
                child: IconButton(
                    onPressed: () => closeDrawer(),
                    icon: Icon(Icons.close,
                        color: ColorResources.getTextColor(context),
                        size: 36.sp)))),
        childDecoration:
        BoxDecoration(borderRadius: BorderRadius.circular(40.r)),
        controller: advancedDrawerController,
        animationCurve: Curves.easeInOutExpo,
        animationDuration: const Duration(milliseconds: 400),
        backdropColor: ColorResources.getTextFieldFillColor(context),
        drawer: DrawerScreen(),
        child: Scaffold(
            backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
            key: _scaffoldKey,
            body: Consumer4<ProfileProvider, CustomAuthProvider, SplashProvider, ProductProvider>(
                builder: (context, profileProv, auth,splashProv,productProv, child) {
                  UserInfoModel? userInfo = profileProv.userInfoModel;
                  UserSubscriptionPlanModel? subscription = userInfo?.userSubscription;
                  SubscriptionPlanModel? subscriptionPlan = subscription?.plan;
                  List<ProductModel>? featuredProducts = productProv.featuredProductsList??[];
                  return Column(
                    children: [
                      HomeHeaderWidget(onMenuPressed: () => showDrawer(),),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchScreen())),
                          child: Container(
                            padding: EdgeInsets.all(15.r),
                            decoration: BoxDecoration(
                              color: ColorResources.getCardColor(context),
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(
                                color: ColorResources.getHintColor(context).withOpacity(.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: ColorResources.getHintColor(context),
                                ),
                                SizedBox(width: 10.w),
                                Flexible(
                                  child: Text(
                                    getTranslated("search_products_and_services", context),
                                    style: AppTextStyles.h6(context).copyWith(
                                      color: ColorResources.getHintColor(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all( 20.r),
                            controller: _scrollController,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        text: TextSpan(
                                          style: AppTextStyles.h2(context),
                                          children: [
                                            TextSpan(
                                              text: "${getTranslated('hi', context)}, ",
                                              style: AppTextStyles.h2(context).copyWith(
                                                color: ColorResources.getTextColor(context),
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                              "${userInfo?.fName ?? getTranslated('guest', context)}!",
                                              style: AppTextStyles.h2(context).copyWith(
                                                color: ColorResources.getPrimaryColor(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    if (userInfo?.hasActiveSubscription ?? false) ...[
                                      SizedBox(width: 8.w),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: 180.w,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 5.h,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: ColorResources.getRatingColor(context),
                                            ),
                                            color: ColorResources.getRatingColor(context).withOpacity(0.04),
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.workspace_premium,
                                                color: ColorResources.getRatingColor(context),
                                                size: 16.sp,
                                              ),
                                              SizedBox(width: 4.w),

                                              Flexible(
                                                child: Text(subscriptionPlan?.name ?? "",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: AppTextStyles.h6(context),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                SizedBox(height: 20.h,),
                                BannerView(),
                                if (auth.isLoggedIn()! && userInfo?.nearbyElectricians == 1 &&
                                    splashProv.nearbyElectriciansList != null && splashProv.nearbyElectriciansList!.isNotEmpty)...[
                                  SizedBox(height: 20.h,),
                                  GestureDetector(
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NearbyElectriciansScreen(electricians: splashProv.nearbyElectriciansList!))),
                                    child: Container(
                                      padding: EdgeInsets.all(15.r),
                                      decoration: BoxDecoration(
                                          color: ColorResources.getCardColor(context),
                                          borderRadius: BorderRadius.circular(10.r),
                                          boxShadow: [BoxShadow(color: ColorResources.getBoxShadow(context), blurRadius: 5, spreadRadius: 1, offset: const Offset(0, 2))]),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            getTranslated('nearby_electricians', context),
                                            style: AppTextStyles.h4(context).copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ), ],

                                SizedBox(height: 20.h,),
                                CategoriesView(),
                                SizedBox(height: 20.h,),
                                FeaturedProductsView(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
}
