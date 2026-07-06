import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wired_express/utill/color_resources.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = ColorResources.isDark(context);

    return SizedBox(
      height: 145.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              interval: const Duration(milliseconds: 300),
              enabled: true,
              direction: const ShimmerDirection.fromLTRB(),
              color: ColorResources.getShimmerHighlightColor(context),
              colorOpacity: 1,
              child: Container(
                width: 115.w,
                padding: EdgeInsets.all(15.r),
                decoration: BoxDecoration(
                  color: ColorResources.getCardColor(context),
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: dark
                          ? Colors.black.withOpacity(.18)
                          : Colors.black.withOpacity(.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: ColorResources.getShimmerColor(context),
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Container(
                      width: 72.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: ColorResources.getShimmerColor(context),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}