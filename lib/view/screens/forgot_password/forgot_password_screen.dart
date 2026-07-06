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
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();

    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      body: Scrollbar(
        child: Consumer<CustomAuthProvider>(
          builder: (context, auth, child) {
            return Center(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Text(
                        getTranslated('forget_pass', context),
                        style: AppTextStyles.h3(
                          context,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Center(
                          child: Text(
                            getTranslated('please_enter_your_number_to', context),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.h5(context).copyWith(
                              color: ColorResources.getTextColor(context).withOpacity(0.5),
                            ),
                          ),),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.all(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 80),
                          Text(
                            getTranslated('email', context),
                            style: AppTextStyles.h3(
                              context,
                              fontSize: 19.sp,
                            ),
                          ),
                          SizedBox(
                              height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: 'your Email',fill: true,
                            fillColor:
                                ColorResources.getTextFieldFillColor(context),
                            isShowBorder: false,
                            controller: _emailController,
                            inputType: TextInputType.emailAddress,
                            inputAction: TextInputAction.done,
                          ),
                          SizedBox(height: 50),
                          !auth.isForgotPasswordLoading!
                              ? CustomButton(
                                  text: getTranslated('send', context),
                                  onTap: () {
                                    FocusScope.of(context).unfocus();

                                    if (_emailController.text.isEmpty) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_email_address', context),
                                          context);
                                    } else if (!_emailController.text
                                        .contains('@')) {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'enter_valid_email', context),
                                          context);
                                    } else {
                                      Provider.of<CustomAuthProvider>(context,
                                              listen: false)
                                          .forgetPassword(
                                              _emailController.text)
                                          .then((value) {
                                        if (value.isSuccess) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      VerificationScreen(
                                                        emailAddress:
                                                            _emailController
                                                                .text,
                                                      )));
                                        } else {
                                          showCustomSnackBar(
                                              value.message, context);
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
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getTranslated('remember_pass', context),
                            style: AppTextStyles.h7(
                              context,
                              fontSize: 15.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              getTranslated('login', context),
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
            );
          },
        ),
      ),
    );
  }
}
