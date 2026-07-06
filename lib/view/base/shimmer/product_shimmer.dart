import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wired_express/utill/color_resources.dart';

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final bool dark = ColorResources.isDark(context);

        return Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Shimmer(
                duration: const Duration(seconds: 2),
                interval: const Duration(milliseconds: 300),
                color: ColorResources.getShimmerHighlightColor(context),
                colorOpacity: 1,
                enabled: true,
                direction: const ShimmerDirection.fromLTRB(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 18.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorResources.getCardColor(context),
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: ColorResources.getBoxShadow(
                          context,
                        ).withOpacity(dark ? 0.35 : 0.12),
                        blurRadius: 10.r,
                        spreadRadius: 1.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          color: ColorResources.getShimmerColor(context),
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.45,
                              height: 12.h,
                              decoration: BoxDecoration(
                                color: ColorResources.getShimmerColor(context),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.30,
                              height: 10.h,
                              decoration: BoxDecoration(
                                color: ColorResources.getShimmerColor(context),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.20,
                              height: 10.h,
                              decoration: BoxDecoration(
                                color: ColorResources.getShimmerColor(context),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        );
      },
    );
  }
}
