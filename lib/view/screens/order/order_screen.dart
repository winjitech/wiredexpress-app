import 'dart:async';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/theme/dark_theme.dart';
import 'package:wired_express/theme/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_main_appbar.dart';
import 'package:wired_express/view/base/not_logged_in_screen.dart';
import 'package:wired_express/view/screens/drawer/drawer_screen.dart';
import 'package:wired_express/view/screens/order/widget/history_view.dart';
import 'package:wired_express/view/screens/order/widget/order_view.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn!) {
      _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
      Timer(Duration(seconds: 1), () async {
        Provider.of<OrderProvider>(context, listen: false).clearHistoryOffset();
        Provider.of<PlaceOrderProvider>(context, listen: false)
            .getRunningOrderList(context);
      });
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
        backdropColor: ColorResources.getScaffoldColor(context),
        drawer: DrawerScreen(),
        child: Scaffold(
          backgroundColor: ColorResources.getScaffoldBackgroundColor(context),

          // backgroundColor: Colors.white,
          appBar: CustomMainAppBar(
            onMenuPressed: () => showDrawer(),
            title: getTranslated('my_order', context),
          ),
          body: _isLoggedIn!
              ? Consumer<OrderProvider>(
                  builder: (context, order, child) {
                    return Column(children: [
                      Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Align(
                                alignment: ResponsiveHelper.isDesktop(context)
                                    ? Alignment.centerLeft
                                    : Alignment.center,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: ResponsiveHelper.isDesktop(
                                                  context)
                                              ? Colors.transparent
                                              : Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      width: ResponsiveHelper.isDesktop(context)
                                          ? 350
                                          : MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: TabBar(
                                          controller: _tabController,
                                          indicatorColor: Colors.transparent,
                                          indicatorWeight: 3,
                                          labelColor: Colors.black,
                                          unselectedLabelColor: Colors.grey,
                                          unselectedLabelStyle:
                                              rubikMedium.copyWith(
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                  fontSize: 15),
                                          labelStyle: rubikMedium.copyWith(
                                              fontSize: 15,
                                              color: ColorResources
                                                  .getScaffoldColor(context)),
                                          indicator: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 10)
                                            ],
                                          ),
                                          tabs: [
                                            Tab(
                                                text: getTranslated(
                                                    'running', context)),
                                            Tab(
                                                text: getTranslated(
                                                    'history', context)),
                                          ],
                                        ),
                                      ),
                                    )))),
                      ),
                      Expanded(
                          child: TabBarView(
                        controller: _tabController,
                        children: [
                          OrderView(isRunning: true),
                          HistoryView(),
                        ],
                      )),
                    ]);
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
