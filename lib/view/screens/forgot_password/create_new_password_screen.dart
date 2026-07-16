import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

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
      body: Column(
        children: [
          CustomAppBar(title: 'create_new_password', showBackButton: true),
          Consumer<CustomAuthProvider>(
            builder: (context, auth, child) {
              return Scrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.r),

                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Center(
                        child: Text(
                          getTranslated(
                              'enter_password_to_create', context),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h2(
                            context,
                            fontSize: 22.sp,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              getTranslated('new_password', context),
                              style: AppTextStyles.h4(context).copyWith(
                                color: ColorResources.getTextColor(context),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            CustomTextField(
                              hintText: getTranslated(
                                'password_hint',
                                context,
                              ),
                              focusNode: _passwordFocus,
                              nextFocus: _confirmPasswordFocus,
                              isShowSuffixIcon: true,
                              isShowBorder: true,
                              inputAction: TextInputAction.next,
                              controller: _passwordController,
                              isPassword: true,
                            ),

                            SizedBox(height: 25.h),

                            Text(
                              getTranslated('confirm_password', context),
                              style: AppTextStyles.h4(context).copyWith(
                                color: ColorResources.getTextColor(context),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            CustomTextField(
                              hintText: getTranslated(
                                'password_hint',
                                context,
                              ),
                              isShowSuffixIcon: true,
                              focusNode: _confirmPasswordFocus,
                              isShowBorder: true,

                              controller: _confirmPasswordController,
                              inputAction: TextInputAction.done,
                              isPassword: true,
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
                                      bool isPasswordValid = passwordPattern
                                          .hasMatch(password);

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
                                      } else if (password !=
                                          confirmPassword) {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'password_did_not_match',
                                                context),
                                            context);
                                      } else {
                                        auth
                                            .resetPassword(resetToken,
                                                password, confirmPassword)
                                            .then((value) {
                                          if (value.isSuccess) {
                                            auth
                                                .login(context, email,
                                                    password)
                                                .then((value) async {
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
                                : CustomCircularIndicator(
                                    color: ColorResources.getPrimaryColor(
                                        context)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
