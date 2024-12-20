import 'package:flutter/material.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/main_app_bar.dart';

class ThanksFeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),

      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)):null,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Images.done_with_full_background,
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 60),
                Text(
                  getTranslated('thanks_for_your_order', context),
                  style:TextStyle(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                        color: ColorResources.getGreyBunkerColor(context),
                      ),
                ),
                SizedBox(height: 23),
                Text(
                  getTranslated('it_will_helps_to_improve', context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                        color: ColorResources.getGreyBunkerColor(context).withOpacity(.75),
                      ),
                ),
                SizedBox(height: 50),
                CustomButton(
                  text: getTranslated('back_home', context),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.pushReplacementNamed(context, Routes.getMainRoute());
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
