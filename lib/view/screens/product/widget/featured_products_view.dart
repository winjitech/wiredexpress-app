import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/no_data_found_view.dart';
import 'package:wired_express/view/screens/product/widget/product_widget.dart';
import 'package:wired_express/view/base/shimmer/product_shimmer.dart';

class FeaturedProductsView extends StatelessWidget {
  const FeaturedProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                getTranslated('featured_products', context),
                style: AppTextStyles.h2(context).copyWith(
                  color: ColorResources.getTextColor(context),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        Consumer<ProductProvider>(
          builder: (context, productProv, child) {
            List<ProductModel> featuredProducts =
                productProv.featuredProductsList ?? [];

            if (productProv.featuredProductsIsLoading) {
              return  ProductShimmer();
            }

            if (featuredProducts.isEmpty) {
              return const Center(
                child: NoDataFoundView(
                  text: 'no_any_product_yet',
                  showIcon: false,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: featuredProducts.length,
                  itemBuilder: (context, index) {
                    ProductModel product = featuredProducts[index];
                    return Column(
                      children: [
                        ProductWidget(product: product),
                        SizedBox(height: 10.h),
                      ],
                    );
                  },
                ),

                if (productProv.bottomFeaturedProductsLoading)
                  ProductShimmer(),
              ],
            );
          },
        ),
      ],
    );
  }
}