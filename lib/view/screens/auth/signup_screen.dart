// import 'dart:async';
//
// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:wired_express/data/model/response/signup_model.dart';
// import 'package:wired_express/localization/language_constrants.dart';
// import 'package:wired_express/provider/auth_provider.dart';
// import 'package:wired_express/provider/cart_provider.dart';
// import 'package:wired_express/provider/notification_provider.dart';
// import 'package:wired_express/provider/wishlist_provider.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:wired_express/view/base/custom_app_bar.dart';
// import 'package:wired_express/view/base/custom_button.dart';
// import 'package:wired_express/view/base/custom_snackbar.dart';
// import 'package:wired_express/view/base/custom_text_field.dart';
// import 'package:wired_express/view/screens/address/add_new_address_screen.dart';
// import 'package:wired_express/view/screens/auth/login_screen.dart';
// import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
//
// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
//       GlobalKey<ScaffoldMessengerState>();
//
//   ScrollController scrollController = ScrollController();
//
//   GlobalKey<FormState>? _formKeyLogin;
//   final FocusNode _firstNameFocus = FocusNode();
//
//   final FocusNode _lastNameFocus = FocusNode();
//
//   final FocusNode _numberFocus = FocusNode();
//
//   final FocusNode _passwordFocus = FocusNode();
//
//   final FocusNode _confirmPasswordFocus = FocusNode();
//   final FocusNode _emailFocus = FocusNode();
//
//   final TextEditingController _firstNameController = TextEditingController();
//
//   final TextEditingController _lastNameController = TextEditingController();
//
//   final TextEditingController _numberController = TextEditingController();
//
//   final TextEditingController _passwordController = TextEditingController();
//
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//
//   final TextEditingController _phoneTEC = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//
//   CountryCode? selectedCountryCode;
//
//   // String countryCode = "";
//
//   countryCodeSelected(CountryCode countryCode) {
//     selectedCountryCode = countryCode;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorResources.SCAFFOLD_COLOR,
//       // backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
//       // key: _scaffoldKey,
//
//       body: Consumer<CustomAuthProvider>(
//         builder: (context, authProvider, child) {
//           return Form(
//             key: _formKeyLogin,
//             // child: Scrollbar(
//             //   child:
//             //   SingleChildScrollView(
//             //     controller: scrollController,
//             //     physics: const BouncingScrollPhysics(),
//             //     //  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//             child: Stack(
//               children: [
//                 Positioned(
//                   top: 0,
//                   left: 0,
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey[700],
//                         borderRadius: BorderRadius.only(
//                             bottomRight: Radius.circular(300),
//                             bottomLeft: Radius.circular(40),
//                             topRight: Radius.circular(40))),
//                     height: 170,
//                     width: 160,
//                     child: SafeArea(
//                       child: Align(
//                         alignment: Alignment.topLeft,
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 10, left: 15),
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: Container(
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(50)),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(14),
//                                   child: Icon(
//                                     Icons.arrow_back_ios_new_outlined,
//                                     color: ColorResources.SCAFFOLD_COLOR,
//                                     size: 19,
//                                   ),
//                                 )),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 190,
//                   left: MediaQuery.of(context).size.width / 2 - 40,
//                   child: Text(
//                     getTranslated('signup', context),
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.w700),
//                   ),
//                 ),
//                 Positioned(
//                     bottom: 0,
//                     right: 0,
//                     left: 0,
//                     child: Container(
//                         height: 600,
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.only(
//                                 topRight: Radius.circular(30),
//                                 topLeft: Radius.circular(30))),
//                         child: Padding(
//                           padding: const EdgeInsets.all(30),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               SizedBox(height: 80),
//                               CustomTextField(
//                                 hintText: getTranslated('first_name', context),
//                                 controller: _firstNameController,
//                                 focusNode: _firstNameFocus,
//                                 nextFocus: _lastNameFocus,
//                                 inputType: TextInputType.name,
//                                 capitalization: TextCapitalization.words,
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               CustomTextField(
//                                 hintText: getTranslated('last_name', context),
//                                 controller: _lastNameController,
//                                 focusNode: _lastNameFocus,
//                                 nextFocus: _emailFocus,
//                                 inputType: TextInputType.name,
//                                 capitalization: TextCapitalization.words,
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               CustomTextField(
//                                 hintText: getTranslated('email', context),
//                                 controller: _emailController,
//                                 focusNode: _emailFocus,
//                                 nextFocus: _passwordFocus,
//                                 inputType: TextInputType.emailAddress,
//                                 // capitalization: TextCapitalization.words,
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               CustomTextField(
//                                 hintText: getTranslated('password', context),
//                                 isPassword: true,
//                                 controller: _passwordController,
//                                 focusNode: _passwordFocus,
//                                 nextFocus: _confirmPasswordFocus,
//                                 isShowSuffixIcon: true,
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               CustomTextField(
//                                 hintText:
//                                     getTranslated('confirm_password', context),
//                                 isPassword: true,
//                                 controller: _confirmPasswordController,
//                                 focusNode: _confirmPasswordFocus,
//                                 isShowSuffixIcon: true,
//                                 inputAction: TextInputAction.done,
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               authProvider.isLoading == true
//                                   ? Center(
//                                       child: CircularProgressIndicator(
//                                           valueColor: AlwaysStoppedAnimation<
//                                                   Color>(
//                                               ColorResources.SCAFFOLD_COLOR)))
//                                   : CustomButton(
//                                       text: getTranslated('signup', context),
//                                       onTap: () {
//                                         FocusScope.of(context).unfocus();
//                                         String _email =
//                                             _emailController.text.trim();
//                                         String _firstName =
//                                             _firstNameController.text.trim();
//                                         String _lastName =
//                                             _lastNameController.text.trim();
//                                         /* String _number =
//                                     "${selectedCountryCode.dialCode}${_phoneTEC.text.trim()}";*/
//                                         //_numberController.text.trim();
//
//                                         String _password =
//                                             _passwordController.text.trim();
//                                         String _confirmPassword =
//                                             _confirmPasswordController.text
//                                                 .trim();
//                                         RegExp passwordPattern = RegExp(
//                                             r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$');
//                                         bool isPasswordValid =
//                                             passwordPattern.hasMatch(_password);
//                                         if (_firstName.isEmpty) {
//                                           showCustomSnackBar(
//                                               getTranslated(
//                                                   'enter_first_name', context),
//                                               context);
//                                         } else if (_lastName.isEmpty) {
//                                           showCustomSnackBar(
//                                               getTranslated(
//                                                   'enter_last_name', context),
//                                               context);
//                                         } /*else if (_number.isEmpty) {
//                                   showCustomSnackBar(
//                                       getTranslated(
//                                           'enter_phone_number', context),
//                                       context);
//                                 }*/
//                                         else if (!isPasswordValid) {
//                                           showCustomSnackBar(
//                                               getTranslated(
//                                                   'password_should_contain',
//                                                   context),
//                                               context);
//                                         } else if (_password.isEmpty) {
//                                           showCustomSnackBar(
//                                               getTranslated(
//                                                   'enter_password', context),
//                                               context);
//                                         } else if (_password.length < 6) {
//                                           showCustomSnackBar(
//                                               getTranslated(
//                                                   'password_should_be',
//                                                   context),
//                                               context);
//                                         } else if (_confirmPassword.isEmpty) {
//                                           showCustomSnackBar(
//                                               getTranslated(
//                                                   'enter_confirm_password',
//                                                   context),
//                                               context);
//                                         } else if (_password !=
//                                             _confirmPassword) {
//                                           showCustomSnackBar(
//                                               getTranslated(
//                                                   'password_did_not_match',
//                                                   context),
//                                               context);
//                                         } else {
//                                           SignUpModel signUpModel = SignUpModel(
//                                             fName: _firstName,
//                                             lName: _lastName,
//                                             email: _email,
//                                             password: _password,
//                                             // phone: _number,
//                                           );
//
//                                           authProvider
//                                               .registration(signUpModel)
//                                               .then((status) async {
//                                             if (status.isSuccess) {
//                                               DateTime _date = DateTime.now()
//                                                   .add(const Duration(days: 7));
//                                               var box = Hive.box('myBox');
//                                               box.put(
//                                                   'rate_last_datetime', _date);
//                                               await Provider.of<
//                                                           WishListProvider>(
//                                                       context,
//                                                       listen: false)
//                                                   .initWishListProductIds(
//                                                       context);
//                                               await Provider.of<CartProvider>(
//                                                       context,
//                                                       listen: false)
//                                                   .initCartListProductIds(
//                                                       context);
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (_) =>
//                                                           AddNewAddressScreen(
//                                                             fromSplash: true,
//                                                           )));
//                                             }
//                                           });
//                                         }
//                                       }),
//                               SizedBox(
//                                 height: 35,
//                               ),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     getTranslated('aleady_have_acc', context),
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w400,
//                                         fontSize: 15),
//                                   ),
//                                   TextButton(
//                                       onPressed: () {
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder:
//                                                     (BuildContext context) =>
//                                                         LoginScreen()));
//                                       },
//                                       child: Text(
//                                         getTranslated('login', context),
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w700,
//                                             fontSize: 17),
//                                       ))
//                                 ],
//                               )
//                             ],
//                           ),
//                         ))),
//               ],
//             ),
//             //   ),
//             // ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wired_express/data/model/response/signup_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/notification_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/screens/address/add_new_address_screen.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';

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

  final FocusNode _numberFocus = FocusNode();

  final FocusNode _passwordFocus = FocusNode();

  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _numberController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _phoneTEC = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  CountryCode? selectedCountryCode;

  // String countryCode = "";

  countryCodeSelected(CountryCode countryCode) {
    selectedCountryCode = countryCode;
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
            // child: Scrollbar(
            //   child:
            //   SingleChildScrollView(
            //     controller: scrollController,
            //     physics: const BouncingScrollPhysics(),
            //     //  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child:  Padding(
              padding: const EdgeInsets.all(30),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: ColorResources.SCAFFOLD_COLOR,
                                  size: 19,
                                ),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(height: 25,),
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
                                  "${getTranslated('signup', context)}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 25),
                                CustomTextField(
                                  hintText: getTranslated('first_name', context),
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
                                  hintText:
                                  getTranslated('confirm_password', context),
                                  isPassword: true,
                                  controller: _confirmPasswordController,
                                  focusNode: _confirmPasswordFocus,
                                  isShowSuffixIcon: true,
                                  inputAction: TextInputAction.done,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                authProvider.isLoading == true
                                    ? Center(
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                            Color>(
                                            ColorResources.SCAFFOLD_COLOR)))
                                    : CustomButton(
                                    text: getTranslated('signup', context),
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      String _email =
                                      _emailController.text.trim();
                                      String _firstName =
                                      _firstNameController.text.trim();
                                      String _lastName =
                                      _lastNameController.text.trim();
                                      /* String _number =
                                                  "${selectedCountryCode.dialCode}${_phoneTEC.text.trim()}";*/
                                      //_numberController.text.trim();

                                      String _password =
                                      _passwordController.text.trim();
                                      String _confirmPassword =
                                      _confirmPasswordController.text
                                          .trim();
                                      RegExp passwordPattern = RegExp(
                                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$');
                                      bool isPasswordValid =
                                      passwordPattern.hasMatch(_password);
                                      if (_firstName.isEmpty) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'enter_first_name', context),
                                            context);
                                      } else if (_lastName.isEmpty) {
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
                                      } else if (_password.isEmpty) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'enter_password', context),
                                            context);
                                      } else if (_password.length < 6) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'password_should_be',
                                                context),
                                            context);
                                      } else if (_confirmPassword.isEmpty) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'enter_confirm_password',
                                                context),
                                            context);
                                      } else if (_password !=
                                          _confirmPassword) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'password_did_not_match',
                                                context),
                                            context);
                                      } else {
                                        SignUpModel signUpModel = SignUpModel(
                                          fName: _firstName,
                                          lName: _lastName,
                                          email: _email,
                                          password: _password,
                                          // phone: _number,
                                        );


                                        authProvider
                                            .registration(signUpModel)
                                            .then((status) async {
                                          if (status.isSuccess) {
                                            DateTime _date = DateTime.now()
                                                .add(const Duration(days: 7));
                                            var box = Hive.box('myBox');
                                            box.put(
                                                'rate_last_datetime', _date);
                                            await Provider.of<
                                                WishListProvider>(
                                                context,
                                                listen: false)
                                                .initWishListProductIds(
                                                context);
                                            await Provider.of<CartProvider>(
                                                context,
                                                listen: false)
                                                .initCartListProductIds(
                                                context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        AddNewAddressScreen(
                                                          fromSplash: true,
                                                        )));
                                          }
                                        });
                                      }
                                    }),
                                SizedBox(height: 15),
                                Center(
                                  child: InkWell(
                                    onTap: () async {
                                      final pref =
                                      await SharedPreferences.getInstance();
                                      await pref.clear();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  DashboardScreen(pageIndex: 0)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        getTranslated('login_as_guest', context),
                                        style: TextStyle(
                                            color:
                                            ColorResources.getTextColor(context)
                                                .withOpacity(0.6),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15  , decoration: TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 15),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTranslated('aleady_have_acc', context),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                      LoginScreen()));
                                        },
                                        child: Text(
                                          getTranslated('login', context),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 17),
                                        ))
                                  ],
                                )
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
