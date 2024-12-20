// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:wired_express/helper/responsive_helper.dart';
// import 'package:wired_express/localization/language_constrants.dart';
// import 'package:wired_express/provider/auth_provider.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:wired_express/utill/dimensions.dart';
// import 'package:wired_express/utill/routes.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:wired_express/view/screens/splash_screen.dart';
// import 'package:provider/provider.dart';
//
// class SignOutConfirmationDialog extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Container(
//         width: 300,
//         child: Consumer<CustomAuthProvider>(builder: (context, auth, child) {
//           return Column(mainAxisSize: MainAxisSize.min, children: [
//             SizedBox(height: 20),
//             CircleAvatar(
//               radius: 30,
//               backgroundColor: ColorResources.getPrimaryColor(context),
//               child: Icon(Icons.contact_support,
//                   color: ColorResources.getScaffoldBackgroundColor(context),
//                   size: 50),
//             ),
//             Padding(
//               padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
//               child: Text(getTranslated('want_to_sign_out', context),
//                   style: rubikBold.copyWith(
//                       fontSize: 15,
//                       color: ColorResources.getTextColor(context)),
//                   textAlign: TextAlign.center),
//             ),
//             Divider(height: 0, color: ColorResources.getHintColor(context)),
//             !auth.isLoading!
//                 ? Row(children: [
//                     Expanded(
//                         child: InkWell(
//                       onTap: () {
//                         Provider.of<CustomAuthProvider>(context, listen: false)
//                             .clearSharedData()
//                             .then((condition) {
//                           Hive.box('myBox').clear();
//                           if (ResponsiveHelper.isWeb()) {
//                             Navigator.pop(context);
//
//                             // Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
//                           } else {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (BuildContext context) =>
//                                         SplashScreen()));
//                             // Navigator.pushNamedAndRemoveUntil(context, Routes.getSplashRoute(), (route) => false);
//                           }
//                         });
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                                 bottomLeft: Radius.circular(10))),
//                         child: Text(getTranslated('yes', context),
//                             style: rubikBold.copyWith(
//                                 color:
//                                     ColorResources.getPrimaryColor(context))),
//                       ),
//                     )),
//                     Expanded(
//                         child: InkWell(
//                       onTap: () => Navigator.pop(context),
//                       child: Container(
//                         padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: ColorResources.getPrimaryColor(context),
//                           borderRadius: BorderRadius.only(
//                               bottomRight: Radius.circular(10)),
//                         ),
//                         child: Text(getTranslated('no', context),
//                             style: rubikBold.copyWith(
//                                 color:
//                                     ColorResources.getScaffoldBackgroundColor(
//                                         context))),
//                       ),
//                     )),
//                   ])
//                 : Padding(
//                     padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//                     child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                             ColorResources.getPrimaryColor(context))),
//                   ),
//           ]);
//         }),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/localization/language_constrants.dart';

import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/screens/splash_screen.dart';

class SignOutConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext? context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
            color: ColorResources.SCAFFOLD_COLOR,
            borderRadius: BorderRadius.circular(10)),
        child: Consumer<CustomAuthProvider>(builder: (context, auth, child) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(Icons.contact_support,
                  color: ColorResources.SCAFFOLD_COLOR, size: 50),
            ),
            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: Text(getTranslated('do_you_want_signout', context),
                  style: TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                  textAlign: TextAlign.center),
            ),
            Divider(height: 0, color: ColorResources.getHintColor(context)),
            !auth!.isLoading!
                ? Row(children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Provider.of<CustomAuthProvider>(context, listen: false)
                            .clearSharedData()
                            .then((condition) async {
                          await FirebaseAuth.instance.signOut().then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SplashScreen()));
                          });
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10))),
                        child: Text(getTranslated('yes', context),
                            style: rubikBold.copyWith(color: Colors.white)),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Text(getTranslated('no', context),
                            style: rubikBold.copyWith(
                                color: ColorResources.SCAFFOLD_COLOR)),
                      ),
                    )),
                  ])
                : Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white)),
                  ),
          ]);
        }),
      ),
    );
  }
}
