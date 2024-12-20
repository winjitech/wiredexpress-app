// import 'package:flutter/material.dart';
// import 'package:lacrostini_app/localization/language_constrants.dart';
// import 'package:lacrostini_app/provider/auth_provider.dart';
// import 'package:lacrostini_app/utill/routes.dart';
// import 'package:lacrostini_app/view/base/mars_menu_bar.dart' as menu;
// import 'package:provider/provider.dart';
//
// class MenuBar extends StatelessWidget {
//
//   List<menu.MenuItem> getMenus(BuildContext context) {
//     final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn()!;
//     return [
//       menu.MenuItem(
//         title: getTranslated('home', context),
//         icon: Icons.home_filled,
//         onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('home')),
//       ),
//       menu.MenuItem(
//         title: getTranslated('set_menu', context),
//         icon: Icons.fastfood_outlined,
//         onTap: () => Navigator.pushNamed(context, Routes.getSetMenuRoute()),
//       ),
//       menu.MenuItem(
//         title: getTranslated('necessary_links', context),
//         icon: Icons.settings,
//         children: [
//           menu.MenuItem(
//             title: getTranslated('privacy_policy', context),
//             onTap: () => Navigator.pushNamed(context, Routes.getPolicyRoute()),
//           ),
//           menu.MenuItem(
//             title: getTranslated('terms_and_condition', context),
//             onTap: () => Navigator.pushNamed(context, Routes.getTermsRoute()),
//           ),
//           menu.MenuItem(
//             title: getTranslated('about_us', context),
//             onTap: () => Navigator.pushNamed(context, Routes.getAboutUsRoute()),
//           ),
//
//         ],
//       ),
//       menu.MenuItem(
//         title: getTranslated('favourite', context),
//         icon: Icons.favorite_border,
//         onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('favourite')),
//       ),
//
//       _isLoggedIn ?  menu.MenuItem(
//         title: getTranslated('profile', context),
//         icon: Icons.person,
//         onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('menu')),
//       ):  menu.MenuItem(
//         title: getTranslated('login', context),
//         icon: Icons.lock,
//         onTap: () => Navigator.pushNamed(context, Routes.getLoginRoute()),
//       ),
//       menu.MenuItem(
//         title: '',
//         icon: Icons.shopping_cart,
//         onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('cart')),
//       ),
//
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Container(
//       //color: Colors.white,
//       width: 650,
//       child: menu.PlutoMenuBar(
//         backgroundColor: Colors.white,
//         gradient: false,
//         goBackButtonText: 'Back',
//         textStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
//         moreIconColor: Theme.of(context).textTheme.bodyText1.color,
//         menuIconColor: Theme.of(context).textTheme.bodyText1.color,
//         menus: getMenus(context),
//
//       ),
//     );
//   }
// }