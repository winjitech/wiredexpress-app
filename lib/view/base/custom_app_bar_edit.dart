// import 'package:flutter/material.dart';
// import 'package:wired_express/helper/responsive_helper.dart';
// import 'package:wired_express/provider/splash_provider.dart';
// import 'package:wired_express/utill/dimensions.dart';
// import 'package:wired_express/utill/images.dart';
// import 'package:wired_express/utill/routes.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:wired_express/view/base/menu_bar.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
//
// class CustomAppBarEdit extends StatelessWidget implements PreferredSizeWidget {
//   final String? title;
//   final bool? isBackButtonExist;
//   final VoidCallback? onBackPressed;
//   CustomAppBarEdit({@required this.title, this.isBackButtonExist = true, this.onBackPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text(title!, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,
//           color: Theme.of(context).textTheme.bodyText1!.color)),
//       centerTitle: true,
//       leading: isBackButtonExist! ? IconButton(
//         icon: Icon(Icons.arrow_back_ios),
//         color: Theme.of(context).textTheme.bodyText1!.color,
//         onPressed: () => onBackPressed != null ? onBackPressed!() :  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> DashboardScreen(pageIndex: 0))),
//       ) : SizedBox(),
//       backgroundColor: Color(0xffeff4f6),
//       elevation: 0,
//     );
//   }
//
//   @override
//   Size get preferredSize => Size(double.maxFinite, kIsWeb ? 80 : 50);
// }
