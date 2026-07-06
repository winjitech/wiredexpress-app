import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';

class NotLoggedInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  getTranslated('guest_mode', context),
                  style: AppTextStyles.h1(context).copyWith(
                    color: ColorResources.getGreyBunkerColor(context),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  right: 25,
                  left: 25.w,
                  bottom: 25,
                  top: 15.h,
                ),
                child: Text(
                  getTranslated('now_you_are_in_guest_mode', context),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h7(context).copyWith(
                    color: ColorResources.getHintColor(context),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                ),
                child: Container(
                  padding:  EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorResources.getPrimaryColor(context),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Text(
                    getTranslated('login', context),
                    style: AppTextStyles.h4(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorResources.getScaffoldBackgroundColor(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}