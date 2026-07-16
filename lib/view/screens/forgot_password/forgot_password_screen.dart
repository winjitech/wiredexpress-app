import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
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
import 'package:wired_express/view/screens/forgot_password/verification_screen.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildContent(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: ColorResources.getScaffoldBackgroundColor(context),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 18.sp,
                  color: ColorResources.getTextColor(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child: Consumer<CustomAuthProvider>(
                builder: (context, auth, child) {
                  return SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 25),
                        Center(
                          child: Text(
                            getTranslated('forget_password', context),
                            style: AppTextStyles.h2(context).copyWith(
                              color: ColorResources.getTextColor(context),
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w) ,
                            child: Text(
                              getTranslated('please_enter_your_number_to', context),
                              textAlign: TextAlign.center,
                              style: AppTextStyles.h6(context).copyWith(
                                color: ColorResources.getTextColor(context).withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.all(25.r,),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 40),
                              Text(
                                getTranslated('email', context),
                                style: AppTextStyles.h4(context).copyWith(
                                  color: ColorResources.getTextColor(context).withOpacity(0.8),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              CustomTextField(
                                hintText: getTranslated('email', context),
                                isShowBorder: true,
                                controller: _emailController,
                                inputType: TextInputType.emailAddress,
                                inputAction: TextInputAction.done,
                              ),
                              SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(35.r),
      child: Consumer<CustomAuthProvider>(
        builder: (context, auth, child) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                auth.isForgotPasswordLoading!
                    ? CustomCircularIndicator()
                    : Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        backgroundColor:
                        ColorResources.getScaffoldBackgroundColor(
                            context),
                        radius: 15,
                        text: getTranslated('cancel', context),
                        textSize: 17,
                        textColor:
                        ColorResources.getPrimaryColor(context),
                        borderColor:
                        ColorResources.getPrimaryColor(context),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(width: 15.w,),
                    Expanded(
                      child: CustomButton(
                        backgroundColor:
                        ColorResources.getPrimaryColor(context),
                        radius: 15,
                        text: getTranslated('send', context),
                        textSize: 17,
                        onTap: () {
                          FocusScope.of(context).unfocus();

                          if (_emailController.text.isEmpty) {
                            showCustomSnackBar(
                              getTranslated('enter_email_address', context),
                              context,
                            );
                          } else if (!_emailController.text.contains('@')) {
                            showCustomSnackBar(
                              getTranslated('enter_valid_email', context),
                              context,
                            );
                          } else {
                            auth
                                .forgetPassword(_emailController.text)
                                .then((value) {
                              if (value.isSuccess) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VerificationScreen(
                                      emailAddress: _emailController.text,
                                    ),
                                  ),
                                );
                              } else {
                                showCustomSnackBar(getTranslated('something_went_wrong',  context), context);
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
