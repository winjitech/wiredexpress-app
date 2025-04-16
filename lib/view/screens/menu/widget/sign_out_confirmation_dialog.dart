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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
            color: ColorResources.getScaffoldColor(context!),
            borderRadius: BorderRadius.circular(10)),
        child: Consumer<CustomAuthProvider>(builder: (context, auth, child) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(Icons.contact_support,
                  color: ColorResources.getScaffoldColor(context), size: 50),
            ),
            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: Text(getTranslated('do_you_want_signout', context),
                  style: TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                  textAlign: TextAlign.center),
            ),
            Divider(height: 0, color: ColorResources.getHintColor(context)),
            !auth!.isLoading!
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
                            style: rubikBold.copyWith(color: Colors.white)),
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: CustomCircularIndicator(color: Colors.white),
                  ),
          ]);
        }),
      ),
    );
  }
}
