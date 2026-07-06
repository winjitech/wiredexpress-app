import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/helper/helpers.dart';

import 'package:wired_express/data/model/response/coupon_model.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/coupon_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/no_data_found_view.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CouponProvider>().getCouponList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      body: Column(
        children: [
          CustomAppBar(title: 'coupons', showBackButton: true),
          Expanded(
            child: Consumer2<CouponProvider, SplashProvider>(
              builder: (context, couponProvider, splashProvider, _) {
                String currency =
                    splashProvider.configModel!.currencySymbol ?? '\$';

                List<CouponModel>? coupons = couponProvider.couponList;

                if (coupons == null || couponProvider.couponListLoading!) {
                  return CustomCircularIndicator();
                }

                if (coupons.isEmpty) {
                  return const NoDataFoundView(
                    text: 'no_any_coupons_yet',
                    showIcon: false,
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<CouponProvider>().getCouponList(context);
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount: coupons.length,
                    itemBuilder: (context, index) {
                      final coupon = coupons[index];

                      if (coupon.visibility != 1) {
                        return SizedBox.shrink();
                      }

                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18.r),
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: coupon.code ?? ''));
                            showCustomSnackBar(
                                getTranslated('coupon_code_copied', context),
                                context,
                                isError: false);
                          },
                          child: Stack(
                            children: [
                              /// Main Ticket
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                  color:
                                      ColorResources.getPrimaryColor(context),
                                  borderRadius: BorderRadius.circular(18.r),
                                ),
                                child: Row(
                                  children: [
                                    /// percent icon
                                    Icon(
                                      Icons.percent_rounded,
                                      size: 34.sp,
                                      color: Colors.white.withOpacity(.6),
                                    ),

                                    SizedBox(width: 18.w),

                                    /// dashed line
                                    const DashedLine(),

                                    SizedBox(width: 18.w),

                                    /// text section
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            coupon.code ?? '-',
                                            style: AppTextStyles.h6(context)
                                                .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            coupon.discountType == 'percent'
                                                ? '${coupon.discount}% ${getTranslated('off', context)}'
                                                : '${currency}${Helpers.formatTextWithNum(coupon.discount!.toString())} ${getTranslated('off', context)}',
                                            style: AppTextStyles.h4(context)
                                                .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            DateConverter
                                                .convertToDesiredFormat(
                                              context,
                                              coupon.expireDate!,
                                            ),
                                            style: AppTextStyles.h8(context)
                                                .copyWith(
                                              color:
                                                  Colors.white.withOpacity(.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    /// copy icon
                                    Icon(
                                      Icons.copy_rounded,
                                      size: 22.sp,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  ],
                                ),
                              ),

                              /// left cut
                              Positioned(
                                left: -12.w,
                                top: 0,
                                bottom: 0,
                                child: const TicketCut(),
                              ),

                              /// right cut
                              Positioned(
                                right: -12.w,
                                top: 0,
                                bottom: 0,
                                child: const TicketCut(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DashedLine extends StatelessWidget {
  const DashedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          9,
          (index) => Container(
            width: 2.w,
            height: 6.h,
            color: ColorResources.getBorderColor(context),
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
/// TICKET CUT
///////////////////////////////////////////////////////////////////////////////

class TicketCut extends StatelessWidget {
  const TicketCut({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        color: ColorResources.getScaffoldBackgroundColor(context),
        shape: BoxShape.circle,
      ),
    );
  }
}
