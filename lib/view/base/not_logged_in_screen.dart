import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';

class NotLoggedInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Container(
          // color: Colors.white,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            /*  Image.asset(
            Images.guest_login,
            width: MediaQuery.of(context).size.height*0.25,
            height: MediaQuery.of(context).size.height*0.25,
          ),

         */
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Center(
                child: Text(
                  getTranslated('guest_mode', context),
                  style: TextStyle(
                      fontSize: 24,
                      color: ColorResources.getGreyBunkerColor(context)),
                )),
            SizedBox(height: 20),

            // for first name section
            Padding(padding: EdgeInsets.only(right: 25, left: 25 , bottom: 25 , top: 15),
                child: Text(
                  getTranslated('now_you_are_in_guest_mode', context),textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorResources.getHintColor(context)),
                )
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            SizedBox(
              width: 100,
              height: 40,
              child: CustomButton(
                  text: getTranslated('login', context),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen()));
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}
