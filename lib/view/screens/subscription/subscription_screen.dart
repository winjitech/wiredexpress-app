import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/subscription_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/screens/subscription/widget/subscription_bottom_sheet.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: 'subscriptions', isBackButtonExist: true),
            Expanded(
              child: Consumer2<SubscriptionProvider, SplashProvider>(
                builder:
                    (context, subscriptionProvider, splashProvider, child) {
                  if (subscriptionProvider.subscriptionPlanListLoading! ||
                      subscriptionProvider.subscriptionPlanList == null) {
                    return const CustomCircularIndicator();
                  }
                  if (subscriptionProvider.subscriptionPlanList!.isEmpty) {
                    return Center(
                      child: Text(
                        getTranslated('no_any_plan_available', context),
                        style: TextStyle(
                            color: ColorResources.getTextColor(context)),
                      ),
                    );
                  }
                  String currency =
                      splashProvider.configModel!.currencySymbol ?? '\$';

                  return Scrollbar(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(15),
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
                                    onTap: () => showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          SubscriptionBottomSheet(plan: plan),
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      barrierColor: Colors.black54,
                                      isDismissible: true,
                                      useSafeArea: true,
                                      enableDrag: false,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: userUseThisPlan
                                            ? Colors.transparent
                                            : ColorResources
                                                .getTextFieldFillColor(context),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: userUseThisPlan
                                              ? ColorResources.getPrimaryColor(
                                                  context)
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  plan.name ?? "",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: userUseThisPlan
                                                        ? ColorResources
                                                            .getPrimaryColor(
                                                                context)
                                                        : ColorResources
                                                            .getTextColor(
                                                                context),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "$currency${Helpers.formatTextWithNum(plan.price ?? "0.0")}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: ColorResources
                                                            .getPrimaryColor(
                                                                context),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadiusDirectional
                                                          .circular(10),
                                                  color: !userUseThisPlan
                                                      ? ColorResources
                                                              .getPrimaryColor(
                                                                  context)
                                                          .withOpacity(0.1)
                                                      : Colors.red
                                                          .withOpacity(0.1)),
                                              child: Text(
                                                getTranslated(
                                                    !userUseThisPlan
                                                        ? 'subscribe'
                                                        : 'unsubscribe',
                                                    context),
                                                style: TextStyle(
                                                    color: !userUseThisPlan
                                                        ? ColorResources
                                                            .getPrimaryColor(
                                                                context)
                                                        : Colors.red,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
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
      ),
    );
  }
}
