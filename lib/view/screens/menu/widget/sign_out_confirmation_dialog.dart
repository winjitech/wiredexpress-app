import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/localization/language_constrants.dart';

import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/screens/splash_screen.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext? context) {
    return Dialog(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Container(
        decoration: BoxDecoration(
            color: ColorResources.getScaffoldBackgroundColor(context),
            borderRadius: BorderRadius.circular(15.r)),
        width: 300,
        child: Consumer<CustomAuthProvider>(builder: (context, auth, child) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: 20.h),
            CircleAvatar(
              radius: 30,
              backgroundColor: ColorResources.getPrimaryColor(context),
              child: Icon(Icons.contact_support,
                  color: ColorResources.getScaffoldBackgroundColor(context),
                  size: 50.sp),
            ),
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Text(
                getTranslated('want_to_sign_out', context),
                style: AppTextStyles.h4(context, fontSize: 15.sp).copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            !auth.isLogoutLoading!
                ? Row(children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Provider.of<CustomAuthProvider>(context, listen: false)
                            .clearSharedData()
                            .then((condition) async {
                          await FirebaseAuth.instance.signOut().then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SplashScreen()));
                          });
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10))),
                        child:Text(
                          getTranslated('yes', context),
                          style: AppTextStyles.h6(context).copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ColorResources.getTextColor(context),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Text(
                          getTranslated('no', context),
                          style: AppTextStyles.h6(context).copyWith(
                            fontWeight: FontWeight.w700,
                            color: ColorResources.getScaffoldBackgroundColor(context),
                          ),
                        ),
                      ),
                    )),
                  ])
                : Padding(
                    padding: EdgeInsets.all(15.r),
                    child: CustomCircularIndicator(),
                  ),
          ]);
        }),
      ),
    );
  }
}
