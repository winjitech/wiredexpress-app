import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/payment_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/screens/payment/update_card_screen.dart';
import 'package:wired_express/view/screens/payment/widget/remove_card_bottom_sheet.dart';

class PaymentDetailsScreen extends StatefulWidget {
  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    Timer(Duration(seconds: 0), () async {
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
      key: _scaffoldKey,
      body: Column(
        children: [
          CustomAppBar(title: 'payment_details', showBackButton: true),
          Expanded(
            child: Consumer4<OrderProvider, CartProvider, ProfileProvider,
                PaymentProvider>(
              builder: (context, orderProvider, cartProvider, profileProvider,
                  paymentProvider, child) {
                return Consumer<LocationProvider>(
                  builder: (context, address, child) {
                    return Column(
                      children: [
                        Expanded(
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(25.r),
                              physics: BouncingScrollPhysics(),
                              child: Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        paymentProvider.loading! ||
                                                paymentProvider.paymentCardList ==
                                                    null
                                            ? const Center(
                                                child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: CustomCircularIndicator()),
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    getTranslated(
                                                        'payment_info', context),
                                                    style: AppTextStyles.h4(context),
                                                  ),
                                                  SizedBox(height: 20.h),
                                                  paymentProvider
                                                          .paymentCardList!.isEmpty
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            paymentProvider
                                                                .cardUpdateLink(
                                                                    context)
                                                                .then((value) {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          UpdateCardScreen()));
                                                            });
                                                          },
                                                          child: Container(
                                                            width:
                                                                MediaQuery.of(context)
                                                                        .size
                                                                        .width *
                                                                    0.35,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(10.r),
                                                              border: Border.all(
                                                                color: ColorResources
                                                                        .getTextColor(
                                                                            context)
                                                                    .withOpacity(0.5),
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(
                                                                  10.0),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    getTranslated(
                                                                        'add_card_info',
                                                                        context),
                                                                    style: AppTextStyles
                                                                        .h7(context),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 5),
                                                                  Icon(Icons.add,
                                                                      color: ColorResources
                                                                              .getTextColor(
                                                                                  context)
                                                                          .withOpacity(
                                                                              0.5)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  paymentProvider
                                                          .paymentCardList!.isEmpty
                                                      ? SizedBox()
                                                      : Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      left: 16.w,
                                                                      right: 16.w,
                                                                      top: 16,
                                                                      bottom: 8),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                    10.r),
                                                                        border: Border
                                                                            .all(
                                                                          color: ColorResources.getTextColor(
                                                                                  context)
                                                                              .withOpacity(
                                                                                  0.5),
                                                                        ),
                                                                      ),
                                                                      child: Padding(
                                                                        padding:
                                                                            EdgeInsets
                                                                                .all(
                                                                                    14),
                                                                        child: Row(
                                                                          children: [
                                                                            Icon(
                                                                                Icons
                                                                                    .credit_card,
                                                                                color:
                                                                                    ColorResources.getTextColor(context)),
                                                                            SizedBox(
                                                                                width:
                                                                                    30),
                                                                            Text(
                                                                              '**** **** **** ${paymentProvider.paymentCardList![0].last4}',
                                                                              style: AppTextStyles.h7(
                                                                                  context),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () =>
                                                                            showModalBottomSheet(
                                                                          context:
                                                                              context,
                                                                          builder: (BuildContext
                                                                                  context) =>
                                                                              RemoveCardBottomSheet(
                                                                                  cardId:
                                                                                      paymentProvider.paymentCardList![0].id!),
                                                                          backgroundColor:
                                                                              Colors
                                                                                  .transparent,
                                                                          isScrollControlled:
                                                                              true,
                                                                          barrierColor:
                                                                              Colors
                                                                                  .black54,
                                                                          isDismissible:
                                                                              true,
                                                                          useSafeArea:
                                                                              true,
                                                                        ),
                                                                        child:
                                                                            const Padding(
                                                                          padding:
                                                                              EdgeInsets
                                                                                  .all(5),
                                                                          child: Icon(
                                                                              Icons
                                                                                  .delete,
                                                                              color: Colors
                                                                                  .red),
                                                                        ),
                                                                      ),
                                                                      paymentProvider
                                                                              .loading!
                                                                          ? SizedBox(
                                                                              height:
                                                                                  20,
                                                                              width:
                                                                                  20,
                                                                              child: CustomCircularIndicator(
                                                                                  color:
                                                                                      Colors.white),
                                                                            )
                                                                          : GestureDetector(
                                                                              onTap: () => paymentProvider
                                                                                  .cardUpdateLink(context)
                                                                                  .then((value) {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(builder: (_) => UpdateCardScreen()));
                                                                              }),
                                                                              child:
                                                                                  Padding(
                                                                                padding:
                                                                                    EdgeInsets.all(5),
                                                                                child: Icon(
                                                                                    Icons.edit,
                                                                                    color: ColorResources.getTextColor(context).withOpacity(0.5)),
                                                                              ),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                ],
                                              )
                                      ]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
