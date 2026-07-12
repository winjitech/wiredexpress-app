import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/config_model.dart';
import 'package:wired_express/data/model/response/order_installment_model.dart';
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

class AwaitingDownPaymentScreen extends StatefulWidget {
  const AwaitingDownPaymentScreen({super.key});

  @override
  State<AwaitingDownPaymentScreen> createState() =>
      _AwaitingDownPaymentScreenState();
}

class _AwaitingDownPaymentScreenState extends State<AwaitingDownPaymentScreen> {
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
      prov.getAwaitingDownPaymentOrderList(context);
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
                if (prov.awaitingDownPaymentOrderListLoading) {
                  return CustomCircularIndicator();
                }
                if (prov.awaitingDownPaymentOrderList.isEmpty) {
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

                List<OrderModel> pendingPayments =
                    prov.awaitingDownPaymentOrderList;

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
                            OrderModel order = pendingPayments[index];
                            OrderInstallmentModel installment =
                                order.installment!;
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
                                  /// Order Number
                                  Text(
                                    "${getTranslated('order', context)} #${order.id}",
                                    style: AppTextStyles.h4(context),
                                  ),

                                  SizedBox(height: 10.h),

                                  /// Message
                                  Container(
                                    padding: EdgeInsets.all(12.r),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(.08),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: Colors.orange,
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Text(
                                            getTranslated(
                                              'your_installment_request_has_been_approved_please_pay_the_down_payment_to_continue',
                                              context,
                                            ),
                                            style: AppTextStyles.h6(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 10.h),

                                  _buildRow(
                                      context,
                                      getTranslated('order_total', context),
                                      "$currency${Helpers.formatTextWithNum(
                                        installment.orderAmount.toString(),
                                      )}"),

                                  _buildRow(
                                      context,
                                      getTranslated('down_payment', context),
                                      "$currency${Helpers.formatTextWithNum(
                                        installment.downPayment.toString(),
                                      )}"),

                                  _buildRow(
                                    context,
                                    getTranslated(
                                        'installment_period', context),
                                    "${installment.months} ${getTranslated('months', context)}",
                                  ),

                                  if (installment.firstInstallmentDate != null)
                                    _buildRow(
                                      context,
                                      getTranslated(
                                          'first_installment', context),
                                      DateConverter.convertToDesiredFormat(
                                        context,
                                        installment.firstInstallmentDate!,
                                      ),
                                    ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          text: getTranslated(
                                              'pay_down_payment', context),
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
                                                    CustomCircularIndicator(),);
                                              prov.payPendingDownPayment(
                                                      context: context,
                                                      orderId: order.id!,
                                                      amount: installment
                                                          .downPayment!,
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
                                                  prov.getAwaitingDownPaymentOrderList(
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
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Expanded(
                                        child: CustomButton(
                                          borderColor:
                                              ColorResources.getPrimaryColor(
                                                  context),
                                          backgroundColor: Colors.transparent,
                                          textColor:
                                              ColorResources.getPrimaryColor(
                                                  context),
                                          text:
                                              getTranslated('details', context),
                                          onTap: () =>
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          OrderDetailsScreen(
                                                              orderModel: order,
                                                              orderId:
                                                                  order.id))),
                                        ),
                                      ),
                                    ],
                                  )
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
