import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/routes.dart';
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
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Text(
                        getTranslated('forget_pass', context),
                        style: TextStyle(
                            color: ColorResources.getTextColor(context),
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Center(
                          child: Text(
                        getTranslated('please_enter_your_number_to', context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorResources.getTextColor(context)
                                .withOpacity(0.5),
                            fontSize: 18),
                      )),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 80),
                          Text(
                            getTranslated('email', context),
                            style: TextStyle(
                                color: ColorResources.getTextColor(context),
                                fontWeight: FontWeight.w500,
                                fontSize: 19),
                          ),
                          const SizedBox(
                              height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: 'your Email',
                            fillColor:
                                ColorResources.getTextFieldFillColor(context),
                            isShowBorder: false,
                            controller: _emailController,
                            inputType: TextInputType.emailAddress,
                            inputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 50),
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
                            style: TextStyle(
                                color: ColorResources.getTextColor(context),
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            LoginScreen()));
                              },
                              child: Text(
                                getTranslated('login', context),
                                style: TextStyle(
                                    color: ColorResources.getPrimaryColor(
                                        context),
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    fontSize: 17),
                              ))
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
