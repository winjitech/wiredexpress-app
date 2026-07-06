// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:wired_express/helper/responsive_helper.dart';
// import 'package:wired_express/localization/language_constrants.dart';
// import 'package:wired_express/provider/category_provider.dart';
// import 'package:wired_express/provider/product_provider.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:wired_express/utill/dimensions.dart';
// import 'package:wired_express/utill/styles.dart';
// import 'package:wired_express/view/base/circular_indicator_widget.dart';
// import 'package:wired_express/view/base/product_widget.dart';
// import 'package:provider/provider.dart';
//
// class CategoryProductView extends StatelessWidget {
//   final ScrollController? scrollController;
//   CategoryProductView({this.scrollController});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Consumer<CategoryProvider>(
//           builder: (context, categoryProvider, child) {
//             scrollController?.addListener(() {
//               if (scrollController!.position.pixels ==
//                       scrollController!.position.maxScrollExtent &&
//                   categoryProvider.categoryProductList != null &&
//                   !categoryProvider.categoryProductListIsLoading) {
//                 if (categoryProvider.categoryProductList!.length <
//                     categoryProvider.totalCategoryProductListSize!) {
//                   int nextOffset = (int.tryParse(
//                               categoryProvider.categoryProductListOffset ??
//                                   "1") ??
//                           1) +
//                       1;
//                   print("nextOffset == ${nextOffset}");
//                   categoryProvider.showBottomCategoryProductListLoader();
//
//                   categoryProvider
//                       .getCategoryProductList(context, nextOffset.toString(),
//                           categoryProvider.selectedCategory!.id!.toString())
//                       .then((onValue) {});
//                 }
//               }
//             });
//             return Column(children: [
//               categoryProvider.categoryProductList == null ||
//                       categoryProvider.categoryProductListIsLoading
//                   ? CustomCircularIndicator()
//                   : categoryProvider.categoryProductList!.length == 0
//                       ? Center(
//                           child: Text(
//                             getTranslated('no_any_product_available', context),
//                             style: AppTextStyles.h7(context),
//                           ),
//                         )
//                       : GridView.builder(
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             crossAxisSpacing: 10.w,
//                             mainAxisSpacing: 10.h,
//                             mainAxisExtent: 240.h,
//                           ),
//                           itemCount:
//                               categoryProvider.categoryProductList!.length,
//                           padding: EdgeInsets.zero,
//                           physics: const NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemBuilder: (BuildContext context, int index) =>
//                               ProductWidget(
//                                   product: categoryProvider
//                                       .categoryProductList![index])),
//               if (categoryProvider.bottomCategoryProductListLoading)
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 15.h),
//                   child: CustomCircularIndicator(),
//                 ),
//             ]);
//           },
//         ),
//       ],
//     );
//   }
// }
