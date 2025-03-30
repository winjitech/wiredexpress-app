// import 'package:flutter/material.dart';
// import 'package:sign_button/sign_button.dart';
// import 'package:wired_express/utill/color_resources.dart';
//
// class CustomSocialButton extends StatelessWidget {
//   final VoidCallback? onTap;
//   final String? text;
//   final ButtonType? buttonType;
//
//   CustomSocialButton({
//     this.onTap,
//     @required this.text,
//     this.buttonType,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: onTap,
//         child: Container(
//           height: 65,
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//               color: Colors.grey[200], borderRadius: BorderRadius.circular(40)),
//           child: Padding(
//             padding: const EdgeInsets.all(0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10),
//                   child: Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(50)),
//                     child: SignInButton.mini(
//                       btnColor: Colors.transparent,
//                       elevation: 0,
//                       buttonSize: ButtonSize.small,
//                       padding: 0,
//                       buttonType: buttonType!,
//                       onPressed: () {},
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 40,
//                 ),
//                 Text(
//                   text!,
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
// }
