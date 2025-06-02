import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
            color: ColorResources.getScaffoldBackgroundColor(context),
            borderRadius: BorderRadius.circular(15)),
        width: 300,
        child: Consumer<CustomAuthProvider>(builder: (context, auth, child) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              backgroundColor: ColorResources.getPrimaryColor(context),
              child: Icon(Icons.contact_support,
                  color: ColorResources.getScaffoldBackgroundColor(context),
                  size: 50),
            ),
            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: Text(getTranslated('want_to_sign_out', context),
                  style: rubikBold.copyWith(
                      fontSize: 15,
                      color: ColorResources.getTextColor(context)),
                  textAlign: TextAlign.center),
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
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10))),
                        child: Text(getTranslated('yes', context),
                            style: rubikBold.copyWith(
                              color: ColorResources.getTextColor(context),
                            )),
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ColorResources.getTextColor(context),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Text(getTranslated('no', context),
                            style: rubikBold.copyWith(
                                color:
                                    ColorResources.getScaffoldColor(context))),
                      ),
                    )),
                  ])
                : Padding(
                    padding: EdgeInsets.all(15),
                    child: CustomCircularIndicator(),
                  ),
          ]);
        }),
      ),
    );
  }
}
