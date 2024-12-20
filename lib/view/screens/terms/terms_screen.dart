import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/theme/dark_theme.dart';
import 'package:wired_express/theme/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/utill/color_resources.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      appBar:
          CustomAppBar(title: getTranslated('terms_and_condition', context)),
      body: Html(
        data: Provider.of<SplashProvider>(context, listen: false)
                .configModel!
                .termsAndConditions ??
            getTranslated('no_terms_and_condition', context),
        style: {
          "html": Style(
            backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
            color: ColorResources.getTextColor(context), // Text color
            fontSize: FontSize(16.0), // Font size
            // Add other text style properties here as needed
          ),
        },
      ),
    );
  }
}
