import 'dart:async';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:wired_express/data/model/response/wishlist_model.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';

import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_main_appbar.dart';
import 'package:wired_express/view/base/no_data_screen.dart';
import 'package:wired_express/view/base/not_logged_in_screen.dart';
import 'package:wired_express/view/base/product_widget.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/screens/drawer/drawer_screen.dart';

class WishListScreen extends StatefulWidget {
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  TextEditingController _searchController = TextEditingController();
  List<WishlistModel> filteredWishList = [];
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 0), () {
      Provider.of<WishListProvider>(context, listen: false)
          .initWishList(context);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    filteredWishList =
        Provider.of<WishListProvider>(context, listen: false).wishList;

    super.dispose();
  }

  void filterWishList(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredWishList =
            Provider.of<WishListProvider>(context, listen: false).wishList;
      } else {
        filteredWishList = Provider.of<WishListProvider>(context, listen: false)
            .wishList
            .where((item) =>
                item.product!.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  final advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
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
                color: ColorResources.getTextColor(context),
                size: 36,
              )),
        )),
        childDecoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
        controller: advancedDrawerController,
        animationCurve: Curves.easeInOutExpo,
        animationDuration: const Duration(milliseconds: 400),
        backdropColor: ColorResources.getTextFieldFillColor(context),
        drawer: DrawerScreen(),
        child: Scaffold(
          backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
          appBar: CustomMainAppBar(
            onMenuPressed: () => showDrawer(),
            title: getTranslated('my_favourite', context),
          ),
          body: _isLoggedIn
              ? Consumer<WishListProvider>(
                  builder: (context, wishlistProvider, child) {
                    return wishlistProvider.loading
                        ? CustomCircularIndicator()
                        : wishlistProvider.wishList != null &&
                                wishlistProvider.wishList!.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  await Provider.of<WishListProvider>(context,
                                          listen: false)
                                      .initWishListProductIds(context);
                                },
                                backgroundColor:
                                    ColorResources.getPrimaryColor(context),
                                child: Scrollbar(
                                  child: SingleChildScrollView(
                                    child: Center(
                                      child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: TextField(
                                                  controller: _searchController,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 16,
                                                            horizontal: 22),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 0,
                                                                color: Colors
                                                                    .transparent)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 0,
                                                                color: Colors
                                                                    .transparent)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 0,
                                                                color: Colors
                                                                    .transparent)),
                                                    isDense: true,
                                                    prefixIcon: Icon(
                                                        color: ColorResources
                                                                .getTextColor(
                                                                    context)
                                                            .withOpacity(0.4),
                                                        Icons.search_sharp,
                                                        size: 25),
                                                    hintText: getTranslated(
                                                        'search', context),
                                                    fillColor: ColorResources
                                                        .getTextFieldFillColor(
                                                            context),
                                                    hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: ColorResources
                                                                .getTextColor(
                                                                    context)
                                                            .withOpacity(0.4),
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    filled: true,
                                                  ),
                                                  onChanged: (value) {
                                                    filterWishList(value);
                                                  },
                                                  style: TextStyle(
                                                      color: ColorResources
                                                          .getTextColor(
                                                              context),
                                                      fontSize: 12),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisSpacing: 10,
                                                    mainAxisSpacing: 10,
                                                    mainAxisExtent: 240,
                                                    crossAxisCount:
                                                        ResponsiveHelper.isTab(
                                                                context)
                                                            ? 3
                                                            : 2,
                                                  ),
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: _searchController
                                                          .text
                                                          .toString()
                                                          .isEmpty
                                                      ? wishlistProvider
                                                          .wishList!.length
                                                      : filteredWishList.length,
                                                  padding: EdgeInsets.zero,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ProductWidget(
                                                        product: _searchController
                                                                .text
                                                                .toString()
                                                                .isEmpty
                                                            ? wishlistProvider
                                                                .wishList![
                                                                    index]
                                                                .product
                                                            : filteredWishList[
                                                                    index]
                                                                .product);
                                                  },
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ),
                              )
                            : NoDataScreen();
                  },
                )
              : NotLoggedInScreen(),
        ));
  }

  void showDrawer() {
    if (mounted) {
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
