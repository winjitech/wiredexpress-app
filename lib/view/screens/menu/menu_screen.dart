// import 'package:flutter/material.dart';
// import 'package:wired_express/helper/responsive_helper.dart';
// import 'package:wired_express/localization/language_constrants.dart';
// import 'package:wired_express/provider/auth_provider.dart';
// import 'package:wired_express/provider/profile_provider.dart';
// import 'package:wired_express/utill/color_resources.dart';import 'package:wired_express/provider/theme_provider.dart';
// import 'package:wired_express/theme/dark_theme.dart';
// import 'package:wired_express/theme/light_theme.dart';
// import 'package:provider/provider.dart';
// import 'package:wired_express/utill/dimensions.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:wired_express/view/base/main_app_bar.dart';
// import 'package:wired_express/view/screens/menu/widget/options_view.dart';
// import 'package:provider/provider.dart';
//
// class MenuScreen extends StatelessWidget {
//   final Function? onTap;
//   MenuScreen({this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     final bool _isLoggedIn =
//         Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
//     if (_isLoggedIn) {
//       Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
//     }
//
//     return Scaffold(        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
//
//       appBar: ResponsiveHelper.isDesktop(context)
//           ? PreferredSize(
//               child: MainAppBar(), preferredSize: Size.fromHeight(80))
//           : null,
//       body: Column(children: [
//         Consumer<ProfileProvider>(
//           builder: (context, profileProvider, child) => Center(
//             child: Container(
//              width: MediaQuery.of(context).size.width,
//               padding: EdgeInsets.symmetric(vertical: 50),
//               decoration: BoxDecoration(color:ColorResources.getPrimaryColor(context)),
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     /*    Container(
//                   height: 80, width: 80,
//                   decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ColorResources.COLOR_WHITE, width: 2)),
//                   child: ClipOval(
//                     child: _isLoggedIn ? FadeInImage.assetNetwork(
//                       placeholder: Images.placeholder_user,
//                       image: '${Provider.of<SplashProvider>(context,).baseUrls.customerImageUrl}/'
//                           '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel.image : ''}',
//                       height: 80, width: 80, fit: BoxFit.cover,
//                     ) : Image.asset(Images.placeholder_user, height: 80, width: 80, fit: BoxFit.cover),
//                   ),
//                 ), */
//                     Column(children: [
//                       SizedBox(height: 20),
//                       _isLoggedIn
//                           ? profileProvider.userInfoModel != null
//                               ? Text(
//                                   profileProvider
//                                               .userInfoModel!.fName!.isEmpty ||
//                                           profileProvider
//                                               .userInfoModel!.lName!.isEmpty
//                                       ? profileProvider.userInfoModel!.phone
//                                           .toString()
//                                       : '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
//                                   style: rubikRegular.copyWith(
//                                       fontSize:
//                                           Dimensions.FONT_SIZE_EXTRA_LARGE,
//                                       color: ColorResources.COLOR_WHITE),
//                                 )
//                               : Container(
//                                   height: 15, width: 150, color: Colors.white)
//                           : Text(
//                               getTranslated('guest', context),
//                               style: rubikRegular.copyWith(
//                                   fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
//                                   color: ColorResources.COLOR_WHITE),
//                             ),
//                       SizedBox(height: 10),
//                       _isLoggedIn
//                           ? profileProvider.userInfoModel != null
//                               ? Text(
//                                   '${profileProvider.userInfoModel!.email ?? ''}',
//                                   style: rubikRegular.copyWith(
//                                       color: ColorResources.BACKGROUND_COLOR),
//                                 )
//                               : Container(
//                                   height: 15, width: 100, color: Colors.white)
//                           : Text(
//                               '',
//                               style: rubikRegular.copyWith(
//                                   fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
//                                   color: ColorResources.COLOR_WHITE),
//                             ),
//                     ]),
//                   ]),
//             ),
//           ),
//         ),
//         Expanded(child: OptionsView(onTap:(){print( 'onTap!');})),
//       ]),
//     );
//   }
// }
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
