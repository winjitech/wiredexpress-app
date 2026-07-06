import 'dart:async';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:wired_express/view/screens/home/widget/home_header_widget.dart';
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
      Timer(Duration(seconds: 0), () async {
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
          padding: EdgeInsets.all(15.r),
          child: IconButton(
              onPressed: () {
                closeDrawer();
              },
              icon: Icon(
                Icons.close,
                color: ColorResources.getTextColor(context),
                size: 36.sp,
              )),
        )),
        childDecoration: BoxDecoration(borderRadius: BorderRadius.circular(40.r)),
        controller: advancedDrawerController,
        animationCurve: Curves.easeInOutExpo,
        animationDuration: Duration(milliseconds: 400),
        backdropColor: ColorResources.getTextFieldFillColor(context),
        drawer: DrawerScreen(),
        child: Scaffold(
          backgroundColor: ColorResources.getScaffoldBackgroundColor(context),

          body: Column(
            children: [
              HomeHeaderWidget(onMenuPressed: () => showDrawer(), title: 'orders'),

              Expanded(
                child: _isLoggedIn!
                    ? Consumer<OrderProvider>(
                        builder: (context, order, child) {
                          return Column(children: [
                            Padding(
                                padding:  EdgeInsets.symmetric(
                                    horizontal: 10.w),
                                child: Container(
                                  height: 45.h,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(20.r)),
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding:  EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 3.h),
                                    child: TabBar(
                                      dividerColor: Colors.transparent,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      controller: _tabController,
                                      indicatorColor: Colors.transparent,
                                      labelColor: Colors.white,
                                      unselectedLabelColor:
                                      ColorResources.getTextColor(context).withOpacity(0.6),
                                      labelStyle: AppTextStyles.h6(
                                        context,
                                        fontSize: 15.sp,
                                      ).copyWith(fontWeight: FontWeight.w600,),

                                      unselectedLabelStyle: AppTextStyles.h6(
                                        context,
                                        fontSize: 15.sp,

                                      ).copyWith( color: ColorResources.getTextColor(context).withOpacity(0.6),),
                                      indicator: BoxDecoration(
                                        color: ColorResources.getPrimaryColor(context),
                                        borderRadius: BorderRadius.circular(40.r),

                                      ),
                                      tabs: [
                                        Tab(text: getTranslated('running', context)),
                                        Tab(text: getTranslated('history', context)),
                                      ],
                                    ),
                                  ),
                                )),
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
              ),
            ],
          ),
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
