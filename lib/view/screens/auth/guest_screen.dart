import 'package:flutter/material.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';

class GuestScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),

      appBar: CustomAppBar(title: getTranslated('message', context)),

      body: Consumer<CustomAuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

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

              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              SizedBox(
                width: 100,
                height: 40,
                child: CustomButton(text: getTranslated('login', context), onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> LoginScreen()));
                }),
              ),
            ],
          ),
            ),
          ),

    );
  }
}
