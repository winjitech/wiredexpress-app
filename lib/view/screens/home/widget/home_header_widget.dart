import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/notification_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:wired_express/view/screens/notification/notification_screen.dart';

class HomeHeaderWidget extends StatelessWidget {
  final VoidCallback? onMenuPressed;
  final String? title;

  const HomeHeaderWidget({super.key, this.onMenuPressed, this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ProfileProvider, NotificationProvider, CartProvider>(
      builder: (context, profileProvider, notificationProv, cartProv, child) {
        bool isDark =
            Provider.of<ThemeProvider>(context, listen: false).darkTheme;

        // int unreadNotificationCount =
        //     notificationProv.totalUnreadNotificationsSize ?? 0;
        // print("unreadNotificationCount == ${unreadNotificationCount}");
        return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            // color: ColorResources.getTextFieldFillColor(context),
          ),
          child: SafeArea(
            child: Row(
              children: [
                GestureDetector(
                  onTap: onMenuPressed,
                  child: Icon(
                    Icons.menu,
                    size: 30.sp,
                    color: ColorResources.getTextColor(context),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                if (title == null)
                  Image.asset(
                    isDark ? Images.logoTextNight : Images.logoTextLight,
                    height: 50.h,
                  ),
                if (title != null)
                  Text(
                    getTranslated(title!, context),
                    style: AppTextStyles.h3(context).copyWith(
                      color: ColorResources.getTextColor(context),
                    ),
                  ),
                Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NotificationsScreen(),
                    ),
                  ),
                  child: SizedBox(
                    width: 34.w,
                    height: 34.w,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: Image.asset(
                            Images.notificationIcon,
                            color: ColorResources.getTextColor(context),
                            width: 24.w,
                            height: 24.w,
                            fit: BoxFit.contain,
                          ),
                        ),

                        // Notification Badge
                        // if (unreadNotificationCount > 0)
                        // Positioned(
                        //   top: -2,
                        //   right: -2,
                        //   child: Container(
                        //     constraints: BoxConstraints(
                        //       minWidth: 16.w,
                        //       minHeight: 16.w,
                        //     ),
                        //     padding: EdgeInsets.symmetric(horizontal: 4.w),
                        //     decoration: const BoxDecoration(
                        //       color: Colors.red,
                        //       shape: BoxShape.circle,
                        //     ),
                        //     alignment: Alignment.center,
                        //     child: Text(
                        //       unreadNotificationCount > 99 ? '99+' : '$unreadNotificationCount',
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 9.sp,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DashboardScreen(pageIndex: 1),
                    ),
                  ),
                  child: SizedBox(
                    width: 34.w,
                    height: 34.w,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            size: 26.sp,
                            color: ColorResources.getTextColor(context),
                          ),
                        ),

                        if (cartProv.cartList.isNotEmpty)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              constraints: BoxConstraints(
                                minWidth: 16.w,
                                minHeight: 16.w,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              decoration: BoxDecoration(
                                color: ColorResources.getPrimaryColor(context),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  width: 1.5,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                cartProv.cartList.length > 99
                                    ? '99+'
                                    : cartProv.cartList.length.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}