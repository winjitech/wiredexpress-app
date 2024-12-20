import 'dart:async';

import 'package:wired_express/data/model/response/userinfo_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/Custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmDeleteAccountBottomSheet extends StatefulWidget {
  final UserInfoModel account;

  const ConfirmDeleteAccountBottomSheet({super.key, required this.account});

  @override
  State<ConfirmDeleteAccountBottomSheet> createState() =>
      _ConfirmDeleteAccountBottomSheetState();
}

class _ConfirmDeleteAccountBottomSheetState extends State<ConfirmDeleteAccountBottomSheet> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 0), () {
      final customAuthProvider = Provider.of<CustomAuthProvider>(context, listen: false);
      customAuthProvider.hideConfirmPasswordSection();
      customAuthProvider.hideConfirmPasswordErrorText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CustomAuthProvider, ProfileProvider>(
      builder: (context, customAuthProvider, profileProvider, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(35),
              topLeft: Radius.circular(35),
            ),
            color: ColorResources.getCardColor(context),
          ),
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: customAuthProvider.confirmPasswordSection == true
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                customAuthProvider.hideConfirmPasswordSection();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                size: 18,
                                color: ColorResources.getTextColor(context),
                              )),
                          Text(
                            getTranslated('confirm_password', context),
                            style: TextStyle(
                                color: ColorResources.getTextColor(context),
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.close,
                                color: ColorResources.getTextColor(context),
                              ))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              isShowBorder: true,
                              controller: _passwordController,
                              isPassword: true, isShowSuffixIcon: true,
                              labelText: getTranslated('password', context),
                              // isEnabled: false,
                              hintText:getTranslated('enter_password', context),
                            ),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              isShowBorder: true,
                              controller: _confirmPasswordController,
                              isPassword: true, isShowSuffixIcon: true,
                              labelText: getTranslated('confirm_password', context),
                              // isEnabled: false,
                              hintText: getTranslated('enter_confirm_password', context),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            if (customAuthProvider.confirmPasswordErrorTextShow == true)
                              Row(
                                children: [
                                  const Icon(Icons.circle, size: 14, color: Colors.red,),
                                  const SizedBox(width: 15,),
                                  Text(customAuthProvider.confirmPasswordErrorText!,
                                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 14,),
                                  )
                                ],
                              ),
                            const SizedBox(height: 35,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              child: customAuthProvider.deleteAccountLoading == true
                                  ? Center(
                                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<
                                          Color>(ColorResources.getPrimaryColor(context))))
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                            text: getTranslated('confirm', context),
                                            onTap: () {
                                              customAuthProvider.hideConfirmPasswordErrorText();
                                              String _password = _passwordController.text.trim();
                                              String _confirmPassword = _confirmPasswordController.text.trim();
                                              print(customAuthProvider.getUserPassword());

                                              if (_password.isEmpty) {
                                                customAuthProvider.showConfirmPasswordErrorText(getTranslated("password_empty", context));
                                              } else if ((_password.isNotEmpty && _password.length < 6)
                                                  || (_confirmPassword.isNotEmpty && _confirmPassword.length < 6)) {
                                                showCustomSnackBar(getTranslated("password_length", context), context);
                                                customAuthProvider.showConfirmPasswordErrorText(getTranslated("password_length", context));
                                              } else if (_password != _confirmPassword) {
                                                customAuthProvider.showConfirmPasswordErrorText(
                                                        getTranslated("password_match", context));
                                              } else {
                                                if (customAuthProvider.getUserPassword() == _password &&
                                                    _password == _confirmPassword) {
                                                  customAuthProvider.deleteAccount(context, customAuthProvider.getUserToken()!)
                                                      .then((value) {
                                                    if (value.isSuccess) {
                                                      showDialog(
                                                          context:context,
                                                          builder:
                                                              (_) =>
                                                                  AlertDialog(
                                                                    title: Text(
                                                                      getTranslated('account_deleted', context),
                                                                      style: TextStyle(
                                                                          color: ColorResources.getTextColor(context),
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: 15),
                                                                    ),
                                                                  ));
                                                      customAuthProvider.clearSharedData();
                                                      customAuthProvider.clearUserEmailAndPassword();
                                                      Navigator.push(context,
                                                          MaterialPageRoute(builder: (BuildContextcontext) =>
                                                              SplashScreen()));
                                                    } else {
                                                      customAuthProvider.showConfirmPasswordErrorText(
                                                          getTranslated("something_went_wrong", context));
                                                    }
                                                  });
                                                } else {
                                                  customAuthProvider.showConfirmPasswordErrorText(
                                                          getTranslated("password_not_correct", context));
                                                }
                                              }
                                            },
                                            radius: 15,
                                            height: 36,
                                            textSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated('confirm_delete_account', context),
                            style: TextStyle(
                                color: ColorResources.getTextColor(context),
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.close,
                                color: ColorResources.getTextColor(context),
                              ))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: ColorResources.getPrimaryColor(context),
                                child: Icon(Icons.delete,
                                    color: ColorResources.getScaffoldBackgroundColor(context),
                                    size: 40),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                              child: Text(
                                  getTranslated('are_you_sure_you_need_delete_your_account', context),
                                  style: TextStyle(
                                      color: ColorResources.getTextColor(context),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center),
                            ),
                            Text(
                              getTranslated('delete_user_account_text', context),
                              style: TextStyle(
                                  color: ColorResources.getTextColor(context).withOpacity(0.6),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 35,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      text: getTranslated('yes', context),
                                      onTap: () {
                                        customAuthProvider.hideConfirmPasswordErrorText();
                                        customAuthProvider.showConfirmPasswordSection();
                                      },
                                      radius: 15,
                                      height: 36,
                                      textSize: 16,
                                      backgroundColor: ColorResources.getCardColor(context),
                                      textColor: ColorResources.getPrimaryColor(context),
                                      borderColor: ColorResources.getPrimaryColor(context),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: CustomButton(
                                      text: getTranslated('no', context),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      radius: 15,
                                      height: 36,
                                      textSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        );
      },
    );
  }
}
