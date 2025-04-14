import 'package:flutter/material.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/product_widget.dart';
import 'package:provider/provider.dart';

class CategoryProductView extends StatelessWidget {
  final ScrollController? scrollController;
  CategoryProductView({this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            scrollController?.addListener(() {
              if (scrollController!.position.pixels ==
                      scrollController!.position.maxScrollExtent &&
                  categoryProvider.categoryProductList != null &&
                  !categoryProvider.categoryProductListIsLoading) {
                if (categoryProvider.categoryProductList!.length <
                    categoryProvider.totalCategoryProductListSize!) {
                  int nextOffset = (int.tryParse(
                              categoryProvider.categoryProductListOffset ??
                                  "1") ??
                          1) +
                      1;
                  print("nextOffset == ${nextOffset}");
                  categoryProvider.showBottomCategoryProductListLoader();

                  categoryProvider
                      .getCategoryProductList(context, nextOffset.toString(),
                          categoryProvider.selectedCategory!.id!.toString())
                      .then((onValue) {});
                }
              }
            });
            return Column(children: [
              categoryProvider.categoryProductList == null ||
                      categoryProvider.categoryProductListIsLoading
                  ? CustomCircularIndicator()
                  : categoryProvider.categoryProductList!.length == 0
                      ? Center(
                          child: Text(
                            getTranslated('no_any_product_available', context),
                            style: TextStyle(
                                color: ColorResources.getTextColor(context)),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 240,
                            crossAxisCount:
                                ResponsiveHelper.isTab(context) ? 3 : 2,
                          ),
                          itemCount:
                              categoryProvider.categoryProductList!.length,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) =>
                              ProductWidget(
                                  product: categoryProvider
                                      .categoryProductList![index])),
              if (categoryProvider.bottomCategoryProductListLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: CustomCircularIndicator(),
                ),
            ]);
          },
        ),
      ],
    );
  }
}
