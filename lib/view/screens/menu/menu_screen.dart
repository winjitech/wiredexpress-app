import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/payment_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/chat_provider.dart';
import 'package:wired_express/provider/coupon_provider.dart';
import 'package:wired_express/provider/notification_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/not_logged_in_screen.dart';
import 'package:wired_express/view/screens/address/address_screen.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';
import 'package:wired_express/view/screens/chat/chat_screen.dart';
import 'package:wired_express/view/screens/contractor_request/contractor_requests_screen.dart';
import 'package:wired_express/view/screens/coupon/coupon_screen.dart';
import 'package:wired_express/view/screens/language/choose_language_screen.dart';
import 'package:wired_express/view/screens/menu/widget/confirm_delete_account_bottom_sheet.dart';
import 'package:wired_express/view/screens/notification/notification_screen.dart';
import 'package:wired_express/view/screens/payment/payment_details_screen.dart';
import 'package:wired_express/view/screens/payment/update_card_screen.dart';
import 'package:wired_express/view/screens/profile/change_pass_screen.dart';
import 'package:wired_express/view/screens/profile/profile_screen.dart';
import 'package:wired_express/view/screens/subscription/subscription_screen.dart';
import 'package:wired_express/view/screens/support/support_screen.dart';
import 'package:wired_express/view/screens/terms/terms_screen.dart';
import 'package:wired_express/provider/home_provider.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/screens/menu/widget/sign_out_confirmation_dialog.dart';

import 'package:wired_express/view/base/custom_app_bar.dart';

