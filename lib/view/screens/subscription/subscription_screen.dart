import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/subscription_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/payment_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/screens/subscription/subscription_details_screen.dart';
import 'package:wired_express/view/screens/subscription/widget/subscription_bottom_sheet.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 0), () async {
      Provider.of<SubscriptionProvider>(context, listen: false)
          .getSubscriptionPlans(context);
      Provider.of<PaymentProvider>(context, listen: false).getPaymentCardList(
          context,
          Provider.of<ProfileProvider>(context, listen: false)
              .userInfoModel!
              .id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      body: Column(
        children: [
          CustomAppBar(title: 'subscriptions', showBackButton: true),
          Expanded(
            child: Consumer2<SubscriptionProvider, SplashProvider>(
              builder:
                  (context, subscriptionProvider, splashProvider, child) {
                if (subscriptionProvider.subscriptionPlanListLoading! ||
                    subscriptionProvider.subscriptionPlanList == null ||
                    subscriptionProvider.subscribeUserLoading) {
                  return const CustomCircularIndicator();
                }
                if (subscriptionProvider.subscriptionPlanList!.isEmpty) {
                  return Center(
                    child: Text(
                      getTranslated('no_any_plan_available', context),
                      style: AppTextStyles.h7(context),
                    ),
                  );
                }
                String currency =
                    splashProvider.configModel!.currencySymbol ?? '\$';

                return Scrollbar(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(15.r),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          itemCount: subscriptionProvider
                              .subscriptionPlanList!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            SubscriptionPlanModel plan = subscriptionProvider
                                .subscriptionPlanList![index];
                            bool userUseThisPlan = plan.usePlan!;

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (BuildContext context) =>
                                    //             SubscriptionDetailsScreen(
                                    //                 plan: plan)));
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            SubscriptionBottomSheet(
                                                plan: plan),
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        barrierColor: Colors.black54,
                                        isDismissible: true,
                                        useSafeArea: true,
                                        enableDrag: false);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(15.r),
                                    decoration: BoxDecoration(
                                      color: userUseThisPlan
                                          ? Colors.transparent
                                          : ColorResources
                                              .getTextFieldFillColor(context),
                                      borderRadius: BorderRadius.circular(15.r),
                                      border: Border.all(
                                          color: userUseThisPlan
                                              ? ColorResources
                                                  .getPrimaryColor(context)
                                              : Colors.transparent,
                                          width: 2),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                plan.name ?? "",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTextStyles.h5(context).copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: userUseThisPlan
                                                      ? ColorResources.getPrimaryColor(context)
                                                      : ColorResources.getTextColor(context),
                                                ),
                                              ),
                                              SizedBox(height: 2.h),
                                              Row(
                                                children: [
                                                  Text(
                                                    "$currency${Helpers.formatTextWithNum(plan.price ?? "0.0")}",
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: AppTextStyles.h7(
                                                      context,
                                                      fontSize: 15.sp,
                                                    ).copyWith(
                                                      fontWeight: FontWeight.w600,
                                                      color: ColorResources.getPrimaryColor(context),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadiusDirectional.circular(10.r),
                                            color: !userUseThisPlan
                                                ? ColorResources.getPrimaryColor(context).withOpacity(0.1)
                                                : Colors.red.withOpacity(0.1),
                                          ),
                                          child: Text(
                                            getTranslated(!userUseThisPlan ? 'subscribe' : 'unsubscribe', context),
                                            style: AppTextStyles.h7(
                                              context,
                                              fontSize: 15.sp,
                                            ).copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: !userUseThisPlan ? ColorResources.getPrimaryColor(context) : Colors.red,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.h),
                              ],
                            );
                          },
                        )
                      ],
                    ),
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
