// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter/material.dart';
// import 'package:wired_express/utill/Images.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:wired_express/utill/dimensions.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:wired_express/view/screens/categories/categories_screen.dart';
//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String? title;
//   final bool? isBackButtonExist;
//   final VoidCallback? onBackPressed;
//   final bool? filterButton;
//   CustomAppBar(
//       {@required this.title,
//       this.isBackButtonExist = true,
//       this.onBackPressed,
//       this.filterButton = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text(
//         title!,
//         style: AppTextStyles.h2(context).copyWith(
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       centerTitle: true,
//       leading: isBackButtonExist!
//           ? IconButton(
//               icon: Icon(Icons.arrow_back_ios, size: 18.sp),
//               color: ColorResources.getTextColor(context),
//               onPressed: () => onBackPressed != null
//                   ? onBackPressed!()
//                   : Navigator.pop(context),
//             )
//           : SizedBox(),
//       actions: [
//         filterButton == true
//             ? IconButton(
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (BuildContext context) =>
//                               CategoriesScreen()));
//                 },
//                 icon: Image.asset(
//                   Images.filterIcon,
//                   height: 80.h,
//                   width: 80.w,
//                 ))
//             : SizedBox()
//       ],
//       backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
//       elevation: 0,
//     );
//   }
//
//   @override
//   Size get preferredSize => Size(double.maxFinite, kIsWeb ? 80 : 70);
// }
