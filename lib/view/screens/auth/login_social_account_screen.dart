// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';
// import 'package:sign_button/sign_button.dart';
// import 'package:social_login_buttons/social_login_buttons.dart';
// import 'package:wired_express/localization/language_constrants.dart';
// import 'package:wired_express/provider/auth_provider.dart';
// import 'package:wired_express/provider/notification_provider.dart';
// import 'package:wired_express/utill/Images.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:wired_express/view/base/custom_app_bar.dart';
// import 'package:wired_express/view/base/custom_social_button.dart';
// import 'package:wired_express/view/screens/auth/signup_screen.dart';
//
// class LoginSocialAccountScreen extends StatefulWidget {
//   @override
//   _LoginSocialAccountScreenState createState() =>
//       _LoginSocialAccountScreenState();
// }
//
// class _LoginSocialAccountScreenState extends State<LoginSocialAccountScreen> {
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
//       GlobalKey<ScaffoldMessengerState>();
//
//   ScrollController scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     Timer(Duration(seconds: 1), () async {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
//       key: _scaffoldKey,
//       body: Consumer<CustomAuthProvider>(
//         builder: (context, customAuthProvider, child) {
//           return Scrollbar(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: AssetImage(Images.loginBackground),
//                             fit: BoxFit.cover)),
//                     width: MediaQuery.of(context).size.width,
//                     height: 500,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(30),
//                     child: Column(
//                       children: [
//                         CustomSocialButton(
//                           onTap: () {},
//                           text: '${getTranslated('log_with', context)} Google',
//                           buttonType: ButtonType.google,
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         CustomSocialButton(
//                           onTap: () {},
//                           text: '${getTranslated('log_with', context)} Facebook',
//                           buttonType: ButtonType.facebook,
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         CustomSocialButton(
//                           onTap: () {},
//                           text: '${getTranslated('log_with', context)} Apple',
//                           buttonType: ButtonType.apple,
//                         ),
//                         SizedBox(
//                           height: 15,
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               getTranslated('dont_have_account', context),
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w400, fontSize: 15),
//                             ),
//                             TextButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (BuildContext context) =>
//                                               SignUpScreen()));
//                                 },
//                                 child: Text(
//                                   getTranslated('signup', context),
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 17),
//                                 ))
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
