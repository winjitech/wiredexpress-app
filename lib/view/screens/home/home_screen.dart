import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/banner_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/set_menu_provider.dart';
import 'package:wired_express/provider/subscription_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_main_appbar.dart';
import 'package:wired_express/view/base/no_data_screen.dart';
import 'package:wired_express/view/base/product_widget.dart';
import 'package:wired_express/view/screens/drawer/drawer_screen.dart';
import 'package:wired_express/view/screens/home/widget/banner_view.dart';
import 'package:wired_express/view/screens/search/widget/filter_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = ScrollController();
  Future<void> _loadData(BuildContext context, bool reload) async {
    if (Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!) {
      await Provider.of<SubscriptionProvider>(context, listen: false).getSubscriptionPlans(context);
      await Provider.of<ProfileProvider>(context, listen: false)
          .getUserInfo(context);
    }
    await Provider.of<WishListProvider>(context, listen: false)
        .initWishListProductIds(context);
    await Provider.of<CartProvider>(context, listen: false)
        .initCartList(context);

    await Provider.of<CartProvider>(context, listen: false)
        .initCartListProductIds(context);
    await Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryListFull(context, reload);
    await Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryList(context, reload);
    await Provider.of<SetMenuProvider>(context, listen: false)
        .getSetMenuList(context, reload);
    await Provider.of<BannerProvider>(context, listen: false)
        .getBannerList(context, reload);

    await Provider.of<PlaceOrderProvider>(context, listen: false)
        .getRunningOrderList(context);
    Provider.of<PlaceOrderProvider>(context, listen: false).runningOrderList ==
        null ||
        Provider.of<PlaceOrderProvider>(context, listen: false)
            .runningOrderList!
            .isEmpty
        ? null
        : await Provider.of<PlaceOrderProvider>(context, listen: false)
        .runningOrderList![0];

    await Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryFeaturedList(context, reload)
        .then((value) {
      if (Provider.of<CategoryProvider>(context, listen: false)
          .categoryFeaturedList!
          .length !=
          0) {
        Provider.of<CategoryProvider>(context, listen: false).setCategory(
            Provider.of<CategoryProvider>(context, listen: false)
                .categoryFeaturedList![0]
                .name!);

        Provider.of<CategoryProvider>(context, listen: false)
            .getCategoryProductList(
            context,
            Provider.of<CategoryProvider>(context, listen: false)
                .categoryFeaturedList![0]
                .id
                .toString());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 0), () async {  _loadData(context, false);});

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
                padding: const EdgeInsets.all(15),
                child: IconButton(
                    onPressed: () {
                      closeDrawer();
                    },
                    icon: const Icon(Icons.close,
                        color: Colors.white, size: 36)))),
        childDecoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
        controller: advancedDrawerController,
        animationCurve: Curves.easeInOutExpo,
        animationDuration: const Duration(milliseconds: 400),
        backdropColor: ColorResources.getScaffoldColor(context),
        drawer: DrawerScreen(),
        child: Scaffold(
            backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
            key: _scaffoldKey,
            appBar: CustomMainAppBar(
                onMenuPressed: () => showDrawer(),
                title: getTranslated('shopping', context)),
            body: Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
                  return Scrollbar(
                      child: SingleChildScrollView(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          //  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(children: [
                                    Consumer<BannerProvider>(
                                        builder: (context, banner, child) {
                                          return banner.bannerList == null
                                              ? BannerView()
                                              : banner.bannerList!.length == 0
                                              ? const SizedBox()
                                              : BannerView();
                                        }),
                                    const SizedBox(height: 20),
                                    categoryProvider.categoryFeaturedList == null
                                        ? const SizedBox()
                                        : FilterWidget(categoryProvider),
                                    const SizedBox(height: 20),
                                    // Text(categoryProvider.selectedCategory
                                    //     .toString()),

                                    Provider.of<CategoryProvider>(context,
                                        listen: false)
                                        .getCategoryLoading ==
                                        true &&
                                        Provider.of<CategoryProvider>(context,
                                            listen: false)
                                            .categoryFeaturedList!
                                            .length !=
                                            0
                                        ?CustomCircularIndicator(color: ColorResources.getScaffoldColor(context))
                                        : Consumer<CategoryProvider>(
                                        builder: (context, category, child) {
                                          return category.selectedCategory == null
                                              ?  CustomCircularIndicator(color: ColorResources.getScaffoldColor(context))
                                              : category.categoryProductList!
                                              .isEmpty
                                              ? NoDataScreen()
                                              : GridView.builder(
                                            gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisSpacing: 15,
                                              mainAxisSpacing: 0,
                                              mainAxisExtent: 250,
                                              crossAxisCount: 2,
                                            ),
                                            itemCount: category
                                                .categoryProductList!
                                                .length >
                                                10
                                                ? 10
                                                : category
                                                .categoryProductList!
                                                .length,
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_SMALL),
                                            physics:
                                            const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder:
                                                (BuildContext context,
                                                int index) {
                                              return ProductWidget(
                                                  product: category
                                                      .categoryProductList![
                                                  index]);
                                            },
                                          );
                                        })
                                  ])))));
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
