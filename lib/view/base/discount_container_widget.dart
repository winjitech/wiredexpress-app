//
// import 'package:flutter/material.dart';
// import 'package:wired_express/utill/Images.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:wired_express/utill/dimensions.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:wired_express/view/screens/drawer/drawer_screen.dart';
//
// class DiscountContainerWidget extends StatelessWidget implements PreferredSizeWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             ColorResources.getScaffoldColor(context),
//             Colors.grey.shade700,
//           ],
//         ),
//       ),
//       width: MediaQuery.of(context).size.width,
//       height: 200,
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   color: Colors.white,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 15, vertical: 5),
//                   child: Text(
//                     "Promo",
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 'Up to',
//                 style: TextStyle(
//                     color: Colors.white, fontSize: 18),
//               ),
//               Row(
//                 children: [
//                   Text(
//                     '30%',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 40,
//                         fontWeight: FontWeight.w700),
//                   ),
//                   SizedBox(width: 10),
//                   Text(
//                     'off',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w700),
//                   ),
//                 ],
//               ),
//               Text(
//                 'Only on 10.10',
//                 style: TextStyle(
//                     color: Colors.white, fontSize: 18),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => Size(double.maxFinite, kIsWeb ? 80 : 60);
// }
