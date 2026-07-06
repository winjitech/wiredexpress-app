import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/no_data_found_view.dart';
import 'package:wired_express/view/base/shimmer/product_shimmer.dart';
import 'package:wired_express/view/screens/product/widget/product_widget.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/utill/color_resources.dart';

class ProductByCategoryScreen extends StatefulWidget {
  final CategoryModel category;
  const ProductByCategoryScreen({super.key, required this.category});

  @override
  State<ProductByCategoryScreen> createState() =>
      _ProductByCategoryScreenState();
}

class _ProductByCategoryScreenState extends State<ProductByCategoryScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = Provider.of<CategoryProvider>(context, listen: false);
      prov.clearSelectedSubCat();
      prov.getSubCategories(context, widget.category.id!);
      _fetchProducts(resetOffset: true);
    });
  }

  void _fetchProducts({bool resetOffset = false}) {
    final prov = Provider.of<CategoryProvider>(context, listen: false);
    if (resetOffset) prov.clearProductsOffset();

    prov.getProductsByCategory(context, "1", categoryId: widget.category.id!);
  }

  void _onScroll() {
    final prov = Provider.of<CategoryProvider>(context, listen: false);
    bool isAtBottom =
        _scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent;
    bool canFetchMore =
        (prov.productByCategoryList?.length ?? 0) <
        (prov.totalProductsSize ?? 0);

    if (isAtBottom && !prov.bottomProductByCategoryLoading && canFetchMore) {
      int nextOffset =
          (int.tryParse(prov.productByCategoryOffset ?? "1") ?? 1) + 1;
      prov.showBottomProductsLoader();
      prov.getProductsByCategory(
        context,
        nextOffset.toString(),
        categoryId: widget.category.id!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CategoryProvider, ProfileProvider>(
      builder: (context, prov, profile, child) {
        List<ProductModel> products = prov.productByCategoryList ?? [];
        bool isLoading = prov.productByCategoryIsLoading;
        CategoryModel category = widget.category;
        List<CategoryModel> subCat = prov.subCategoriesList ?? [];

        return Scaffold(
          backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
          body: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification.metrics.pixels ==
                      scrollNotification.metrics.maxScrollExtent &&
                  products.length < (prov.totalProductsSize ?? 0)) {
                _onScroll();
              }
              return false;
            },
            child: Column(
              children: [
                SafeArea(
                  bottom: false,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      children: [
                          IconButton(
                            onPressed:   (){Navigator.pop(context);},
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 18.sp,
                              color:ColorResources.getTextColor(context),
                            ),
                          ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Text(category.name??"",
                            style: AppTextStyles.h3(context).copyWith(
                              color: ColorResources.getTextColor(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (subCat.isNotEmpty)
                  Container(
                    height: 45.h,
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: subCat.length + 1,
                      itemBuilder: (context, index) {
                        bool isAll = index == 0;

                        int? id = isAll ? null : subCat[index - 1].id;
                        String title = isAll
                            ? getTranslated('all', context)
                            : (subCat[index - 1].name ?? '');

                        bool isSelected = isAll
                            ? prov.selectedSubCat == null
                            : prov.selectedSubCat?.id == id;
                        return GestureDetector(
                          onTap: () {
                            if (isAll) {
                              prov.clearSelectedSubCat();
                            } else {
                              prov.setSelectedSubCat(subCat[index - 1]);
                            }
                            prov.clearProductsOffset();
                            prov.getProductsByCategory(
                              context,
                              "1",
                              categoryId: widget.category.id!,
                              subcategoryId: id,
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10.w),
                            padding: EdgeInsets.symmetric(
                              horizontal: 18.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? ColorResources.getPrimaryColor(context)
                                  : ColorResources.getCardColor(context),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Center(
                              child: Text(
                                title,
                                style: AppTextStyles.h6(context).copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : ColorResources.getTextColor(
                                          context,
                                        ).withOpacity(0.8),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                Expanded(
                  child: isLoading
                      ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w , vertical: 10.h),
                        child: ProductShimmer(),
                      )
                      : products.isEmpty
                      ? const Center(
                          child: NoDataFoundView(
                            text: 'no_any_product_yet',
                            showIcon: false,
                          ),
                        )
                      : SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 25.w , vertical: 10.h),
                                shrinkWrap: true,
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  ProductModel product =
                                      prov.productByCategoryList![index];
                                  return Column(
                                    children: [
                                      ProductWidget(product: product),
                                      SizedBox(height: 15.h),
                                    ],
                                  );
                                },
                              ),
                              if (prov.bottomProductByCategoryLoading)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 25.w , vertical: 10.h),
                                  child: ProductShimmer(),
                                )
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
