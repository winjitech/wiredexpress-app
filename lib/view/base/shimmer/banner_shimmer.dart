import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wired_express/utill/color_resources.dart';

class BannerShimmer extends StatelessWidget {
  BannerShimmer({super.key});

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final bool dark = ColorResources.isDark(context);

    return CarouselSlider.builder(
      carouselController: _carouselController,
      itemCount: 5,
      options: CarouselOptions(
        height: 175.h,
        viewportFraction: 0.95,
        enlargeCenterPage: true,
        autoPlay: false,
      ),
      itemBuilder: (context, index, realIndex) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              interval: const Duration(milliseconds: 300),
              enabled: true,
              color: ColorResources.getShimmerHighlightColor(context),
              colorOpacity: 1,
              direction: const ShimmerDirection.fromLTRB(),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorResources.getShimmerColor(context),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: ColorResources.getBoxShadow(
                        context,
                      ).withOpacity(dark ? 0.35 : 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
