import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';

class NotLoggedInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Container(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
           
              Center(
                  child: Text(
                getTranslated('guest_mode', context),
                style: TextStyle(
                    fontSize: 24,
                    color: ColorResources.getGreyBunkerColor(context)),
              )),
              Padding(
                  padding:
                      EdgeInsets.only(right: 25, left: 25, bottom: 25, top: 15),
                  child: Text(
                    getTranslated('now_you_are_in_guest_mode', context),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: ColorResources.getHintColor(context)),
                  )),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen())),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                      color: ColorResources.getPrimaryColor(context),
                      borderRadius: BorderRadius.circular(40)),
                  child: Text(
                    getTranslated('login', context),
                    style: TextStyle(
                        color: ColorResources.getScaffoldBackgroundColor(context),
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
