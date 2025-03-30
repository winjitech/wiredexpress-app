import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wired_express/helper/network_info.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/screens/auth/guest_screen.dart';
import 'package:wired_express/view/screens/cart/cart_screen.dart';
import 'package:wired_express/view/screens/menu/menu_screen.dart';
import 'package:wired_express/view/screens/order/order_screen.dart';
import 'package:wired_express/view/screens/shopping/shopping_screen.dart';
import 'package:wired_express/view/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  final int? pageIndex;
  DashboardScreen({@required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  List<Widget>? _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    var box = Hive.box('myBox');
    box.put('app_review_arr', '1');
    _pageIndex = widget.pageIndex!;

    _pageController = PageController(initialPage: widget.pageIndex!);
    final bool _isLoggedIn =
    Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;

    _screens = [
      ShoppingScreen(),
      _isLoggedIn? CartScreen(): GuestScreen(),
      _isLoggedIn? OrderScreen(): GuestScreen(),
      _isLoggedIn? WishListScreen(): GuestScreen(),
      MenuScreen(onTap: (int pageIndex) {
        _setPage(pageIndex);
      }),
    ];

    if (ResponsiveHelper.isMobilePhone()) {
      NetworkInfo.checkConnectivity(_scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
        key: _scaffoldKey,
        bottomNavigationBar: ResponsiveHelper.isMobile(context)
            ? BottomNavigationBar(
                backgroundColor:
                    ColorResources.getScaffoldBackgroundColor(context),
                selectedItemColor: ColorResources.getPrimaryColor(context),
                unselectedItemColor:
                    Provider.of<ThemeProvider>(context).darkTheme
                        ? Colors.white
                        : Colors.grey[700],
                showUnselectedLabels: true,
                currentIndex: _pageIndex,
                type: BottomNavigationBarType.fixed,
                items: [
                  _barItem(
                      Icons.home_outlined, getTranslated('home', context), 0),
                  _barItem(
                      Icons.shopping_cart, getTranslated('cart', context), 1),
                  _barItem(
                      Icons.shopping_bag, getTranslated('order', context), 2),
                  _barItem(
                      Icons.favorite, getTranslated('favourite', context), 3),
                  _barItem(Icons.person_outline_rounded,
                      getTranslated('menu', context), 4)
                ],
                onTap: (int index) {
                  _setPage(index);
                },
              )
            : SizedBox(),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens!.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens![index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon,
              color: index == _pageIndex
                  ? ColorResources.getPrimaryColor(context)
                  : Provider.of<ThemeProvider>(context).darkTheme
                      ? Colors.white
                      : Colors.grey[700],
              size: 25),
          index == 1
              ? Positioned(
                  top: -7,
                  right: -7,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: Text(
                      Provider.of<CartProvider>(context)
                          .cartList
                          .length
                          .toString(),
                      style: rubikMedium.copyWith(
                          color: ColorResources.COLOR_WHITE, fontSize: 8),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
