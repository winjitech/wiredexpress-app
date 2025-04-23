import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wired_express/helper/email_checker.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
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
                padding: const EdgeInsets.all(30),
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
                                    "${getTranslated('welcome_back', context)} \n ${getTranslated('login', context)}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 25),
                                  CustomTextField(
                                    hintText: getTranslated(
                                        'enter_your_email', context),
                                    controller: _emailController,
                                    focusNode: _emailFocus,
                                    nextFocus: _passwordFocus,
                                    inputType: TextInputType.text,
                                    // capitalization: TextCapitalizationtalization.words,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomTextField(
                                    hintText:
                                        getTranslated('password', context),
                                    isPassword: true,
                                    controller: _passwordController,
                                    focusNode: _passwordFocus,
                                    isShowSuffixIcon: true,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      ForgotPasswordScreen()));
                                        },
                                        child: Text(
                                          getTranslated(
                                              'forgot_password', context),
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 30,
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
                                  const SizedBox(height: 35),
                                  Row(children: [
                                    const Expanded(child: Divider(thickness: 1)),
                                    const SizedBox(width: 15),
                                    Text(getTranslated('or', context)),
                                    const SizedBox(width: 15),
                                    const Expanded(child: Divider(thickness: 1))
                                  ]),
                                  const SizedBox(height: 5),
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
                                            getTranslated(
                                                'login_with_phone', context),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ],
                                      )),
                                  const SizedBox(height: 15),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () async {
                                        final pref = await SharedPreferences
                                            .getInstance();
                                        await pref.clear();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => DashboardScreen(
                                                    pageIndex: 0)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          getTranslated(
                                              'login_as_guest', context),
                                          style: TextStyle(
                                              color:
                                                  ColorResources.getTextColor(
                                                          context)
                                                      .withOpacity(0.6),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          getTranslated(
                                              'dont_have_account', context),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          SignUpScreen()));
                                            },
                                            child: Text(
                                              getTranslated('signup', context),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 17),
                                            ))
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
