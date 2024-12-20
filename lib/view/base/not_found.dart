import 'package:flutter/material.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/theme/dark_theme.dart';
import 'package:wired_express/theme/light_theme.dart';
import 'package:provider/provider.dart';

class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),

      appBar: ResponsiveHelper.isDesktop(context) ? MainAppBar() : null,
      body: Center(
        child: TweenAnimationBuilder(
          curve: Curves.bounceOut,
          duration: Duration(seconds: 2),
          tween: Tween<double>(begin: 12.0, end: 30.0),
          builder: (BuildContext? context, dynamic? value, Widget? child) {
            return Text(getTranslated( 'page_not_found' , context!),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: value));
          },
        ),
      ),
    );
  }
}
