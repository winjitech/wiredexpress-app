import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/not_logged_in_screen.dart';
import 'package:wired_express/view/base/shimmer/category_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';
import 'package:wired_express/view/screens/contractor_request/add_contractor_request_screen.dart';
import 'package:wired_express/view/screens/product/product_by_category_screen.dart';

class CategoriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer4<ProfileProvider, SplashProvider, OrderProvider,
        CategoryProvider>(
      builder: (
        context,
        profileProv,
        splashProv,
        orderProv,
        catProv,
        child,
      ) {

        bool isLoggedIn = Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;

        String imgBaseUrl = splashProv.baseUrls?.categoryImageUrl ?? '';
        bool isLoading = catProv.allCategoriesListLoading! ||
            catProv.allCategoriesList == null;
        List<CategoryModel> categories = catProv.allCategoriesList ?? [];
        return Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    getTranslated('quick_access', context),
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
            if (isLoading) ...[CategoryShimmer()],
            if (!isLoading && categories.isNotEmpty) ...[
              SizedBox(
                height: 145.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => SizedBox(width: 5.w),
                  itemBuilder: (context, index) {
                    CategoryModel category = categories[index];
                    bool isContractorZone = category.name == 'contractor_zone';

                    return GestureDetector(
                      onTap: () {
                        if (isContractorZone) {
                          if (!isLoggedIn) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LoginScreen(),
                              ),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddContractorRequestScreen(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductByCategoryScreen(category: category),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 120.w,
                        padding: EdgeInsets.all(15.r),
                        decoration: BoxDecoration(
                          color: ColorResources.getCardColor(context),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!isContractorZone)
                              CachedNetworkImage(
                                width: 60.w,
                                height: 60.h,
                                fit: BoxFit.contain,
                                imageUrl: '$imgBaseUrl/${category.image}',
                              ),
                            if (isContractorZone)
                              SizedBox(
                                width: 60.w,
                                height: 60.h,
                                child: Icon(
                                  Icons.construction,
                                  color: ColorResources.getTextColor(context),
                                  size: 35.sp,
                                ),
                              ),
                            SizedBox(height: 6.h),
                            Text(
                              isContractorZone
                                  ? getTranslated(category.name!, context)
                                  : category.name ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.h6(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
