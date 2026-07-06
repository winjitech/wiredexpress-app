// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wired_express/utill/Images.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:wired_express/utill/dimensions.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:wired_express/view/screens/cart/cart_screen.dart';
// import 'package:wired_express/view/screens/categories/categories_screen.dart';
// import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
// import 'package:wired_express/view/screens/drawer/drawer_screen.dart';
//
// class CustomMainAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String? title;
//   final bool? isBackButtonExist;
//   final bool? fromCategory;
//   final VoidCallback? onMenuPressed;
//   CustomMainAppBar(
//       {@required this.title,
//       this.isBackButtonExist = true,
//       this.fromCategory = false,
//       this.onMenuPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text(
//         title!,
//         style: AppTextStyles.h2(context).copyWith(
//           fontSize: 22.sp,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       centerTitle: true,
//       leading: Padding(
//         padding: EdgeInsets.only(left: 15.w),
//         child: IconButton(
//           icon: Icon(Icons.menu,
//               size: 30.sp, color: ColorResources.getTextColor(context)),
//           color: ColorResources.getTextColor(context),
//           onPressed: onMenuPressed,
//         ),
//       ),
//       actions: [
//         fromCategory == true
//             ? SizedBox()
//             : IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (BuildContext context) =>
//                               CategoriesScreen()));
//                 },
//                 icon: Image.asset(Images.filterIcon,
//                     height: 80.h,
//                     width: 80.w,
//                     color: ColorResources.getTextColor(context))),
//         // Padding(
//         //   padding: EdgeInsets.only(right: 15.w),
//         //   child: IconButton(
//         //       onPressed: () {
//         //         Navigator.push(
//         //             context,
//         //             MaterialPageRoute(
//         //                 builder: (BuildContext context) =>
//         //                     DashboardScreen(pageIndex: 1)));
//         //       },
//         //       icon: Image.asset(Images.cartIcon,
//         //           height: 80.h,
//         //           width: 80.w,
//         //           color: ColorResources.getTextColor(context))),
//         // ),
//       ],
//       backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
//       toolbarHeight: 80,
//       elevation: 0,
//     );
//   }
//
//   @override
//   Size get preferredSize => Size(double.maxFinite, kIsWeb ? 80 : 60);
// }
