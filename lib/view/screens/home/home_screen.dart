import 'package:hive_flutter/hive_flutter.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/notification_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/view/base/border_button.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/screens/notification/notification_screen.dart';
import 'package:wired_express/view/screens/rating/RateAppScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/helper/product_type.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/banner_provider.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/set_menu_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:wired_express/view/base/title_widget.dart';
import 'package:wired_express/view/screens/home/widget/banner_view.dart';
import 'package:wired_express/view/screens/home/widget/category_view.dart';
import 'package:wired_express/view/screens/home/widget/main_slider.dart';
import 'package:wired_express/view/screens/home/widget/product_view.dart';
import 'package:wired_express/view/screens/home/widget/set_menu_view.dart';
import 'package:wired_express/view/screens/menu/widget/options_view.dart';
import 'package:wired_express/view/screens/search/search_screen.dart';
import 'package:wired_express/view/screens/track/order_tracking_screen.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/theme/dark_theme.dart';
import 'package:wired_express/theme/light_theme.dart';
import 'package:provider/provider.dart';

String LanguageStr = '';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();

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
    await Provider.of<SetMenuProvider>(context, listen: false)
        .getSetMenuList(context, reload);
    await Provider.of<BannerProvider>(context, listen: false)
        .getBannerList(context, reload);
  }

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    final ScrollController _scrollController = ScrollController();
    _loadData(context, false);

    if (Provider.of<SplashProvider>(context, listen: false)
            .configModel
            ?.openingHours !=
        null) {
      bool isAvailable = false;
      final currentTime = DateTime.now();
      final currentHour = currentTime.hour;

      for (final openingHours
          in Provider.of<SplashProvider>(context, listen: false)
              .configModel!
              .openingHours!) {
        final start = openingHours.start?.split(':');
        final end = openingHours.end?.split(':');

        if (start != null &&
            end != null &&
            start.length == 2 &&
            end.length == 2) {
          final startHour = int.parse(start[0]);
          final startMinute = int.parse(start[1]);
          final endHour = int.parse(end[0]);
          final endMinute = int.parse(end[1]);

          if ((currentHour > startHour ||
                  (currentHour == startHour &&
                      currentTime.minute >= startMinute)) &&
              (currentHour < endHour ||
                  (currentHour == endHour &&
                      currentTime.minute <= endMinute))) {
            isAvailable = true;
            break;
          }
        }
      }

      if (!isAvailable) {
        Future.delayed(Duration(milliseconds: 500), () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              dismissDirection: DismissDirection.up,
              content: Text(
                'Sorry, the store is currently closed',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        });
      }
    }

    LanguageStr = getTranslated('set_language', context);

    String _setLogoImage() {
      return Images.logo;
    }

    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      key: drawerGlobalKey,
      endDrawerEnableOpenDragGesture: false,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
      //   },
      //   child: Icon(Icons.brightness_4),
      // ),
      drawer: ResponsiveHelper.isTab(context)
          ? Drawer(child: OptionsView(onTap: () {}))
          : SizedBox(),
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              child: MainAppBar(), preferredSize: Size.fromHeight(80))
          : null,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadData(context, true);
          },
          backgroundColor: ColorResources.getPrimaryColor(context),
          child: Scrollbar(
            controller: _scrollController,
            child: CustomScrollView(controller: _scrollController, slivers: [
              // AppBar
              ResponsiveHelper.isDesktop(context)
                  ? SliverToBoxAdapter(child: SizedBox())
                  : SliverAppBar(
                      floating: true,
                      elevation: 0,
                      centerTitle: false,
                      automaticallyImplyLeading: false,
                      backgroundColor:
                          ColorResources.getScaffoldBackgroundColor(context),
                      pinned: ResponsiveHelper.isTab(context) ? true : false,
                      leading: ResponsiveHelper.isTab(context)
                          ? IconButton(
                              onPressed: () =>
                                  drawerGlobalKey.currentState!.openDrawer(),
                              icon: Icon(Icons.menu,
                                  color: ColorResources.getTextColor(context)),
                            )
                          : null,
                      title: Consumer<SplashProvider>(
                          builder: (context, splash, child) => Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ResponsiveHelper.isWeb()
                                      ? FadeInImage.assetNetwork(
                                          placeholder:
                                              Images.placeholder_rectangle,
                                          image: splash.baseUrls != null
                                              ? '${splash.baseUrls!.storeImageUrl}/${splash.configModel!.storeLogo}'
                                              : '',
                                          height: 40,
                                          width: 40,
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: AssetImage(_setLogoImage()),
                                            fit: BoxFit.cover,
                                          )),
                                          width: 40.0,
                                          height: 40),
                                  SizedBox(width: 10),
                                ],
                              )),
                      actions: [
                        IconButton(
                          // onPressed: () => Navigator.pushNamed(
                          //     context, Routes.getNotificationRoute()),
                          onPressed: () async {
                            await Provider.of<NotificationProvider>(context,
                                    listen: false)
                                .initNotificationList(context)
                                .then((value) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext? context) =>
                                            NotificationScreen())));
                          },
                          icon: Icon(Icons.notifications,
                              color: ColorResources.getTextColor(context)),
                        ),
                      ],
                    ),

              // Search Button
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(
                    child: Center(
                  child: InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, Routes.getSearchRoute()), // type 'Null' is not a subtype of type 'Handler'
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext? context) =>
                                  SearchScreen()));
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      color: ColorResources.getScaffoldBackgroundColor(context),
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_SMALL,
                          vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorResources.getSearchBg(context),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL),
                              child: Icon(
                                Icons.search,
                                size: 25,
                                color: ColorResources.getTextColor(context),
                              )),
                          Expanded(
                            child: Text(
                                getTranslated('search_items_here', context),
                                style: rubikRegular.copyWith(
                                  fontSize: 12,
                                  color: ColorResources.getTextColor(context),
                                )),
                          )
                        ]),
                      ),
                    ),
                  ),
                )),
              ),

              SliverToBoxAdapter(
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // _isLoggedIn?
                          // Provider.of<LocationProvider>(context, listen: false)
                          //             .zoneLoading ==
                          //         true
                          //     ? Center(
                          //         child: CircularProgressIndicator(
                          //             valueColor: AlwaysStoppedAnimation<Color>(
                          //                 Colors.redAccent)))
                          //     : Center(
                          //         child: ElevatedButton(
                          //             onPressed: () {
                          //               Provider.of<LocationProvider>(context,
                          //                       listen: false)
                          //                   .getZone(
                          //                       context,
                          //                       40.416268.toString(),
                          //                       "${-3.703581}");
                          //               print("-----------------------------");
                          //               print("zone id => ${ Provider.of<LocationProvider>(context,
                          //                   listen: false).zoneList!.id}");      print("-----------------------------");
                          //
                          //             },
                          //             child: Text("zones")),
                          //       ):SizedBox(),
                          ResponsiveHelper.isDesktop(context)
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      top: Dimensions.PADDING_SIZE_DEFAULT),
                                  child: MainSlider(),
                                )
                              : SizedBox(),
                          Consumer<CategoryProvider>(
                            builder: (context, category, child) {
                              return category.categoryList == null
                                  ? CategoryView()
                                  : category.categoryList!.length == 0
                                      ? SizedBox()
                                      : CategoryView();
                            },
                          ),
                          Consumer<SetMenuProvider>(
                            builder: (context, setMenu, child) {
                              return setMenu.setMenuList == null
                                  ? SetMenuView()
                                  : setMenu.setMenuList!.length == 0
                                      ? SizedBox()
                                      : SetMenuView();
                            },
                          ),
                          ResponsiveHelper.isDesktop(context)
                              ? SizedBox()
                              : Consumer<BannerProvider>(
                                  builder: (context, banner, child) {
                                    return banner.bannerList == null
                                        ? BannerView()
                                        : banner.bannerList!.length == 0
                                            ? SizedBox()
                                            : BannerView();
                                  },
                                ),
                          Text(
                            '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.transparent),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: TitleWidget(
                                title: getTranslated('popular_item', context)),
                          ),
                          ProductView(
                              productType: ProductType.POPULAR_PRODUCT,
                              scrollController: _scrollController),
                        ]),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
//ResponsiveHelper

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget? child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child!;
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 60 ||
        oldDelegate.minExtent != 60 ||
        child != oldDelegate.child;
  }
}
