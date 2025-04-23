import 'package:flutter/material.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/theme/dark_theme.dart';
import 'package:wired_express/theme/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:wired_express/view/screens/menu/widget/options_view.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  final Function? onTap;
  MenuScreen({this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }

    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      appBar: CustomAppBar(
        title: getTranslated('profile', context),
        isBackButtonExist: false,
      ),
      body: Column(children: [
        Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) => Center(),
        ),
        Expanded(child: OptionsView(onTap: () {
          print('');
        })),
      ]),
    );
  }
}
