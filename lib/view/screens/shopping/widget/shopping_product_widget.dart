// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:wired_express/utill/Images.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:wired_express/utill/dimensions.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:wired_express/view/screens/drawer/drawer_screen.dart';
// import 'package:wired_express/view/screens/signle_product_screen/single_product_screen.dart';
//
// class ShoppingProductWidget extends StatelessWidget
//     implements PreferredSizeWidget {
//   final String? image, price, title;
//   const ShoppingProductWidget(
//       {super.key, required this.image, this.price, this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) => SingleProductScreen()));
//       },
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16), color: Colors.transparent),
//         height: 200,
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Padding(
//             padding: const EdgeInsets.all(0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   height: 150,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     color: Colors.grey[300],
//                     image: DecorationImage(
//                       image: AssetImage(image!),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         title!,
//                         maxLines: 2,
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 18),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       '$price',
//                       style: TextStyle(
//                           color: Colors.black38, fontWeight: FontWeight.w500),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => Size(double.maxFinite, kIsWeb ? 80 : 60);
// }
