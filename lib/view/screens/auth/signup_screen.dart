import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wired_express/data/model/response/signup_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';
import 'package:wired_express/view/screens/auth/login_with_phone_screen.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:wired_express/view/screens/forgot_password/verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = ScrollController();

  GlobalKey<FormState>? _formKeyLogin;
  final FocusNode _firstNameFocus = FocusNode();

  final FocusNode _lastNameFocus = FocusNode();

  final FocusNode _passwordFocus = FocusNode();

  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  CountryCode? selectedCountryCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      // key: _scaffoldKey,

      body: Consumer<CustomAuthProvider>(
        builder: (context, authProvider, child) {
          return Form(
            key: _formKeyLogin,
            // child: Scrollbar(
            //   child:
            //   SingleChildScrollView(
            //     controller: scrollController,
            //     physics: const BouncingScrollPhysics(),
            //     //  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: ColorResources.getTextColor(context)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: ColorResources.getTextColor(context),
                                  size: 19,
                                ),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      child: Center(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated('signup', context),
                                  style: TextStyle(
                                      color:
                                          ColorResources.getTextColor(context),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 25),
                                CustomTextField(
                                  fillColor:
                                      ColorResources.getTextFieldFillColor(
                                          context),
                                  hintText:
                                      getTranslated('first_name', context),
                                  controller: _firstNameController,
                                  focusNode: _firstNameFocus,
                                  nextFocus: _lastNameFocus,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.words,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CustomTextField(
                                  fillColor:
                                      ColorResources.getTextFieldFillColor(
                                          context),
                                  hintText: getTranslated('last_name', context),
                                  controller: _lastNameController,
                                  focusNode: _lastNameFocus,
                                  nextFocus: _emailFocus,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.words,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CustomTextField(
                                  fillColor:
                                      ColorResources.getTextFieldFillColor(
                                          context),
                                  hintText: getTranslated('email', context),
                                  controller: _emailController,
                                  focusNode: _emailFocus,
                                  nextFocus: _passwordFocus,
                                  inputType: TextInputType.emailAddress,
                                  // capitalization: TextCapitalization.words,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CustomTextField(
                                  fillColor:
                                      ColorResources.getTextFieldFillColor(
                                          context),
                                  hintText: getTranslated('password', context),
                                  isPassword: true,
                                  controller: _passwordController,
                                  focusNode: _passwordFocus,
                                  nextFocus: _confirmPasswordFocus,
                                  isShowSuffixIcon: true,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CustomTextField(
                                  fillColor:
                                      ColorResources.getTextFieldFillColor(
                                          context),
                                  hintText: getTranslated(
                                      'confirm_password', context),
                                  isPassword: true,
                                  controller: _confirmPasswordController,
                                  focusNode: _confirmPasswordFocus,
                                  isShowSuffixIcon: true,
                                  inputAction: TextInputAction.done,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                authProvider.checkEmailLoading!
                                    ? CustomCircularIndicator()
                                    : CustomButton(
                                        text: getTranslated('signup', context),
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          String email =
                                              _emailController.text.trim();
                                          String firstName =
                                              _firstNameController.text.trim();
                                          String lastName =
                                              _lastNameController.text.trim();

                                          String password =
                                              _passwordController.text.trim();
                                          String confirmPassword =
                                              _confirmPasswordController.text
                                                  .trim();
                                          RegExp passwordPattern = RegExp(
                                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$');
                                          bool isPasswordValid = passwordPattern
                                              .hasMatch(password);
                                          if (firstName.isEmpty) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'enter_first_name',
                                                    context),
                                                context);
                                          } else if (lastName.isEmpty) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'enter_last_name', context),
                                                context);
                                          } /*else if (_number.isEmpty) {
                                                showCustomSnackBar(
                                                    getTranslated(
                                                        'enter_phone_number', context),
                                                    context);
                                              }*/
                                          else if (!isPasswordValid) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'password_should_contain',
                                                    context),
                                                context);
                                          } else if (password.isEmpty) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'enter_password', context),
                                                context);
                                          } else if (password.length < 6) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'password_should_be',
                                                    context),
                                                context);
                                          } else if (confirmPassword.isEmpty) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'enter_confirm_password',
                                                    context),
                                                context);
                                          } else if (password !=
                                              confirmPassword) {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'password_did_not_match',
                                                    context),
                                                context);
                                          } else {
                                            SignUpModel signUpModel =
                                                SignUpModel(
                                                    fName: firstName,
                                                    lName: lastName,
                                                    email: email,
                                                    password: password);
                                            authProvider
                                                .checkEmail(context, email)
                                                .then((value) {
                                              if (value.isSuccess) {
                                                authProvider.updateEmail(email);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        VerificationScreen(
                                                            fromSignUp: true,
                                                            emailAddress: email,
                                                            signUpModel:
                                                                signUpModel),
                                                  ),
                                                );
                                              }
                                            });
                                          }
                                        }),
                                const SizedBox(height: 35),
                                Row(children: [
                                  Expanded(
                                      child: Divider(
                                          thickness: 1,
                                          color: ColorResources.getTextColor(
                                                  context)
                                              .withOpacity(0.4))),
                                  const SizedBox(width: 15),
                                  Text(
                                    getTranslated('or', context),
                                    style: TextStyle(
                                        color:
                                            ColorResources.getTextColor(context)
                                                .withOpacity(0.7)),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                      child: Divider(
                                          thickness: 1,
                                          color: ColorResources.getTextColor(
                                                  context)
                                              .withOpacity(0.4))),
                                ]),
                                TextButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
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
                                Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final pref = await SharedPreferences.getInstance();
                                      await pref.clear();
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => DashboardScreen(pageIndex: 0)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        getTranslated(
                                            'login_as_guest', context),
                                        style: TextStyle(
                                            color: ColorResources.getTextColor(
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
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        getTranslated(
                                            'aleady_have_acc', context),
                                        style: TextStyle(
                                            color: ColorResources.getTextColor(
                                                context),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        LoginScreen()));
                                          },
                                          child: Text(
                                            getTranslated('login', context),
                                            style: TextStyle(
                                                color: ColorResources
                                                    .getPrimaryColor(context),
                                                fontWeight: FontWeight.w700,
                                                decoration:
                                                    TextDecoration.underline,
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
            ),
            //   ),
            // ),
          );
        },
      ),
    );
  }
}
