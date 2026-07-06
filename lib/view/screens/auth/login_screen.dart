import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wired_express/helper/email_checker.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/screens/auth/login_with_phone_screen.dart';
import 'package:wired_express/view/screens/auth/signup_screen.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:wired_express/view/screens/forgot_password/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController!.text =
        Provider.of<CustomAuthProvider>(context, listen: false)
                .getUserNumber() ??
            '';
    _passwordController!.text =
        Provider.of<CustomAuthProvider>(context, listen: false)
                .getUserPassword() ??
            '';
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      // key: _scaffoldKey,

      body: Consumer<CustomAuthProvider>(
        builder: (context, authProvider, child) {
          return Form(
              key: _formKeyLogin,
              child: Padding(
                padding:  EdgeInsets.all(30.r),
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${getTranslated('welcome_back', context)} \n${getTranslated('login', context)}",
                                    style: AppTextStyles.h2(context , fontSize: 22.sp),
                                  ),
                                  SizedBox(height: 25.h),
                                  CustomTextField(
                                    hintText: getTranslated(
                                        'enter_your_email', context),
                                    controller: _emailController,
                                    focusNode: _emailFocus,
                                    nextFocus: _passwordFocus,
                                    inputType: TextInputType.text,fill: true,
                                    fillColor:
                                        ColorResources.getTextFieldFillColor(
                                            context),
                                    // capitalization: TextCapitalizationtalization.words,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  CustomTextField(
                                    hintText:
                                        getTranslated('password', context),
                                    isPassword: true,
                                    controller: _passwordController,fill: true,
                                    fillColor:
                                        ColorResources.getTextFieldFillColor(
                                            context),
                                    focusNode: _passwordFocus,
                                    isShowSuffixIcon: true,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      ForgotPasswordScreen())),
                                          child:Text(
                                            getTranslated('forgot_password', context),
                                            style: AppTextStyles.h6(context).copyWith(
                                              color: Colors.red,
                                            ),
                                          ),)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  authProvider.isLoading == true
                                      ? const CustomCircularIndicator()
                                      : CustomButton(
                                          text: getTranslated('login', context),
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();
                                            String _email =
                                                _emailController!.text.trim();
                                            String _password =
                                                _passwordController!.text
                                                    .trim();

                                            if (_email.isEmpty) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'enter_email_address',
                                                      context),
                                                  context);
                                            } else if (EmailChecker.isNotValid(
                                                _email)) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'enter_valid_email',
                                                      context),
                                                  context);
                                            } else if (_password.isEmpty) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'enter_password',
                                                      context),
                                                  context);
                                            } else if (_password.length < 6) {
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'password_should_be',
                                                      context),
                                                  context);
                                            } else {
                                              authProvider
                                                  .login(context, _email,
                                                      _password)
                                                  .then((status) async {
                                                if (status.isSuccess) {
                                                  authProvider
                                                      .saveUserNumberAndPassword(
                                                          _email, _password);
                                                  await Provider.of<
                                                              CartProvider>(
                                                          context,
                                                          listen: false)
                                                      .initCartListProductIds(
                                                          context);

                                                  await Provider.of<
                                                              WishListProvider>(
                                                          context,
                                                          listen: false)
                                                      .initWishListProductIds(
                                                          context);

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext?
                                                                  context) =>
                                                              DashboardScreen(
                                                                  pageIndex:
                                                                      0)));
                                                }
                                              });
                                            }
                                          }),
                                  SizedBox(height: 35.h),
                                  Row(children: [
                                    Expanded(
                                        child: Divider(
                                            thickness: 1,
                                            color: ColorResources.getTextColor(
                                                    context)
                                                .withOpacity(0.4))),
                                    SizedBox(width: 15.w),
                                    Text(
                                      getTranslated('or', context),
                                      style: AppTextStyles.h7(context).copyWith(
                                        color: ColorResources.getTextColor(context).withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(width: 15.w),
                                    Expanded(
                                        child: Divider(
                                            thickness: 1,
                                            color: ColorResources.getTextColor(
                                                    context)
                                                .withOpacity(0.4))),
                                  ]),
                                  SizedBox(height: 5.h),
                                  TextButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    LoginWithPhoneScreen()));
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            getTranslated('login_with_phone', context),
                                            style: AppTextStyles.h4(context),
                                          ),
                                        ],
                                      )),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () async {
                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        await pref.clear();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => DashboardScreen(
                                                    pageIndex: 0)));
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(8.r),
                                        child: Text(
                                          getTranslated('login_as_guest', context),
                                          style: AppTextStyles.h6(context, fontSize: 15.sp,).copyWith(

                                            color: ColorResources.getTextColor(context).withOpacity(0.6),
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          getTranslated('dont_have_account', context),
                                          style: AppTextStyles.h7(
                                            context,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) => SignUpScreen(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            getTranslated('signup', context),
                                            style: AppTextStyles.h2(
                                              context,
                                              fontSize: 17.sp,
                                            ).copyWith(
                                              color: ColorResources.getPrimaryColor(context),
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              //   ),
              // ),
              );
        },
      ),
    );
  }
}
