import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/signup_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
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
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 23),
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Center(
                            child: Text(
                          '${getTranslated('please_enter_4_digit_code', context)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorResources.COLOR_GREY_CHATEAU,
                              fontSize: 21),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 39, vertical: 35),
                        child: PinCodeTextField(
                          length: 4,
                          appContext: context,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.circle,
                            fieldHeight: 63,
                            fieldWidth: 55,
                            borderWidth: 1,
                            borderRadius: BorderRadius.circular(50),
                            selectedColor:
                                ColorResources.getScaffoldColor(context),
                            selectedFillColor: Colors.white,
                            inactiveFillColor: Colors.white,
                            inactiveColor: Colors.grey[300],
                            activeColor:
                                ColorResources.getScaffoldColor(context),
                            activeFillColor: ColorResources.COLOR_WHITE,
                          ),
                          animationDuration: Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          onChanged: authProvider.updateVerificationCode,
                          beforeTextPaste: (text) {
                            return true;
                          },
                        ),
                      ),
                      SizedBox(height: 150),
                      authProvider.verifyEmailLoading == true ||
                              authProvider.registerIsLoading == true ||
                              authProvider.verifyTokenLoading == true ||
                              profileProvider.isLoading == true
                          ? CustomCircularIndicator()
                          : Padding(
                              padding: const EdgeInsets.symmetric(
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
                                    Provider.of<CustomAuthProvider>(context,
                                            listen: false)
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
                        height: 30,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            if (fromSignUp!) {
                              Provider.of<CustomAuthProvider>(context,
                                      listen: false)
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
                              Provider.of<CustomAuthProvider>(context,
                                      listen: false)
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
                            child: Text(
                              getTranslated('resend_code', context),
                              style: TextStyle(
                                fontSize: 15,
                                color: ColorResources.getGreyColor(context),
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
