import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/search_provider.dart';
import 'package:wired_express/utill/Images.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/no_data_found_view.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/base/shimmer/product_shimmer.dart';
import 'package:wired_express/view/screens/product/widget/product_widget.dart';

class SearchResultScreen extends StatelessWidget {
  final String searchString;
  SearchResultScreen({required this.searchString});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    int atamp = 0;
    if (atamp == 0) {
      searchController.text = searchString!;
      atamp = 1;
    }

    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Consumer<SearchProvider>(
              builder: (context, searchProvider, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(15.r),
                      decoration: BoxDecoration(
                          color: ColorResources.getCardColor(context),
                          borderRadius: BorderRadius.circular(15.r)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$searchString',
                              textAlign: TextAlign.start,
                              style: AppTextStyles.h7(
                                context,
                                fontSize: 13.sp,
                              ).copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Image.asset(
                              Images.search,
                              height: 20.w,
                              width: 20),
                          SizedBox(width: 10.w),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  searchProvider.searchProductList != null
                      ? Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${searchProvider.searchProductList!.length} ${getTranslated('product_found', context)}',
                                style: AppTextStyles.h4(context).copyWith(
                                  fontWeight: FontWeight.w400,
                                  color:
                                      ColorResources.getGreyBunkerColor(context)
                                          .withOpacity(0.2),
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: 15.h),
                  Expanded(
                    child: searchProvider.searchProductList != null
                        ? searchProvider.searchProductList!.length > 0
                            ? Scrollbar(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.zero,
                                  physics: const BouncingScrollPhysics(),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(10.r),
                                      child: ListView.builder(
                                        itemCount: searchProvider
                                            .searchProductList!.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) =>
                                            ProductWidget(
                                                product: searchProvider
                                                    .searchProductList![index]),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : NoDataFoundView(
                                text: 'no_any_product_yet', showIcon: false)
                        : ProductShimmer(),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
