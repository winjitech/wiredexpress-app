// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wired_express/localization/language_constrants.dart';
// import 'package:wired_express/provider/category_provider.dart';
// import 'package:wired_express/provider/splash_provider.dart';
// import 'package:wired_express/provider/theme_provider.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:wired_express/utill/dimensions.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:wired_express/view/screens/category/category_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer_animation/shimmer_animation.dart';
//
// class CategoryView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CategoryProvider>(
//       builder: (context, category, child) {
//         return Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     // height: 90,
//                     child: category.categoryList != null
//                         ? category.categoryList!.length > 0
//                             ? GridView.builder(
//                                 key: UniqueKey(),
//                                 gridDelegate:
//                                     SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisSpacing: 10,
//                                         mainAxisSpacing: 15,
//                                         mainAxisExtent: 225,
//                                         crossAxisCount: 2),
//                                 physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: category.categoryList!.length,
//                                 padding: EdgeInsets.all(10.r),
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                       padding: EdgeInsets.only(
//                                           right: Dimensions.PADDING_SIZE_SMALL),
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (_) => CategoryScreen(
//                                                       categoryModel: category
//                                                               .categoryList![
//                                                           index])));
//                                         },
//                                         // arguments:  category.categoryList[index].name),
//                                         child: Container(
//                                           child: Column(children: [
//                                             Container(
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             15),
//                                                     color: Colors.grey[300]),
//                                                 width: double.maxFinite,
//                                                 height: 170,
//                                                 child: Image.network(
//                                                   Provider.of<SplashProvider>(
//                                                                   context,
//                                                                   listen: false)
//                                                               .baseUrls !=
//                                                           null
//                                                       ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${category.categoryList![index].image}'
//                                                       : '',
//                                                 )),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Text(
//                                               '${category.categoryList![index].name}',
//                                               textAlign: TextAlign.center,
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: AppTextStyles.h2(context, fontSize: 19.sp).copyWith(
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ]),
//                                         ),
//                                       ));
//                                 })
//                             : Center(
//                                 child: Text(
//                                   getTranslated('no_category_available', context),
//                                   style: AppTextStyles.h4(context).copyWith(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),)
//                         : CategoryShimmer(),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// class CategoryShimmer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 80.h,
//       child: ListView.builder(
//         itemCount: 14,
//         padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
//         physics: BouncingScrollPhysics(),
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
//             child: Shimmer(
//               duration: const Duration(seconds: 2),
//               enabled: true,
//               child: Column(children: [
//                 Container(
//                   height: 65,
//                   width: 65,
//                   decoration: BoxDecoration(
//                       color: ColorResources.getGreyColor(context),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: ColorResources.getBoxShadow(context),
//
//                           blurRadius: 5,
//                           spreadRadius: 1,
//                         )
//                       ]),
//                 ),
//                 SizedBox(height: 5.h),
//                 Container(
//                     height: 10,
//                     width: 50,
//                     color: ColorResources.getGreyColor(context)),
//               ]),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class CategoryAllShimmer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 80.h,
//       child: Padding(
//         padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
//         child: Shimmer(
//           duration: const Duration(seconds: 2),
//           enabled: true,
//           child: Column(children: [
//             Container(
//               height: 65,
//               width: 65,
//               decoration: BoxDecoration(
//                   color: ColorResources.getGreyColor(context),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: ColorResources.getBoxShadow(context),
//
//                       blurRadius: 5,
//                       spreadRadius: 1,
//                     )
//                   ]),
//             ),
//             SizedBox(height: 5.h),
//             Container(
//                 height: 10,
//                 width: 50,
//                 color: ColorResources.getGreyColor(context)),
//           ]),
//         ),
//       ),
//     );
//   }
// }
