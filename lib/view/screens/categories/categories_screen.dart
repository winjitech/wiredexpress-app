import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/banner_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/notification_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/set_menu_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_main_appbar.dart';
import 'package:wired_express/view/base/discount_container_widget.dart';
import 'package:wired_express/view/screens/categories/widget/categories_widget.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:wired_express/view/screens/drawer/drawer_screen.dart';
import 'package:wired_express/view/screens/home/widget/banner_view.dart';
import 'package:wired_express/view/screens/home/widget/category_view.dart';
import 'package:wired_express/view/screens/home/widget/set_menu_view.dart';
import 'package:wired_express/view/screens/search/search_screen.dart';
import 'package:wired_express/view/screens/search/widget/filter_widget.dart';
import 'package:wired_express/view/screens/shopping/shopping_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = ScrollController();
  Future<void> _loadData(BuildContext context, bool reload) async {
    if (Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!) {
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
    await Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryFeaturedList(context, reload);
    await Provider.of<SetMenuProvider>(context, listen: false)
        .getSetMenuList(context, reload);
    await Provider.of<BannerProvider>(context, listen: false)
        .getBannerList(context, reload);
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () async {});
    _loadData(context, false);
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
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 36,
            )),
      )),
      childDecoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
      controller: advancedDrawerController,
      animationCurve: Curves.easeInOutExpo,
      animationDuration: Duration(milliseconds: 400),
      backdropColor: ColorResources.SCAFFOLD_COLOR,
      drawer: DrawerScreen(),
      child: Scaffold(
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
        key: _scaffoldKey,
        appBar: CustomMainAppBar(
          fromCategory: true,
          onMenuPressed: () {
            showDrawer();
          },
          title: 'Categories',
        ),
        body: Consumer<CustomAuthProvider>(
          builder: (context, customAuthProvider, child) {
            return Scrollbar(
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                //  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: AssetImage(Images.categoryBox),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.7),
                                BlendMode.darken),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 170,
                        child: Center(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getTranslated('find_perfect', context),
                              textAlign: TextAlign.justify,
                              style: rubikMedium.copyWith(
                                  fontSize: 30, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                              minWidth: 120,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            DashboardScreen(pageIndex: 0)));
                              },
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text(
                                getTranslated('shop_now', context),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Consumer<CategoryProvider>(
                        builder: (context, category, child) {
                          return category.categoryList == null
                              ? CategoryView()
                              : category.categoryList!.length == 0
                                  ? SizedBox()
                                  : CategoryView();
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                        text: getTranslated('search_product', context),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext? context) =>
                                      SearchScreen()));
                        },
                      )
                    ],
                  ),
                )),
              ),
            );
          },
        ),
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
