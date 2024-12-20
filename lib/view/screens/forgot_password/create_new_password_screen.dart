import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

// class CreateNewPasswordScreen extends StatelessWidget {
//   final String? resetToken;
//   final String? email;
//   CreateNewPasswordScreen({@required this.resetToken, @required this.email});
//
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final FocusNode _passwordFocus = FocusNode();
//   final FocusNode _confirmPasswordFocus = FocusNode();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: getTranslated('create_new_password', context)),
//       body: Consumer<AuthProvider>(
//         builder: (context, auth, child) {
//           return Scrollbar(
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               child: Center(
//                 child: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 55),
//                       Center(
//                         child: Image.asset(
//                           Images.open_lock,
//                           width: 142,
//                           height: 142,
//                         ),
//                       ),
//                       SizedBox(height: 40),
//                       Center(
//                           child: Text(
//                             getTranslated('enter_password_to_create', context),
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: ColorResources.getHintColor(context)),
//                           )),
//                       Padding(
//                         padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // for password section
//
//                             SizedBox(height: 60),
//                             Text(
//                               getTranslated('new_password', context),
//                               style: TextStyle(color: ColorResources.getHintColor(context)),
//                             ),
//                             SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
//                             CustomTextField(
//                               hintText: getTranslated('password_hint', context),
//                               isShowBorder: true,
//                               isPassword: true,
//                               focusNode: _passwordFocus,
//                               nextFocus: _confirmPasswordFocus,
//                               isShowSuffixIcon: true,
//                               inputAction: TextInputAction.next,
//                               controller: _passwordController,
//                             ),
//                             SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
//                             // for confirm password section
//                             Text(
//                               getTranslated('confirm_password', context),
//                               style: TextStyle(color: ColorResources.getHintColor(context)),
//                             ),
//                             SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
//                             CustomTextField(
//                               hintText: getTranslated('password_hint', context),
//                               isShowBorder: true,
//                               isPassword: true,
//                               isShowSuffixIcon: true,
//                               focusNode: _confirmPasswordFocus,
//                               controller: _confirmPasswordController,
//                               inputAction: TextInputAction.done,
//                             ),
//
//                             SizedBox(height: 24),
//                             !auth.isForgotPasswordLoading! ? CustomButton(
//                               text: getTranslated('save', context),
//                               onTap: () {
//                                 if (_passwordController.text.isEmpty) {
//                                   showCustomSnackBar(getTranslated('enter_password', context), context);
//                                 }else if (_passwordController.text.length < 6) {
//                                   showCustomSnackBar(getTranslated('password_should_be', context), context);
//                                 }else if (_confirmPasswordController.text.isEmpty) {
//                                   showCustomSnackBar(getTranslated('enter_confirm_password', context), context);
//                                 }else if(_passwordController.text != _confirmPasswordController.text) {
//                                   showCustomSnackBar(getTranslated('password_did_not_match', context), context);
//                                 }else {
//                                   auth.resetPassword(resetToken, _passwordController.text, _confirmPasswordController.text).then((value) {
//                                     if(value.isSuccess) {
//                                       auth.login(email, _passwordController.text).then((value) async {
//                                         await Provider.of<CartProvider>(context, listen: false).initCartListProductIds(context);
//
//                                         await Provider.of<WishListProvider>(context, listen: false).initWishListProductIds(context);
//                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()));
//                                         showCustomSnackBar(getTranslated('password_changed', context), context , isError:false);
//
//                                         // Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
//
//                                       });
//                                     }else {
//                                       showCustomSnackBar('Failed to reset password', context);
//                                     }
//                                   });
//                                 }
//                               },
//                             ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
class CreateNewPasswordScreen extends StatelessWidget {
  final String? resetToken;
  final String? email;
  CreateNewPasswordScreen({@required this.resetToken, @required this.email});

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      appBar:
          CustomAppBar(title: getTranslated('create_new_password', context)),
      body: Consumer<CustomAuthProvider>(
        builder: (context, auth, child) {
          return Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 55),
                      SizedBox(height: 40),
                      Center(
                        child: Text(
                          getTranslated('enter_password_to_create', context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 23),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // for password section
                            SizedBox(height: 60),
                            Text(
                              getTranslated('new_password', context),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 19),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: getTranslated('password_hint', context),
                              isPassword: true,
                              focusNode: _passwordFocus,
                              nextFocus: _confirmPasswordFocus,
                              isShowSuffixIcon: true,
                              inputAction: TextInputAction.next,
                              controller: _passwordController,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            // for confirm password section
                            Text(
                              getTranslated('confirm_password', context),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 19),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: getTranslated('password_hint', context),
                              isPassword: true,
                              isShowSuffixIcon: true,
                              focusNode: _confirmPasswordFocus,
                              controller: _confirmPasswordController,
                              inputAction: TextInputAction.done,
                            ),

                            SizedBox(height: 24),
                            !auth.isForgotPasswordLoading!
                                ? CustomButton(
                                    text: getTranslated('save', context),
                                    onTap: () {
                                      String password =
                                          _passwordController.text;
                                      String confirmPassword =
                                          _confirmPasswordController.text;

                                      RegExp passwordPattern = RegExp(
                                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$');
                                      bool isPasswordValid =
                                          passwordPattern.hasMatch(password);

                                      if (password.isEmpty) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'enter_password', context),
                                            context);
                                      } else if (!isPasswordValid) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'password_should_contain',
                                                context),
                                            context);
                                      } else if (confirmPassword.isEmpty) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'enter_confirm_password',
                                                context),
                                            context);
                                      } else if (password != confirmPassword) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'password_did_not_match',
                                                context),
                                            context);
                                      } else {
                                        auth
                                            .resetPassword(resetToken, password,
                                                confirmPassword)
                                            .then((value) {
                                          if (value.isSuccess) {
                                            auth
                                                .login(context, email, password)
                                                .then((value) async {
                                              await Provider.of<CartProvider>(
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
                                                      builder: (BuildContext
                                                              context) =>
                                                          LoginScreen()));
                                              showCustomSnackBar(
                                                  getTranslated(
                                                      'password_changed',
                                                      context),
                                                  context,
                                                  isError: false);

                                              // Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                            });
                                          } else {
                                            showCustomSnackBar(
                                                'Failed to reset password',
                                                context);
                                          }
                                        });
                                      }
                                    },
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            ColorResources.SCAFFOLD_COLOR))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
