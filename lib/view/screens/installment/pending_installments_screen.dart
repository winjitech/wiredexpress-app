import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/config_model.dart';
import 'package:wired_express/data/model/response/installment_payment_model.dart';
import 'package:wired_express/data/model/response/order_model.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/payment_provider.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/Custom_button.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:wired_express/view/screens/order/order_details_screen.dart';
import 'package:wired_express/view/screens/payment/update_card_screen.dart';

class PendingInstallmentsScreen extends StatefulWidget {
  const PendingInstallmentsScreen({super.key});

  @override
  State<PendingInstallmentsScreen> createState() =>
      _PendingInstallmentsScreenState();
}

class _PendingInstallmentsScreenState extends State<PendingInstallmentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prov = Provider.of<PlaceOrderProvider>(context, listen: false);
      final profile = Provider.of<ProfileProvider>(context, listen: false);
      final paymentProv = Provider.of<PaymentProvider>(
        context,
        listen: false,
      );
      prov.getPendingInstallmentPayments(context);
      paymentProv.getPaymentCardList(
        context,
        profile.userInfoModel!.id!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      body: Column(
        children: [
          CustomAppBar(title: 'pending_payments', showBackButton: true),
          Expanded(
            child: Consumer2<PlaceOrderProvider, PaymentProvider>(
              builder: (context, prov, paymentProv, child) {
                final splashProvider =
                    Provider.of<SplashProvider>(context, listen: false);

                ConfigModel config = splashProvider.configModel!;
                String currency = config.currencySymbol ?? '\$';
                if (prov.pendingInstallmentPaymentsLoading) {
                  return CustomCircularIndicator();
                }
                if (prov.pendingInstallmentPayments.isEmpty) {
                  Future.microtask(() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DashboardScreen(pageIndex: 0),
                      ),
                    );
                  });
                  return SizedBox.shrink();
                }

                List<InstallmentPaymentModel> pendingPayments =
                    prov.pendingInstallmentPayments;

                return Scrollbar(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      children: [
                        if (paymentProv.paymentCardList != null &&
                            paymentProv.paymentCardList!.isEmpty) ...[
                          Container(
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              color: ColorResources.getCardColor(context),
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(
                                color: ColorResources.getBorderColor(context),
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15.r),
                              onTap: () =>
                                  paymentProv.cardUpdateLink(context).then(
                                        (value) => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => UpdateCardScreen(),
                                          ),
                                        ),
                                      ),
                              child: Container(
                                padding: EdgeInsets.all(15.r),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: ColorResources.getPrimaryColor(
                                      context,
                                    ).withOpacity(0.4),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_card,
                                      color: ColorResources.getPrimaryColor(
                                        context,
                                      ),
                                      size: 22.sp,
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      getTranslated(
                                        'add_payment_details',
                                        context,
                                      ),
                                      style: AppTextStyles.h5(context).copyWith(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: ColorResources.getPrimaryColor(
                                          context,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                        ],
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: pendingPayments.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            InstallmentPaymentModel payment =
                                pendingPayments[index];
                            OrderModel order = payment.order!;
                            return Container(
                              padding: EdgeInsets.all(15.r),
                              margin: EdgeInsets.only(bottom: 15.h),
                              decoration: BoxDecoration(
                                color: ColorResources.getCardColor(context),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${getTranslated('order', context)} #${payment.orderId}",
                                        style: AppTextStyles.h4(context),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(.12),
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        child: Text(
                                          "${getTranslated('installment', context)} ${payment.installmentNumber}",
                                          style: AppTextStyles.h6(context)
                                              .copyWith(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  Container(
                                    padding: EdgeInsets.all(12.r),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(.08),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.payments_outlined,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Text(
                                            getTranslated(
                                              "your_installment_payment_is_ready_please_complete_the_payment_before_the_due_date",
                                              context,
                                            ),
                                            style: AppTextStyles.h6(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  _buildRow(
                                    context,
                                    getTranslated(
                                        'installment_amount', context),
                                    "$currency${Helpers.formatTextWithNum(payment.amount.toString())}",
                                  ),
                                  _buildRow(
                                    context,
                                    getTranslated('remaining_balance', context),
                                    "$currency${Helpers.formatTextWithNum(payment.remainingBalance.toString())}",
                                  ),
                                  if (payment.dueDate != null)
                                    _buildRow(
                                      context,
                                      getTranslated('due_date', context),
                                      DateConverter.convertToDesiredFormat(
                                        context,
                                        payment.dueDate!,
                                      ),
                                    ),
                                  if (payment.requestedAt != null)
                                    _buildRow(
                                      context,
                                      getTranslated('requested_at', context),
                                      DateConverter.convertToDesiredFormat(
                                        context,
                                        payment.requestedAt!,
                                      ),
                                    ),
                                  if ((payment.adminNote ?? "").isNotEmpty) ...[
                                    SizedBox(height: 12.h),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(12.r),
                                      decoration: BoxDecoration(
                                        color:
                                            ColorResources.getHintColor(context)
                                                .withOpacity(.08),
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTranslated(
                                                'admin_note', context),
                                            style: AppTextStyles.h6(context)
                                                .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            payment.adminNote!,
                                            style: AppTextStyles.h6(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: 15.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          text: getTranslated(
                                            "pay_now",
                                            context,
                                          ),
                                          onTap: () {
                                            if (paymentProv
                                                .paymentCardList!.isEmpty) {
                                              showCustomSnackBar(
                                                getTranslated(
                                                  'please_add_payment_details',
                                                  context,
                                                ),
                                                context,
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) =>
                                                    CustomCircularIndicator(),
                                              );
                                              prov
                                                  .payPendingInstallment(
                                                      context: context,
                                                      installmentPaymentId:
                                                          payment.id!,
                                                      cardId: paymentProv
                                                          .paymentCardList![0]
                                                          .id!)
                                                  .then((onValue) {
                                                if (onValue.isSuccess) {
                                                  showCustomSnackBar(
                                                      getTranslated(
                                                        'payment_successful',
                                                        context,
                                                      ),
                                                      context,
                                                      isError: false);
                                                  prov.getPendingInstallmentPayments(
                                                      context,
                                                      isLoading: false);
                                                  Navigator.pop(context);
                                                } else {}
                                              }).catchError((e) {
                                                Navigator.pop(context);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: CustomButton(
                                          backgroundColor: Colors.transparent,
                                          borderColor:
                                              ColorResources.getPrimaryColor(
                                                  context),
                                          textColor:
                                              ColorResources.getPrimaryColor(
                                                  context),
                                          text: getTranslated(
                                            "details",
                                            context,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    OrderDetailsScreen(
                                                  orderModel: order!,
                                                  orderId: order.id,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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

  Widget _buildRow(
    BuildContext context,
    String title,
    String value,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.h6(context),
          ),
          Text(
            value,
            style: AppTextStyles.h6(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
