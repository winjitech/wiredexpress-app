import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/localization/language_constrants.dart';

import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';
import 'package:wired_express/view/screens/splash_screen.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
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
                ? Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0, vertical: 5),
              child: Row(children: [
                Expanded(
                    child: CustomButton(
                      radius: 35,
                      height: 40,
                      textSize: 16,
                      backgroundColor:
                      ColorResources.getScaffoldBackgroundColor(context),
                      textColor: ColorResources.getPrimaryColor(context),
                      borderColor: ColorResources.getPrimaryColor(context),
                      text: getTranslated('yes', context),
                      onTap: () {
                        Provider.of<CustomAuthProvider>(context,
                            listen: false)
                            .clearSharedData()
                            .then((condition) {
                          Hive.box('myBox').clear();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginScreen()));
                        });
                      },
                    )),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: CustomButton(
                      radius: 35,
                      height: 40,
                      textSize: 16,
                      text: getTranslated('no', context),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
              ]),
            )
                : Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: CustomCircularIndicator(),
            ),
          ]);
        }),
      ),
    );
  }
}
