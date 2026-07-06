//
// import 'package:flutter/material.dart';
// import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer_animation/shimmer_animation.dart';
// import 'package:wired_express/localization/language_constrants.dart';
// import 'package:wired_express/provider/auth_provider.dart';
// import 'package:wired_express/provider/banner_provider.dart';
// import 'package:wired_express/provider/category_provider.dart';
// import 'package:wired_express/provider/home_provider.dart';
// import 'package:wired_express/provider/place_order_provider.dart';
// import 'package:wired_express/provider/profile_provider.dart';
// import 'package:wired_express/provider/splash_provider.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:wired_express/view/base/custom_main_appbar.dart';
// import 'package:wired_express/view/screens/drawer/drawer_screen.dart';
// import 'package:wired_express/view/screens/home/widget/banner_view.dart';
// import 'package:wired_express/view/screens/home/widget/category_product_view.dart';
// import 'package:wired_express/view/screens/nearby_electricians/nearby_electricians_screen.dart';
// import 'package:wired_express/view/screens/search/widget/filter_widget.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
//       GlobalKey<ScaffoldMessengerState>();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final homeProv = Provider.of<HomeProvider>(context, listen: false);
//       homeProv.loadData(context, false);
//     });
//   }
//
//
//   final advancedDrawerController = AdvancedDrawerController();
//   @override
//   Widget build(BuildContext context) {
//     final ScrollController scrollController = ScrollController();
//
//     return AdvancedDrawer(
//         rtlOpening: false,
//         openRatio: 0.55,
//         openScale: 0.80,
//         backdrop: SafeArea(
//             child: Padding(
//                 padding: EdgeInsets.all(15.r),
//                 child: IconButton(
//                     onPressed: () => closeDrawer(),
//                     icon: Icon(Icons.close,
//                         color: ColorResources.getTextColor(context),
//                         size: 36.sp)))),
//         childDecoration: BoxDecoration(borderRadius: BorderRadius.circular(40.r)),
//         controller: advancedDrawerController,
//         animationCurve: Curves.easeInOutExpo,
//         animationDuration: const Duration(milliseconds: 400),
//         backdropColor: ColorResources.getTextFieldFillColor(context),
//         drawer: DrawerScreen(),
//         child: Scaffold(
//             backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
//             key: _scaffoldKey,
//             appBar: CustomMainAppBar(
//                 onMenuPressed: () => showDrawer(),
//                 title: getTranslated('shopping', context)),
//             body: Consumer4<CategoryProvider, ProfileProvider, SplashProvider,
//                     CustomAuthProvider>(
//                 builder: (context, categoryProvider, profileProvider,
//                     splashProvider, authProvider, child) {
//               return Padding(
//                 padding: EdgeInsets.all(15.r),
//                 child: CustomScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     controller: scrollController,
//                     slivers: [
//                       SliverToBoxAdapter(
//                         child: Consumer<BannerProvider>(
//                           builder: (context, banner, child) {
//                             return BannerView();
//                           },
//                         ),
//                       ),
//                       SliverToBoxAdapter(child: Consumer4<
//                               CategoryProvider,
//                               ProfileProvider,
//                               SplashProvider,
//                               CustomAuthProvider>(
//                           builder: (context, categoryProvider, profileProvider,
//                               splashProvider, authProvider, child) {
//                         return Column(children: [
//                           SizedBox(height: 20.h),
//                           if (authProvider.isLoggedIn()! &&
//                               profileProvider
//                                       .userInfoModel?.hasActiveSubscription ==
//                                   true)
//                             Padding(
//                               padding: EdgeInsets.only(bottom: 20),
//                               child: Container(
//                                 padding: EdgeInsets.all(15.r),
//                                 decoration: BoxDecoration(
//                                     color: Colors.amber[700],
//                                     borderRadius: BorderRadius.circular(10.r),
//                                     boxShadow: [
//                                       BoxShadow(
//                                           color: ColorResources.getBoxShadow(
//                                               context),
//                                           blurRadius: 5,
//                                           offset: const Offset(0, 2))
//                                     ]),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(Icons.star,
//                                         color: Colors.white, size: 24),
//                                     SizedBox(width: 10.w),
//                                     Text(
//                                       getTranslated('your_active_subscription_plan_place', context),
//                                       style: AppTextStyles.h4(context).copyWith(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           if (authProvider.isLoggedIn()! &&
//                               profileProvider
//                                       .userInfoModel?.nearbyElectricians ==
//                                   1 &&
//                               splashProvider.nearbyElectriciansList != null &&
//                               splashProvider.nearbyElectriciansList!.isNotEmpty)
//                             Padding(
//                               padding: EdgeInsets.only(bottom: 20),
//                               child: GestureDetector(
//                                 onTap: () => Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (BuildContext context) =>
//                                             NearbyElectriciansScreen(
//                                                 electricians: splashProvider
//                                                     .nearbyElectriciansList!))),
//                                 child: Container(
//                                   padding: EdgeInsets.all(15.r),
//                                   decoration: BoxDecoration(
//                                       color:
//                                           ColorResources.getCardColor(context),
//                                       borderRadius: BorderRadius.circular(10.r),
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: ColorResources.getBoxShadow(
//                                                 context),
//                                             blurRadius: 5,
//                                             spreadRadius: 1,
//                                             offset: const Offset(0, 2))
//                                       ]),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         getTranslated('nearby_electricians', context),
//                                         style: AppTextStyles.h4(context).copyWith(
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           categoryProvider.categoryFeaturedList == null
//                               ? SizedBox()
//                               : FilterWidget(categoryProvider),
//                           SizedBox(height: 20.h),
//                           CategoryProductView(
//                             scrollController: scrollController,
//                           ),
//                         ]);
//                       })),
//                     ]),
//               );
//             })));
//   }
//
//   void showDrawer() {
//     if (mounted) {
//       Provider.of<PlaceOrderProvider>(context, listen: false)
//           .getRunningOrderList(context)
//           .then((value) =>
//               Provider.of<PlaceOrderProvider>(context, listen: false)
//                           .runningOrderList ==
//                       null
//                   ? Provider.of<ProfileProvider>(context, listen: false)
//                       .getUserInfo(context)
//                   : Provider.of<PlaceOrderProvider>(context, listen: false)
//                       .runningOrderList![0]);
//       advancedDrawerController.showDrawer();
//       Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
//     }
//   }
//
//   void closeDrawer() {
//     if (mounted) {
//       advancedDrawerController.hideDrawer();
//       Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
//     }
//   }
//
//   void _showFreeDeliverySnackBar() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         padding: EdgeInsets.zero,
//         content: Shimmer(
//           duration: const Duration(seconds: 2),
//           enabled: true,
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//             child: Center(
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Center(
//                     child: Icon(
//                       Icons.local_shipping,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(width: 10.w),
//                   Text(
//                     getTranslated('you_have_free_delivery', context),
//                     textAlign: TextAlign.center,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: AppTextStyles.h4(context, fontSize: 15.sp).copyWith(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 20),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//         margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
//       ),
//     );
//   }
// }
