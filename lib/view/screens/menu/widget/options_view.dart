import 'package:flutter/material.dart';
import 'package:wired_express/provider/chat_provider.dart';
import 'package:wired_express/provider/coupon_provider.dart';
import 'package:wired_express/provider/notification_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/not_logged_in_screen.dart';
import 'package:wired_express/view/screens/address/address_screen.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';
import 'package:wired_express/view/screens/chat/chat_screen.dart';
import 'package:wired_express/view/screens/coupon/coupon_screen.dart';
import 'package:wired_express/view/screens/language/choose_language_screen.dart';
import 'package:wired_express/view/screens/menu/widget/confirm_delete_account_bottom_sheet.dart';
import 'package:wired_express/view/screens/notification/notification_screen.dart';
import 'package:wired_express/view/screens/profile/change_pass_screen.dart';
import 'package:wired_express/view/screens/profile/profile_screen.dart';
import 'package:wired_express/view/screens/subscription/subscription_screen.dart';
import 'package:wired_express/view/screens/support/support_screen.dart';
import 'package:wired_express/view/screens/terms/terms_screen.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/main_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:provider/provider.dart';

class OptionsView extends StatelessWidget {
  final Function? onTap;
  OptionsView({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();
    bool _loading = false;
    String token =
        Provider.of<CustomAuthProvider>(context, listen: false).getUserToken()!;

    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }
    // final UserInfoModel _userInfo =
    //     Provider.of<ProfileProvider>(context, listen: false).userInfoModel!;

    return Scrollbar(
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        child: Consumer2<MainProvider, ProfileProvider>(
            builder: (context, mainProvider, profileProvider, child) {
          return mainProvider.loading
              ? CustomCircularIndicator()
              : Center(
                  child: SizedBox(
                    width: ResponsiveHelper.isTab(context) ? null : 1170,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: ResponsiveHelper.isTab(context) ? 50 : 0),
                          if (_isLoggedIn)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child:
                                      profileProvider!.userInfoModel!.image ==
                                              null
                                          ? SizedBox()
                                          : Container(
                                              height: 70,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  // color: Colors.black
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.customerImageUrl}/${profileProvider!.userInfoModel!.image}',
                                                      ),
                                                      fit: BoxFit.cover)),
                                            ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                profileProvider.userInfoModel!.fName != null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 25),
                                        child: Text(
                                          '${getTranslated('hello', context)}, ${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider!.userInfoModel!.lName ?? ''}',
                                          style: TextStyle(
                                              // color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          if (!_isLoggedIn)
                            Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Text(
                                '${getTranslated('guest', context)}',
                                style: TextStyle(
                                    color:
                                        ColorResources.getPrimaryColor(context),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            getTranslated('account', context),
                            style: TextStyle(
                                // color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext? context) =>
                                          ProfileScreen()));
                            },
                            leading: Icon(
                              Icons.person_outline_rounded,
                              color: Colors.black,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17,
                              color: Colors.black,
                            ),
                            title: Text(getTranslated('profile', context),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          if (_isLoggedIn)
                            ListTile(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext? context) =>
                                          SubscriptionScreen())),
                              leading: Icon(Icons.subscriptions,
                                  color: ColorResources.getTextColor(context)),
                              trailing: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 17,
                                color: Colors.black,
                              ),
                              title: Text(
                                  getTranslated('subscription', context),
                                  style: rubikMedium.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: ColorResources.getTextColor(
                                          context))),
                            ),
                          ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext? context) =>
                                            ChangePasswordScreen()));
                              },
                              leading: Icon(
                                Icons.lock_outline_rounded,
                                color: Colors.black,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 17,
                                color: Colors.black,
                              ),
                              title: Text(getTranslated('password', context),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500))),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext? context) =>
                                          ChooseLanguageScreen(
                                              fromHomeScreen: true)));
                            },
                            leading: Icon(
                              Icons.language,
                              color: Colors.black,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17,
                              color: Colors.black,
                            ),
                            title: Text(getTranslated('language', context)!,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
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
                                          builder: (BuildContext? context) =>
                                              ChatScreen()))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext? context) =>
                                              NotLoggedInScreen()));
                            },
                            leading: Image.asset(Images.message,
                                width: 20,
                                height: 20,
                                color: ColorResources.getTextColor(context)),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17,
                              color: Colors.black,
                            ),
                            title: Text(getTranslated('message', context),
                                style: rubikMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                    color:
                                        ColorResources.getTextColor(context))),
                          ),
                          ListTile(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext? context) =>
                                        AddressScreen())),
                            // Navigator.pushNamed(context, Routes.getAddressRoute()),
                            leading: Icon(Icons.location_on_outlined,
                                color: ColorResources.getTextColor(context)),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17,
                              color: Colors.black,
                            ),
                            title: Text(getTranslated('address', context),
                                style: rubikMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                    color:
                                        ColorResources.getTextColor(context))),
                          ),
                          ListTile(
                            onTap: () {
                              Provider.of<NotificationProvider>(context,
                                      listen: false)
                                  .initNotificationList(context)
                                  .then((value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext? context) =>
                                              NotificationScreen())));
                            },
                            leading: Icon(
                              Icons.notifications_none_rounded,
                              color: Colors.black,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17,
                              color: Colors.black,
                            ),
                            title: Text(getTranslated('notification', context),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          ListTile(
                            onTap: () {
                              Provider.of<CouponProvider>(context,
                                      listen: false)
                                  .getCouponList(context)
                                  .then((value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => CouponScreen())));
                            },
                            leading: Image.asset(Images.coupon,
                                width: 20,
                                height: 20,
                                color: ColorResources.getTextColor(context)),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17,
                              color: Colors.black,
                            ),
                            title: Text(getTranslated('coupon', context),
                                style: rubikMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                    color:
                                        ColorResources.getTextColor(context))),
                          ),

                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            getTranslated('more', context),
                            style: TextStyle(
                                // color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext? context) =>
                                          SupportScreen()));
                            },
                            leading: Icon(
                              Icons.help_outline,
                              color: Colors.black,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17,
                              color: Colors.black,
                            ),
                            title: Text(
                                getTranslated('help_and_support', context),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext? context) =>
                                          TermsScreen()));
                            },
                            leading: Icon(
                              Icons.rule,
                              color: Colors.black,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 17,
                              color: Colors.black,
                            ),
                            title: Text(
                                getTranslated('terms_and_condition', context),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                          ),

                          _isLoggedIn
                              ? ListTile(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ConfirmDeleteAccountBottomSheet(
                                          account:
                                              profileProvider.userInfoModel!,
                                        );
                                      },
                                      backgroundColor:
                                          ColorResources.getCardColor(context),
                                      isScrollControlled: true,
                                      barrierColor: Colors.black54,
                                      isDismissible: false,
                                      enableDrag: false,
                                    );
                                  },
                                  leading: Icon(Icons.delete,
                                      size: 20,
                                      color:
                                          ColorResources.getTextColor(context)),
                                  title: Text(
                                      getTranslated('delete_account', context),
                                      style: rubikMedium.copyWith(
                                          color: ColorResources.getTextColor(
                                              context),
                                          fontSize:
                                              Dimensions.FONT_SIZE_LARGE)),
                                )
                              : ListTile(
                                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                                  LoginScreen()));},
                                  leading: Icon(Icons.login,
                                      size: 20,
                                      color: ColorResources.getPrimaryColor(
                                          context)),
                                  title: Text(getTranslated('login', context),
                                      style: rubikMedium.copyWith(
                                          color: ColorResources.getPrimaryColor(
                                              context),
                                          fontSize:
                                              Dimensions.FONT_SIZE_LARGE)),
                                ),

                          SizedBox(
                            height: 50,
                          ),
                          if (_isLoggedIn)
                            CustomButton(
                              text: getTranslated('logout', context),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) =>
                                        SignOutConfirmationDialog());
                              },
                            )
                        ],
                      ),
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