class MenuScreen extends StatefulWidget {
  final Function? onTap;
  MenuScreen({this.onTap});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false)
          .getUserInfo(context)
          .then((onValue) {
        Provider.of<PaymentProvider>(context, listen: false).getPaymentCardList(
            context,
            Provider.of<ProfileProvider>(context, listen: false)
                .userInfoModel!
                .id!);
      });
    }

    return Consumer4<HomeProvider, ProfileProvider, ThemeProvider,
        PaymentProvider>(
      builder: (context, mainProvider, profileProvider, themeProvider,
              paymentProvider, child) =>
          Scaffold(
   backgroundColor:  ColorResources.getScaffoldBackgroundColor(context),
        body: Column(children: [
          CustomAppBar(title: 'profile', showBackButton: false),
          Expanded(
              child: Scrollbar(
            child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                child: mainProvider.loading ||
                        paymentProvider.getCardsLoading!
                    ? const CustomCircularIndicator()
                    : Center(
                        child: Padding(
                          padding: EdgeInsets.all(15.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              if (_isLoggedIn)
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    if (profileProvider
                                            .userInfoModel!.image !=
                                        null)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.w),
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50.r),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${profileProvider.userInfoModel!.image}',
                                                  ),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    if (profileProvider
                                            .userInfoModel!.fName !=
                                        null)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.w),
                                        child: Text(
                                          '${getTranslated('hello', context)}, ${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                                          style: AppTextStyles.h5(context,
                                              fontSize: 22.sp),
                                        ),
                                      ),
                                  ],
                                ),
                              if (!_isLoggedIn)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 25.w),
                                  child: Text(
                                    getTranslated('guest', context),
                                    style: AppTextStyles.h5(context,
                                            fontSize: 22.sp)
                                        .copyWith(
                                      color:
                                          ColorResources.getPrimaryColor(
                                              context),
                                    ),
                                  ),
                                ),
                              SizedBox(height: 30.h),
                              SwitchListTile(
                                  value: themeProvider.darkTheme,
                                  onChanged: (_) =>
                                      themeProvider.toggleTheme(),
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.dark_mode,
                                        size: 20.sp,
                                        color:
                                            ColorResources.getTextColor(
                                                context),
                                      ),
                                      SizedBox(width: 30.w),
                                      Text(
                                        getTranslated(
                                            'dark_theme', context),
                                        style: AppTextStyles.h5(context),
                                      ),
                                    ],
                                  ),
                                  activeColor:
                                      ColorResources.getPrimaryColor(
                                          context)),
                              ListTile(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder:
                                              (BuildContext? context) =>
                                                  ProfileScreen())),
                                  leading: Icon(
                                      Icons.person_outline_rounded,
                                      color: ColorResources.getTextColor(
                                          context)),
                                  trailing: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 17.sp,
                                      color: ColorResources.getTextColor(
                                          context)),
                                  title: Text(
                                    getTranslated('profile', context),
                                    style: AppTextStyles.h4(context),
                                  )),
                              if (_isLoggedIn)
                                ListTile(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder:
                                              (BuildContext? context) =>
                                                  SubscriptionScreen())),
                                  leading: Icon(Icons.subscriptions,
                                      color: ColorResources.getTextColor(
                                          context)),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 17.sp,
                                    color: ColorResources.getTextColor(
                                        context),
                                  ),
                                  title: Text(
                                    getTranslated(
                                        'subscription', context),
                                    style: AppTextStyles.h4(context),
                                  ),
                                ),
                              if (_isLoggedIn)
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                PaymentDetailsScreen()));
                                    // if (paymentProvider
                                    //     .paymentCardList!.isEmpty) {
                                    //   paymentProvider
                                    //       .cardUpdateLink(context)
                                    //       .then((value) => Navigator.push(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //               builder: (_) =>
                                    //                   UpdateCardSreen())));
                                    // } else {
                                    //   paymentProvider
                                    //       .cardUpdateLink(context)
                                    //       .then((value) => Navigator.push(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //               builder: (_) =>
                                    //                   UpdateCardSreen(
                                    //                       fromUpdate:
                                    //                           true))));
                                    // }
                                  },
                                  leading: Icon(Icons.payment,
                                      color: ColorResources.getTextColor(
                                          context)),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 17.sp,
                                    color: ColorResources.getTextColor(
                                        context),
                                  ),
                                  title: Text(
                                    getTranslated(
                                        'payment_details', context),
                                    style: AppTextStyles.h4(context),
                                  ),
                                ),

                              if (_isLoggedIn)
                                ListTile(
                                  onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                ContractorRequestsScreen())),
                                  leading: Icon(  Icons.construction,
                                      color: ColorResources.getTextColor(
                                          context)),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 17.sp,
                                    color: ColorResources.getTextColor(
                                        context),
                                  ),
                                  title: Text(
                                    getTranslated(
                                        'contractor_zone_requests', context),
                                    style: AppTextStyles.h4(context),
                                  ),
                                ),

                              ListTile(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext?
                                                  context) =>
                                              ChangePasswordScreen())),
                                  leading: Icon(
                                    Icons.lock_outline_rounded,
                                    color: ColorResources.getTextColor(
                                        context),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 17.sp,
                                    color: ColorResources.getTextColor(
                                        context),
                                  ),
                                  title: Text(
                                    getTranslated('password', context),
                                    style: AppTextStyles.h4(context),
                                  )),
                              ListTile(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext?
                                                context) =>
                                            const ChooseLanguageScreen(
                                                fromHomeScreen: true))),
                                leading: Icon(
                                  Icons.language,
                                  color: ColorResources.getTextColor(
                                      context),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 17.sp,
                                  color: ColorResources.getTextColor(
                                      context),
                                ),
                                title: Text(
                                  getTranslated('language', context),
                                  style: AppTextStyles.h4(context),
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  if (_isLoggedIn) {
                                    Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .refresh(context, true);
                                  }
                                  _isLoggedIn
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext?
                                                      context) =>
                                                  ChatScreen()))
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext?
                                                      context) =>
                                                  NotLoggedInScreen()));
                                },
                                leading: Image.asset(Images.message,
                                    width: 20,
                                    height: 20,
                                    color: ColorResources.getTextColor(
                                        context)),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 17.sp,
                                  color: ColorResources.getTextColor(
                                      context),
                                ),
                                title: Text(
                                  getTranslated('message', context),
                                  style: AppTextStyles.h4(context),
                                ),
                              ),
                              ListTile(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder:
                                            (BuildContext? context) =>
                                                AddressScreen())),
                                leading: Icon(Icons.location_on_outlined,
                                    color: ColorResources.getTextColor(
                                        context)),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 17.sp,
                                  color: ColorResources.getTextColor(
                                      context),
                                ),
                                title: Text(
                                  getTranslated('address', context),
                                  style: AppTextStyles.h4(context),
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  Provider.of<NotificationProvider>(
                                          context,
                                          listen: false)
                                      .initNotificationList(context)
                                      .then((value) => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext?
                                                      context) =>
                                                  NotificationScreen())));
                                },
                                leading: Icon(
                                  Icons.notifications_none_rounded,
                                  color: ColorResources.getTextColor(
                                      context),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 17.sp,
                                  color: ColorResources.getTextColor(
                                      context),
                                ),
                                title: Text(
                                  getTranslated('notification', context),
                                  style: AppTextStyles.h4(context),
                                ),
                              ),
                              if (_isLoggedIn)  ListTile(
                                onTap: () {
                                  Provider.of<CouponProvider>(context,
                                          listen: false)
                                      .getCouponList(context)
                                      .then((value) => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  CouponScreen())));
                                },
                                leading: Image.asset(Images.coupon,
                                    width: 20,
                                    height: 20,
                                    color: ColorResources.getTextColor(
                                        context)),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 17.sp,
                                  color: ColorResources.getTextColor(
                                      context),
                                ),
                                title: Text(
                                  getTranslated('coupon', context),
                                  style: AppTextStyles.h4(context),
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Text(
                                getTranslated('more', context),
                                style: AppTextStyles.h4(context),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder:
                                              (BuildContext? context) =>
                                                  SupportScreen()));
                                },
                                leading: Icon(
                                  Icons.help_outline,
                                  color: ColorResources.getTextColor(
                                      context),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 17.sp,
                                  color: ColorResources.getTextColor(
                                      context),
                                ),
                                title: Text(
                                  getTranslated(
                                      'help_and_support', context),
                                  style: AppTextStyles.h4(context),
                                ),
                              ),
                              ListTile(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder:
                                            (BuildContext? context) =>
                                                TermsScreen())),
                                leading: Icon(
                                  Icons.rule,
                                  color: ColorResources.getTextColor(
                                      context),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 17.sp,
                                  color: ColorResources.getTextColor(
                                      context),
                                ),
                                title: Text(
                                  getTranslated(
                                      'terms_and_condition', context),
                                  style: AppTextStyles.h4(context),
                                ),
                              ),
                              _isLoggedIn
                                  ? ListTile(
                                      onTap: () => showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext
                                                  context) =>
                                              ConfirmDeleteAccountBottomSheet(
                                                  account: profileProvider
                                                      .userInfoModel!),
                                          backgroundColor:
                                              ColorResources.getCardColor(
                                                  context),
                                          isScrollControlled: true,
                                          barrierColor: Colors.black54,
                                          isDismissible: false,
                                          enableDrag: false),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 17.sp,
                                        color:
                                            ColorResources.getTextColor(
                                                context),
                                      ),
                                      leading: Icon(Icons.delete,
                                          size: 20.sp,
                                          color:
                                              ColorResources.getTextColor(
                                                  context)),
                                      title: Text(
                                        getTranslated(
                                            'delete_account', context),
                                        style: AppTextStyles.h4(context),
                                      ),
                                    )
                                  : ListTile(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext
                                                      context) =>
                                                  LoginScreen())),
                                      leading: Icon(Icons.login,
                                          size: 20.sp,
                                          color: ColorResources
                                              .getPrimaryColor(context)),
                                      title: Text(
                                          getTranslated('login', context),
                                          style: AppTextStyles.h4(context)
                                              .copyWith(
                                            color: ColorResources
                                                .getPrimaryColor(context),
                                          ))),
                              SizedBox(height: 15.h),
                              if (_isLoggedIn)
                                CustomButton(
                                  text: getTranslated('logout', context),
                                  onTap: () => showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) =>
                                          SignOutConfirmationDialog()),
                                )
                            ],
                          ),
                        ),
                      )),
          )),
        ]),
      ),
    );
  }
}
