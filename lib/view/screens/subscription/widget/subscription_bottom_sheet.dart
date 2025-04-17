import 'dart:async';

import 'package:wired_express/data/model/response/subscription_feature_model.dart';
import 'package:wired_express/data/model/response/subscription_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
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

class SubscriptionBottomSheet extends StatefulWidget {
  final SubscriptionModel subscription;

  const SubscriptionBottomSheet({super.key, required this.subscription});

  @override
  State<SubscriptionBottomSheet> createState() =>
      _SubscriptionBottomSheetState();
}

class _SubscriptionBottomSheetState extends State<SubscriptionBottomSheet> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 0), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SubscriptionProvider, ProfileProvider>(
      builder: (context, subscriptionProvider, profileProvider, child) {
        SubscriptionModel subscription = widget.subscription;
        bool userUseThisPlan = subscription.usePlan!;
        List<SubscriptionFeatureModel>? features = subscription.features ?? [];
        bool hasActiveSubscription =
            profileProvider.userInfoModel!.hasActiveSubscription!;

        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(35),
              topLeft: Radius.circular(35),
            ),
            color: ColorResources.getScaffoldBackgroundColor(context),
          ),
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              ColorResources.getPrimaryColor(context),
                          child: Icon(
                              userUseThisPlan
                                  ? Icons.unsubscribe
                                  : Icons.subscriptions,
                              color: ColorResources.getScaffoldBackgroundColor(
                                  context),
                              size: 40),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                        itemCount: features.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          SubscriptionFeatureModel feature = features[index];
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            feature.name ?? "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color:
                                                  ColorResources.getTextColor(
                                                      context),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            feature.description ?? '',
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              color:
                                                  ColorResources.getTextColor(
                                                          context)
                                                      .withOpacity(0.6),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          );
                        },
                      ),

                      if (subscriptionProvider.cancelSubscriptionLoading ==
                              true ||
                          subscriptionProvider.subscribeUserLoading == true)
                        CustomCircularIndicator()
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
                                  subscriptionProvider
                                      .cancelSubscription(
                                          context, subscription.id!)
                                      .then((onValue) {
                                    if (onValue.isSuccess) {
                                      subscriptionProvider
                                          .getSubscriptionPlans(context);
                                      profileProvider.getUserInfo(context);
                                      Navigator.pop(context);
                                    } else {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'something_went_wrong', context),
                                          context);
                                      Navigator.pop(context);
                                    }
                                  });
                                } else if(hasActiveSubscription && !userUseThisPlan){   showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => Dialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      child:     Consumer2<SubscriptionProvider, ProfileProvider>(
    builder: (context, subscriptionProvider, profileProvider, child) {return  Container(
                                          width: 300,
                                          decoration: BoxDecoration(
                                              color: ColorResources.getScaffoldColor(context!),
                                              borderRadius: BorderRadius.circular(10)),
                                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                                            SizedBox(height: 20),
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.white,
                                              child: Icon(Icons.contact_support,
                                                  color: ColorResources.getScaffoldColor(context), size: 50),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                                              child: Text(getTranslated('you_have_active_subscription', context),
                                                  style: TextStyle(
                                                      color: Colors.white54,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 15),
                                                  textAlign: TextAlign.center),
                                            ),
                                            Divider(height: 0, color: ColorResources.getHintColor(context)),

                                            subscriptionProvider.cancelSubscriptionLoading == true ||
                                                subscriptionProvider.subscribeUserLoading == true

                                                ?Padding(
                                                  padding: const EdgeInsets.all(15),
                                                  child: CustomCircularIndicator(),
                                                ):

                                            Row(children: [
                                              Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      subscriptionProvider
                                                          .subscribeUser(context,
                                                          subscription.id!)
                                                          .then((onValue) {
                                                        if (onValue.isSuccess) {
                                                          subscriptionProvider
                                                              .getSubscriptionPlans(
                                                              context);
                                                          profileProvider
                                                              .getUserInfo(context);
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);

                                                        } else {
                                                          showCustomSnackBar(
                                                              getTranslated(
                                                                  'something_went_wrong',
                                                                  context),
                                                              context);
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);

                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                              bottomLeft: Radius.circular(10))),
                                                      child: Text(getTranslated('yes', context),
                                                          style: rubikBold.copyWith(color: Colors.white)),
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: GestureDetector(
                                                    onTap: () => Navigator.pop(context),
                                                    child: Container(
                                                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.only(
                                                            bottomRight: Radius.circular(10)),
                                                      ),
                                                      child: Text(getTranslated('no', context),
                                                          style: rubikBold.copyWith(
                                                              color: ColorResources.getScaffoldColor(context))),
                                                    ),
                                                  )),
                                            ])

                                          ])
                                      );})
                                    ));

                                }else {
                                  subscriptionProvider
                                      .subscribeUser(
                                      context, subscription.id!)
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
