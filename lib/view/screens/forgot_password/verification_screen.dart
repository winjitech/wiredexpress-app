import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/data/model/response/signup_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/screens/address/add_new_address_screen.dart';
import 'package:wired_express/view/screens/forgot_password/create_new_password_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatelessWidget {
  final SignUpModel? signUpModel;
  final String? emailAddress;
  final bool? fromSignUp;
  VerificationScreen(
      {@required this.emailAddress, this.fromSignUp = false, this.signUpModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Consumer2<CustomAuthProvider, ProfileProvider>(
                  builder: (context, authProvider, profileProvider, child) =>
                      Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 70),
                      Center(
                        child: Text(
                          getTranslated('enter_auth_code', context),
                          style: AppTextStyles.h2(
                            context,
                            fontSize: 23.sp,
                          ),
                        ),
                      ),
                     SizedBox(height: 30.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Center(
                          child: Text(
                            '${getTranslated('please_enter_4_digit_code', context)}',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.h2(context, fontSize: 21.sp).copyWith(
                              color: ColorResources.getTextColor(context).withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24, vertical: 55),
                        child:PinCodeTextField(
                          length: 4,
                          appContext: context,
                          textStyle: AppTextStyles.h3(
                            context,
                          ).copyWith(
                            fontWeight: FontWeight.w600,
                          ),

                          obscureText: false,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          cursorColor: ColorResources.getPrimaryColor(context),
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            fieldHeight:
                                MediaQuery.of(context).size.width * 0.14,
                            fieldWidth:
                                MediaQuery.of(context).size.width * 0.12,
                            borderWidth: 1.5,
                            borderRadius: BorderRadius.circular(15.r),
                            selectedColor:
                                ColorResources.getPrimaryColor(context),
                            selectedFillColor:
                                ColorResources.getScaffoldBackgroundColor(
                                    context),
                            inactiveFillColor:
                                ColorResources.getScaffoldBackgroundColor(
                                    context),
                            inactiveColor: Colors.grey[300],
                            activeColor:
                                ColorResources.getPrimaryColor(context),
                            activeFillColor:
                                ColorResources.getScaffoldBackgroundColor(
                                    context),
                          ),
                          animationDuration: const Duration(milliseconds: 200),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          onChanged: authProvider.updateVerificationCode,
                          beforeTextPaste: (text) => true,
                        ),
                      ),
                      SizedBox(height: 150),
                      authProvider.verifyEmailLoading == true ||
                              authProvider.registerIsLoading == true ||
                              authProvider.verifyTokenLoading == true ||
                              profileProvider.isLoading == true
                          ? CustomCircularIndicator()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: CustomButton(
                                text: getTranslated('continue', context),
                                onTap: () {
                                  FocusScope.of(context).unfocus();

                                  if (fromSignUp!) {
                                    authProvider
                                        .verifyEmail(emailAddress)
                                        .then((value) {
                                      if (value.isSuccess) {
                                        authProvider
                                            .registration(signUpModel!)
                                            .then((status) async {
                                          if (status.isSuccess) {
                                            profileProvider
                                                .getUserInfo(context)
                                                .then((value) async =>
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                AddNewAddressScreen(
                                                                    fromSplash:
                                                                        true))));
                                          } else {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'something_went_wrong',
                                                    context),
                                                context);
                                          }
                                        });
                                      } else {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'something_went_wrong',
                                                context),
                                            context);
                                      }
                                    });
                                  } else {
                                    authProvider
                                        .verifyToken(emailAddress)
                                        .then((value) {
                                      if (value.isSuccess) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext?
                                                        context) =>
                                                    CreateNewPasswordScreen(
                                                        email: emailAddress!,
                                                        resetToken: authProvider
                                                            .verificationCode!)));
                                      } else {
                                        showCustomSnackBar(
                                            value.message, context);
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            if (fromSignUp!) {
                              authProvider
                                  .checkEmail(context, emailAddress)
                                  .then((value) {
                                if (value.isSuccess) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'resent_code_success', context),
                                      context,
                                      isError: false);
                                } else {}
                              });
                            } else {
                              authProvider
                                  .forgetPassword(emailAddress)
                                  .then((value) {
                                if (value.isSuccess) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'resent_code_success', context),
                                      context,
                                      isError: false);
                                } else {
                                  showCustomSnackBar(value.message, context);
                                }
                              });
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(
                                Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child:Text(
                              getTranslated('resend_code', context),
                              style: AppTextStyles.h6(context).copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: ColorResources.getPrimaryColor(context),
                                color: ColorResources.getPrimaryColor(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
