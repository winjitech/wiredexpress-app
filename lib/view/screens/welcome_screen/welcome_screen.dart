import 'package:flutter/material.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),

      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)) : null,
      body: Scrollbar(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
        children: [
          SizedBox(height: 50),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.all(30),
                    child: ResponsiveHelper.isWeb() ? Consumer<SplashProvider>(
                      builder:(context, splash, child) => FadeInImage.assetNetwork(
                        placeholder: Images.loading,
                        image: splash.baseUrls != null ? '${splash.baseUrls!.storeImageUrl}/${splash.configModel!.storeLogo}' : '',
                        height: 200,
                      ),
                    ) : Image.asset(
                        Images.logo,
                        height: 200),
                  ),
          SizedBox(height: 30),
          Text(
            getTranslated('welcome', context),
            textAlign: TextAlign.center,
            style: TextStyle(color:ColorResources.getTextColor(context), fontSize: 32),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            child: Text(
              getTranslated('welcome_to_app', context),
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorResources.getGreyColor(context)),
            ),
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            child: CustomButton(
              text: getTranslated('login', context),
              onTap: () {
                        Navigator.pushReplacementNamed(context, Routes.getLoginRoute());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: Dimensions.PADDING_SIZE_DEFAULT,
                right: Dimensions.PADDING_SIZE_DEFAULT,
                bottom: Dimensions.PADDING_SIZE_DEFAULT,
                top: 12),
            child: CustomButton(
              text: getTranslated('signup', context),
              onTap: () {
                        Navigator.pushReplacementNamed(context, Routes.getSignUpRoute());
              },
              backgroundColor: Colors.black,
            ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(1, 40),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, Routes.getMainRoute());
                    },
                    child: RichText(text: TextSpan(children: [
                      TextSpan(text: '${getTranslated('login_as_a', context)} ', style: rubikRegular.copyWith(color: ColorResources.getGreyColor(context))),
                      TextSpan(text: getTranslated('guest', context), style: rubikMedium.copyWith(color:ColorResources.getTextColor(context))),
                    ])),
                  ),


        ],
      ),
            ),
          ),
        ),
      ),
    );
  }
}
