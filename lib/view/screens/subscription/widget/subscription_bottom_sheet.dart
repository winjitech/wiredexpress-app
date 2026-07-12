import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/data/model/response/subscription_feature_model.dart';
import 'package:wired_express/data/model/response/subscription_model.dart';
import 'package:wired_express/data/model/response/user_subscription_model.dart';
import 'package:wired_express/data/model/response/userinfo_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/payment_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/subscription_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/Custom_button.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/screens/payment/payment_webview.dart';
import 'package:wired_express/view/screens/payment/update_card_screen.dart';
import 'package:wired_express/view/screens/subscription/subscription_screen.dart';

class SubscriptionBottomSheet extends StatefulWidget {
  final SubscriptionPlanModel plan;

  const SubscriptionBottomSheet({super.key, required this.plan});

  @override
  State<SubscriptionBottomSheet> createState() =>
      _SubscriptionBottomSheetState();
}

class _SubscriptionBottomSheetState extends State<SubscriptionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<SubscriptionProvider, ProfileProvider, PaymentProvider>(
      builder: (context, subscriptionProvider, profileProvider, paymentProvider,
          child) {
        SubscriptionPlanModel plan = widget.plan;
        bool userUseThisPlan = plan.usePlan!;
        List<SubscriptionFeatureModel>? features = plan.features ?? [];
        UserInfoModel user = profileProvider.userInfoModel!;
        bool hasActiveSubscription = user.hasActiveSubscription!;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(35),
              topLeft: Radius.circular(35),
            ),
            color: ColorResources.getScaffoldBackgroundColor(context),
          ),
          padding: EdgeInsets.all(25.r),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: CircleAvatar(
                          radius: 30.r,
                          backgroundColor:
                              ColorResources.getPrimaryColor(context),
                          child: Icon(
                              userUseThisPlan
                                  ? Icons.unsubscribe
                                  : Icons.subscriptions,
                              color: ColorResources.getScaffoldBackgroundColor(
                                  context),
                              size: 40.sp),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      ListView.builder(
                        itemCount: features.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final feature = features[index];

                          return Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.all(15.r),
                            decoration: BoxDecoration(
                              color: ColorResources.getCardColor(context),
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(
                                color: ColorResources.getBorderColor(context),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: ColorResources.getPrimaryColor(context),
                                  size: 22.sp,
                                ),
                                SizedBox(width: 12.w),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        feature.name ?? '',
                                        style: AppTextStyles.h7(
                                          context,
                                          fontSize: 16.sp,
                                        ).copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: ColorResources.getTextColor(context),
                                        ),
                                      ),

                                      SizedBox(height: 4.h),

                                      Text(
                                        feature.description ?? '',
                                        style: AppTextStyles.h7(
                                          context,
                                          fontSize: 13.sp,
                                        ).copyWith(
                                          fontWeight: FontWeight.w400,
                                          height: 1.5,
                                          color: ColorResources.getTextColor(context)
                                              .withOpacity(0.65),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      if (subscriptionProvider.cancelSubscriptionLoading ==
                              true ||
                          subscriptionProvider.subscribeUserLoading == true)
                        const CustomCircularIndicator()
                      else
                        Column(
                          children: [
                            CustomButton(
                              text: getTranslated(
                                  userUseThisPlan
                                      ? 'unsubscribe'
                                      : 'subscribe_now',
                                  context),
                              onTap: () {
                                if (userUseThisPlan) {
                                  if (user.subscriptionWayType == "stripe") {
                                    subscriptionProvider
                                        .stripeCancelSubscription(context)
                                        .then((onValue) {
                                      if (onValue.isSuccess) {
                                        subscriptionProvider
                                            .getSubscriptionPlans(context);
                                        profileProvider.getUserInfo(context);
                                        Navigator.pop(context);
                                      } else {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'something_went_wrong',
                                                context),
                                            context);
                                        Navigator.pop(context);
                                      }
                                    });
                                  } else {
                                    subscriptionProvider
                                        .cancelSubscription(
                                            context,
                                            user.userSubscription!
                                                .paypalSubscriptionId!)
                                        .then((onValue) {
                                      if (onValue.isSuccess) {
                                        subscriptionProvider
                                            .getSubscriptionPlans(context);
                                        profileProvider.getUserInfo(context);
                                        Navigator.pop(context);
                                      } else {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'something_went_wrong',
                                                context),
                                            context);
                                        Navigator.pop(context);
                                      }
                                    });
                                  }
                                } else if (hasActiveSubscription &&
                                    !userUseThisPlan) {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => Dialog(
                                          backgroundColor:
                                              ColorResources.getCardColor(
                                                  context),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.r)),
                                          child: Consumer2<SubscriptionProvider,
                                                  ProfileProvider>(
                                              builder: (context,
                                                  subscriptionProvider,
                                                  profileProvider,
                                                  child) {
                                            return Container(
                                                width: 300,
                                                decoration: BoxDecoration(
                                                    color: ColorResources
                                                        .getCardColor(context),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                          height: 20.h),
                                                      CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            ColorResources
                                                                .getScaffoldBackgroundColor(
                                                                    context),
                                                        child: Icon(Icons.contact_support,
                                                            color: ColorResources
                                                                .getPrimaryColor(
                                                                    context),
                                                            size: 50.sp),
                                                      ),
                                                      Padding(
                                                          padding: EdgeInsets
                                                              .all(Dimensions
                                                                  .PADDING_SIZE_LARGE),
                                                          child: Text(
                                                            getTranslated(
                                                                'you_have_active_subscription',
                                                                context),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: AppTextStyles
                                                                .h7(
                                                              context,
                                                              fontSize: 15.sp,
                                                            ).copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          )),
                                                      Divider(
                                                          height: 0,
                                                          color: ColorResources
                                                              .getHintColor(
                                                                  context)),
                                                      subscriptionProvider
                                                                      .cancelSubscriptionLoading ==
                                                                  true ||
                                                              subscriptionProvider
                                                                      .subscribeUserLoading ==
                                                                  true
                                                          ?  Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(15.r),
                                                              child:
                                                                  CustomCircularIndicator(),
                                                            )
                                                          : Row(children: [
                                                              Expanded(
                                                                  child:
                                                                      GestureDetector(
                                                                onTap: () {
                                                                  if (user.subscriptionWayType ==
                                                                      "stripe") {
                                                                    subscriptionProvider
                                                                        .stripeCancelSubscription(
                                                                            context)
                                                                        .then(
                                                                            (onValue) {
                                                                      if (onValue
                                                                          .isSuccess) {
                                                                        if (paymentProvider
                                                                            .paymentCardList!
                                                                            .isEmpty) {
                                                                          paymentProvider
                                                                              .cardUpdateLink(context)
                                                                              .then((value) {
                                                                            Navigator.push(context,
                                                                                MaterialPageRoute(builder: (_) => UpdateCardScreen()));
                                                                          });
                                                                        } else {
                                                                          Navigator.pop(
                                                                              context);

                                                                          subscriptionProvider
                                                                              .stripeSubscriptionUser(context, plan.id!, paymentProvider.paymentCardList![0].id!)
                                                                              .then((onValue) {
                                                                            if (onValue.isSuccess) {
                                                                              subscriptionProvider.getSubscriptionPlans(context);
                                                                              profileProvider.getUserInfo(context);
                                                                            } else {
                                                                              showCustomSnackBar(getTranslated('something_went_wrong', context), context);
                                                                            }
                                                                          });
                                                                        }
                                                                        // showDialog(
                                                                        //   context:
                                                                        //       context,
                                                                        //   barrierDismissible:
                                                                        //       true,
                                                                        //   builder: (context) =>
                                                                        //       Dialog(
                                                                        //     backgroundColor:
                                                                        //         ColorResources.getCardColor(context),
                                                                        //     shape:
                                                                        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                                                        //     child:
                                                                        //         Container(
                                                                        //       padding:  EdgeInsets.all(20.r),
                                                                        //       decoration: BoxDecoration(
                                                                        //         color: ColorResources.getCardColor(context),
                                                                        //         borderRadius: BorderRadius.circular(12.r),
                                                                        //       ),
                                                                        //       child: Column(
                                                                        //         mainAxisSize: MainAxisSize.min,
                                                                        //         children: [
                                                                        //           Text(
                                                                        //             getTranslated('choose_payment_method', context),
                                                                        //             style: rubikBold.copyWith(fontSize: 18, color: ColorResources.getTextColor(context)),
                                                                        //           ),
                                                                        //           SizedBox(height: 20.h),
                                                                        //           GestureDetector(
                                                                        //             onTap: () {
                                                                        //               Navigator.pop(context);
                                                                        //               UserSubscriptionPlanModel userSub = UserSubscriptionPlanModel(planId: plan.id, paypalPlanId: plan.paypalPlanId, givenName: "${user.fName ?? ''}${user.lName ?? ''}", lastName: user.lName ?? '', email: user.email ?? '', paypalSubscriptionId: '', stripeSubscriptionId: '');
                                                                        //               subscriptionProvider.subscribeUser(context, userSub).then((onValue) {
                                                                        //                 if (onValue.isSuccess) {
                                                                        //                   if (context.mounted) {
                                                                        //                     Navigator.pop(context);
                                                                        //                     Navigator.pop(context);
                                                                        //                   }
                                                                        //
                                                                        //                   subscriptionProvider.getSubscriptionPlans(context);
                                                                        //                   profileProvider.getUserInfo(context);
                                                                        //                   Navigator.push(
                                                                        //                       context,
                                                                        //                       MaterialPageRoute(
                                                                        //                           builder: (BuildContext context) => PaymentWebView(
                                                                        //                                 url: subscriptionProvider.approveUrl!,
                                                                        //                                 fromCheckoutScreen: false,
                                                                        //                               )));
                                                                        //                 } else {
                                                                        //                   if (context.mounted) {
                                                                        //                     Navigator.pop(context);
                                                                        //                   }
                                                                        //
                                                                        //                   showCustomSnackBar(getTranslated('something_went_wrong', context), context);
                                                                        //                 }
                                                                        //               });
                                                                        //             },
                                                                        //             child: Container(
                                                                        //               padding: EdgeInsets.all(10.r),
                                                                        //               decoration: BoxDecoration(color: ColorResources.getPrimaryColor(context), borderRadius: BorderRadius.circular(14)),
                                                                        //               child: Row(
                                                                        //                 crossAxisAlignment: CrossAxisAlignment.center,
                                                                        //                 mainAxisAlignment: MainAxisAlignment.center,
                                                                        //                 children: [
                                                                        //                   Icon(
                                                                        //                     Icons.account_balance_wallet,
                                                                        //                     color: ColorResources.getTextColor(context),
                                                                        //                   ),
                                                                        //                   SizedBox(width: 15.w),
                                                                        //                   Text(
                                                                        //                     getTranslated('pay_with_paypal', context),
                                                                        //                     textAlign: TextAlign.center,
                                                                        //                     style: TextStyle(color: ColorResources.getTextColor(context), fontSize: 15, fontWeight: FontWeight.w500),
                                                                        //                   ),
                                                                        //                 ],
                                                                        //               ),
                                                                        //             ),
                                                                        //           ),
                                                                        //           SizedBox(height: 15.h),
                                                                        //           GestureDetector(
                                                                        //             onTap: () {
                                                                        //               Navigator.pop(context);
                                                                        //               if (paymentProvider.paymentCardList!.isEmpty) {
                                                                        //                 paymentProvider.cardUpdateLink(context).then((value) {
                                                                        //                   Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateCardScreen()));
                                                                        //                 });
                                                                        //               } else {
                                                                        //                 Navigator.pop(context);
                                                                        //                 Navigator.pop(context);
                                                                        //
                                                                        //                 subscriptionProvider.stripeSubscriptionUser(context, plan.id!, paymentProvider.paymentCardList![0].id!).then((onValue) {
                                                                        //                   if (onValue.isSuccess) {
                                                                        //                     subscriptionProvider.getSubscriptionPlans(context);
                                                                        //                     profileProvider.getUserInfo(context);
                                                                        //                   } else {
                                                                        //                     showCustomSnackBar(getTranslated('something_went_wrong', context), context);
                                                                        //                   }
                                                                        //                 });
                                                                        //               }
                                                                        //             },
                                                                        //             child: Container(
                                                                        //               padding: EdgeInsets.all(10.r),
                                                                        //               decoration: BoxDecoration(
                                                                        //                   border: Border.all(
                                                                        //                     color: ColorResources.getPrimaryColor(context),
                                                                        //                   ),
                                                                        //                   borderRadius: BorderRadius.circular(14)),
                                                                        //               child: Row(
                                                                        //                 crossAxisAlignment: CrossAxisAlignment.center,
                                                                        //                 mainAxisAlignment: MainAxisAlignment.center,
                                                                        //                 children: [
                                                                        //                   Icon(Icons.credit_card, color: ColorResources.getPrimaryColor(context)),
                                                                        //                   SizedBox(width: 15.w),
                                                                        //                   Text(getTranslated('pay_with_stripe', context), textAlign: TextAlign.center, style: TextStyle(color: ColorResources.getPrimaryColor(context), fontSize: 15, fontWeight: FontWeight.w500)),
                                                                        //                 ],
                                                                        //               ),
                                                                        //             ),
                                                                        //           ),
                                                                        //         ],
                                                                        //       ),
                                                                        //     ),
                                                                        //   ),
                                                                        // );
                                                                      } else {
                                                                        Navigator.pop(
                                                                            context);

                                                                        showCustomSnackBar(
                                                                            getTranslated('something_went_wrong',
                                                                                context),
                                                                            context);
                                                                      }
                                                                    });
                                                                  } else {
                                                                    subscriptionProvider
                                                                        .cancelSubscription(
                                                                            context,
                                                                            user
                                                                                .userSubscription!.paypalSubscriptionId!)
                                                                        .then(
                                                                            (onValue) {
                                                                      if (onValue
                                                                          .isSuccess) {
                                                                        subscriptionProvider
                                                                            .getSubscriptionPlans(context);
                                                                        profileProvider
                                                                            .getUserInfo(context);
                                                                        Navigator.pop(
                                                                            context);

                                                                        if (paymentProvider
                                                                            .paymentCardList!
                                                                            .isEmpty) {
                                                                          paymentProvider
                                                                              .cardUpdateLink(context)
                                                                              .then((value) {
                                                                            Navigator.push(context,
                                                                                MaterialPageRoute(builder: (_) => UpdateCardScreen()));
                                                                          });
                                                                        } else {
                                                                          subscriptionProvider
                                                                              .stripeSubscriptionUser(context, plan.id!, paymentProvider.paymentCardList![0].id!)
                                                                              .then((onValue) {
                                                                            if (onValue.isSuccess) {
                                                                              subscriptionProvider.getSubscriptionPlans(context);
                                                                              profileProvider.getUserInfo(context);
                                                                            } else {
                                                                              showCustomSnackBar(getTranslated('something_went_wrong', context), context);
                                                                            }
                                                                          });
                                                                        }
                                                                        // showDialog(
                                                                        //   context:
                                                                        //       context,
                                                                        //   barrierDismissible:
                                                                        //       true,
                                                                        //   builder: (context) =>
                                                                        //       Dialog(
                                                                        //     backgroundColor:
                                                                        //         ColorResources.getCardColor(context),
                                                                        //     shape:
                                                                        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                                                                        //     child:
                                                                        //         Container(
                                                                        //       padding:  EdgeInsets.all(20.r),
                                                                        //       decoration: BoxDecoration(
                                                                        //         color: ColorResources.getCardColor(context),
                                                                        //         borderRadius: BorderRadius.circular(12.r),
                                                                        //       ),
                                                                        //       child: Column(
                                                                        //         mainAxisSize: MainAxisSize.min,
                                                                        //         children: [
                                                                        //           Text(
                                                                        //             getTranslated('choose_payment_method', context),
                                                                        //             style: rubikBold.copyWith(fontSize: 18, color: ColorResources.getTextColor(context)),
                                                                        //           ),
                                                                        //           SizedBox(height: 20.h),
                                                                        //           GestureDetector(
                                                                        //             onTap: () {
                                                                        //               Navigator.pop(context);
                                                                        //               UserSubscriptionPlanModel userSub = UserSubscriptionPlanModel(planId: plan.id, paypalPlanId: plan.paypalPlanId, givenName: "${user.fName ?? ''}${user.lName ?? ''}", lastName: user.lName ?? '', email: user.email ?? '', paypalSubscriptionId: '', stripeSubscriptionId: '');
                                                                        //               subscriptionProvider.subscribeUser(context, userSub).then((onValue) {
                                                                        //                 if (onValue.isSuccess) {
                                                                        //                   Navigator.pop(context);
                                                                        //
                                                                        //                   subscriptionProvider.getSubscriptionPlans(context);
                                                                        //                   profileProvider.getUserInfo(context);
                                                                        //                   Navigator.push(
                                                                        //                       context,
                                                                        //                       MaterialPageRoute(
                                                                        //                           builder: (BuildContext context) => PaymentWebView(
                                                                        //                                 url: subscriptionProvider.approveUrl!,
                                                                        //                                 fromCheckoutScreen: false,
                                                                        //                               )));
                                                                        //                 } else {
                                                                        //                   Navigator.pop(context);
                                                                        //
                                                                        //                   showCustomSnackBar(getTranslated('something_went_wrong', context), context);
                                                                        //                 }
                                                                        //               });
                                                                        //             },
                                                                        //             child: Container(
                                                                        //               padding: EdgeInsets.all(10.r),
                                                                        //               decoration: BoxDecoration(color: ColorResources.getPrimaryColor(context), borderRadius: BorderRadius.circular(14)),
                                                                        //               child: Row(
                                                                        //                 crossAxisAlignment: CrossAxisAlignment.center,
                                                                        //                 mainAxisAlignment: MainAxisAlignment.center,
                                                                        //                 children: [
                                                                        //                   Icon(
                                                                        //                     Icons.account_balance_wallet,
                                                                        //                     color: ColorResources.getTextColor(context),
                                                                        //                   ),
                                                                        //                   SizedBox(width: 15.w),
                                                                        //                   Text(
                                                                        //                     getTranslated('pay_with_paypal', context),
                                                                        //                     textAlign: TextAlign.center,
                                                                        //                     style: TextStyle(color: ColorResources.getTextColor(context), fontSize: 15, fontWeight: FontWeight.w500),
                                                                        //                   ),
                                                                        //                 ],
                                                                        //               ),
                                                                        //             ),
                                                                        //           ),
                                                                        //           SizedBox(height: 15.h),
                                                                        //           GestureDetector(
                                                                        //             onTap: () {
                                                                        //               Navigator.pop(context);
                                                                        //               Navigator.pop(context);
                                                                        //
                                                                        //               if (paymentProvider.paymentCardList!.isEmpty) {
                                                                        //                 paymentProvider.cardUpdateLink(context).then((value) {
                                                                        //                   Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateCardScreen()));
                                                                        //                 });
                                                                        //               } else {
                                                                        //                 subscriptionProvider.stripeSubscriptionUser(context, plan.id!, paymentProvider.paymentCardList![0].id!).then((onValue) {
                                                                        //                   if (onValue.isSuccess) {
                                                                        //                     subscriptionProvider.getSubscriptionPlans(context);
                                                                        //                     profileProvider.getUserInfo(context);
                                                                        //                   } else {
                                                                        //                     showCustomSnackBar(getTranslated('something_went_wrong', context), context);
                                                                        //                   }
                                                                        //                 });
                                                                        //               }
                                                                        //             },
                                                                        //             child: Container(
                                                                        //               padding: EdgeInsets.all(10.r),
                                                                        //               decoration: BoxDecoration(
                                                                        //                   border: Border.all(
                                                                        //                     color: ColorResources.getPrimaryColor(context),
                                                                        //                   ),
                                                                        //                   borderRadius: BorderRadius.circular(14)),
                                                                        //               child: Row(
                                                                        //                 crossAxisAlignment: CrossAxisAlignment.center,
                                                                        //                 mainAxisAlignment: MainAxisAlignment.center,
                                                                        //                 children: [
                                                                        //                   Icon(Icons.credit_card, color: ColorResources.getPrimaryColor(context)),
                                                                        //                   SizedBox(width: 15.w),
                                                                        //                   Text(getTranslated('pay_with_stripe', context), textAlign: TextAlign.center, style: TextStyle(color: ColorResources.getPrimaryColor(context), fontSize: 15, fontWeight: FontWeight.w500)),
                                                                        //                 ],
                                                                        //               ),
                                                                        //             ),
                                                                        //           ),
                                                                        //         ],
                                                                        //       ),
                                                                        //     ),
                                                                        //   ),
                                                                        // );
                                                                      } else {
                                                                        Navigator.pop(
                                                                            context);
                                                                        showCustomSnackBar(
                                                                            getTranslated('something_went_wrong',
                                                                                context),
                                                                            context);
                                                                      }
                                                                    });
                                                                  }
                                                                },
                                                                child: Container(
                                                                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                                                    alignment: Alignment.center,
                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                                                                    child: Text(
                                                                      getTranslated(
                                                                          'yes',
                                                                          context),
                                                                      style: AppTextStyles.h7(
                                                                              context)
                                                                          .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    )),
                                                              )),
                                                              Expanded(
                                                                  child:
                                                                      GestureDetector(
                                                                onTap: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child:
                                                                    Container(
                                                                        padding:
                                                                            EdgeInsets.all(Dimensions
                                                                                .PADDING_SIZE_SMALL),
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              ColorResources.getPrimaryColor(context),
                                                                          borderRadius:
                                                                              BorderRadius.only(bottomRight: Radius.circular(10)),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          getTranslated(
                                                                              'no',
                                                                              context),
                                                                          style:
                                                                              AppTextStyles.h7(context).copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                ColorResources.getCardColor(context),
                                                                          ),
                                                                        )),
                                                              )),
                                                            ])
                                                    ]));
                                          })));
                                } else {
                                  if (paymentProvider
                                      .paymentCardList!.isEmpty) {
                                    paymentProvider
                                        .cardUpdateLink(context)
                                        .then((value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  UpdateCardScreen()));
                                    });
                                  } else {
                                    Navigator.pop(context);

                                    subscriptionProvider
                                        .stripeSubscriptionUser(
                                            context,
                                            plan.id!,
                                            paymentProvider
                                                .paymentCardList![0].id!)
                                        .then((onValue) {
                                      if (onValue.isSuccess) {
                                        subscriptionProvider
                                            .getSubscriptionPlans(context);
                                        profileProvider.getUserInfo(context);
                                      } else {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'something_went_wrong',
                                                context),
                                            context);
                                      }
                                    });
                                  }
                                  // showDialog(
                                  //   context: context,
                                  //   barrierDismissible: true,
                                  //   builder: (context) => Dialog(
                                  //     backgroundColor:
                                  //         ColorResources.getCardColor(context),
                                  //     shape: RoundedRectangleBorder(
                                  //         borderRadius:
                                  //             BorderRadius.circular(12.r)),
                                  //     child: Container(
                                  //       padding:  EdgeInsets.all(20.r),
                                  //       decoration: BoxDecoration(
                                  //         color: ColorResources.getCardColor(
                                  //             context),
                                  //         borderRadius:
                                  //             BorderRadius.circular(12.r),
                                  //       ),
                                  //       child: Column(
                                  //         mainAxisSize: MainAxisSize.min,
                                  //         children: [
                                  //           Text(
                                  //             getTranslated(
                                  //                 'choose_payment_method',
                                  //                 context),
                                  //             style: rubikBold.copyWith(
                                  //                 fontSize: 18,
                                  //                 color: ColorResources
                                  //                     .getTextColor(context)),
                                  //           ),
                                  //           SizedBox(height: 20.h),
                                  //           GestureDetector(
                                  //             onTap: () {
                                  //               Navigator.pop(context);
                                  //
                                  //               UserSubscriptionPlanModel
                                  //                   userSub =
                                  //                   UserSubscriptionPlanModel(
                                  //                       planId: plan.id,
                                  //                       paypalPlanId:
                                  //                           plan.paypalPlanId,
                                  //                       givenName:
                                  //                           "${user.fName ?? ''}${user.lName ?? ''}",
                                  //                       lastName:
                                  //                           user.lName ?? '',
                                  //                       email: user.email ?? '',
                                  //                       paypalSubscriptionId:
                                  //                           '',
                                  //                       stripeSubscriptionId:
                                  //                           '');
                                  //
                                  //               subscriptionProvider
                                  //                   .subscribeUser(
                                  //                       context, userSub)
                                  //                   .then((onValue) {
                                  //                 if (onValue.isSuccess) {
                                  //                   subscriptionProvider
                                  //                       .getSubscriptionPlans(
                                  //                           context);
                                  //                   profileProvider
                                  //                       .getUserInfo(context);
                                  //                   Navigator.push(
                                  //                       context,
                                  //                       MaterialPageRoute(
                                  //                           builder: (BuildContext
                                  //                                   context) =>
                                  //                               PaymentWebView(
                                  //                                 url: subscriptionProvider
                                  //                                     .approveUrl!,
                                  //                                 fromCheckoutScreen:
                                  //                                     false,
                                  //                               )));
                                  //                 } else {
                                  //                   Navigator.pop(context);
                                  //
                                  //                   showCustomSnackBar(
                                  //                       getTranslated(
                                  //                           'something_went_wrong',
                                  //                           context),
                                  //                       context);
                                  //                 }
                                  //               });
                                  //             },
                                  //             child: Container(
                                  //               padding: EdgeInsets.all(10.r),
                                  //               decoration: BoxDecoration(
                                  //                   color: ColorResources
                                  //                       .getPrimaryColor(
                                  //                           context),
                                  //                   borderRadius:
                                  //                       BorderRadius.circular(
                                  //                           14)),
                                  //               child: Row(
                                  //                 crossAxisAlignment:
                                  //                     CrossAxisAlignment.center,
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.center,
                                  //                 children: [
                                  //                   Icon(
                                  //                     Icons
                                  //                         .account_balance_wallet,
                                  //                     color: ColorResources
                                  //                         .getTextColor(
                                  //                             context),
                                  //                   ),
                                  //                   SizedBox(width: 15.w),
                                  //                   Text(
                                  //                     getTranslated(
                                  //                         'pay_with_paypal',
                                  //                         context),
                                  //                     textAlign:
                                  //                         TextAlign.center,
                                  //                     style: TextStyle(
                                  //                         color: ColorResources
                                  //                             .getTextColor(
                                  //                                 context),
                                  //                         fontSize: 15,
                                  //                         fontWeight:
                                  //                             FontWeight.w500),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           SizedBox(height: 15.h),
                                  //           GestureDetector(
                                  //             onTap: () {
                                  //               Navigator.pop(context);
                                  //
                                  //               if (paymentProvider
                                  //                   .paymentCardList!.isEmpty) {
                                  //                 paymentProvider
                                  //                     .cardUpdateLink(context)
                                  //                     .then((value) {
                                  //                   Navigator.push(
                                  //                       context,
                                  //                       MaterialPageRoute(
                                  //                           builder: (_) =>
                                  //                               UpdateCardScreen()));
                                  //                 });
                                  //               } else {
                                  //                 Navigator.pop(context);
                                  //
                                  //                 subscriptionProvider
                                  //                     .stripeSubscriptionUser(
                                  //                         context,
                                  //                         plan.id!,
                                  //                         paymentProvider
                                  //                             .paymentCardList![
                                  //                                 0]
                                  //                             .id!)
                                  //                     .then((onValue) {
                                  //                   if (onValue.isSuccess) {
                                  //                     subscriptionProvider
                                  //                         .getSubscriptionPlans(
                                  //                             context);
                                  //                     profileProvider
                                  //                         .getUserInfo(context);
                                  //                   } else {
                                  //                     showCustomSnackBar(
                                  //                         getTranslated(
                                  //                             'something_went_wrong',
                                  //                             context),
                                  //                         context);
                                  //                   }
                                  //                 });
                                  //               }
                                  //             },
                                  //             child: Container(
                                  //               padding: EdgeInsets.all(10.r),
                                  //               decoration: BoxDecoration(
                                  //                   border: Border.all(
                                  //                     color: ColorResources
                                  //                         .getPrimaryColor(
                                  //                             context),
                                  //                   ),
                                  //                   borderRadius:
                                  //                       BorderRadius.circular(
                                  //                           14)),
                                  //               child: Row(
                                  //                 crossAxisAlignment:
                                  //                     CrossAxisAlignment.center,
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.center,
                                  //                 children: [
                                  //                   Icon(Icons.credit_card,
                                  //                       color: ColorResources
                                  //                           .getPrimaryColor(
                                  //                               context)),
                                  //                   SizedBox(width: 15.w),
                                  //                   Text(
                                  //                       getTranslated(
                                  //                           'pay_with_stripe',
                                  //                           context),
                                  //                       textAlign:
                                  //                           TextAlign.center,
                                  //                       style: TextStyle(
                                  //                           color: ColorResources
                                  //                               .getPrimaryColor(
                                  //                                   context),
                                  //                           fontSize: 15,
                                  //                           fontWeight:
                                  //                               FontWeight
                                  //                                   .w500)),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // );
                                }
                              },
                              backgroundColor:
                                  userUseThisPlan ? Colors.red : null,
                            ),
                            CustomButton(
                                text: getTranslated('cancel', context),
                                textColor: ColorResources.getTextColor(context),
                                onTap: () => Navigator.pop(context),
                                backgroundColor: Colors.transparent),
                          ],
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
