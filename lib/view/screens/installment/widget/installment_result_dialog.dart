import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/installment_calculation_result.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_button.dart';

class InstallmentResultDialog extends StatelessWidget {
  const InstallmentResultDialog({super.key});

  @override
  Widget build(BuildContext context) {
    OrderProvider provider = Provider.of<OrderProvider>(context);
    InstallmentCalculationResultModel result = provider.installmentResult!;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(22.r),
        decoration: BoxDecoration(
          color: ColorResources.getCardColor(context),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: ColorResources.getBoxShadow(context).withOpacity(.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              height: 65.r,
              width: 65.r,
              decoration: BoxDecoration(
                color: ColorResources.getPrimaryColor(context).withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calculate_rounded,
                color: ColorResources.getPrimaryColor(context),
                size: 32.sp,
              ),
            ),

            SizedBox(height: 18.h),

            Text(
              getTranslated('installment_summary', context),
              style: AppTextStyles.h2(context),
            ),

            SizedBox(height: 6.h),

            Text(
              getTranslated(
                  'here_is_your_estimated_payment_breakdown', context),
              textAlign: TextAlign.center,
              style: AppTextStyles.h7(context).copyWith(
                color:
                ColorResources.getTextColor(context).withOpacity(.65),
              ),
            ),

            SizedBox(height: 24.h),

            _buildItem(
              context,
              getTranslated('project_amount', context),
              result.amount.toString(),isPrice: true
            ),

            _buildItem(
              context,
              getTranslated('down_payment', context),
              result.downPayment.toString(),isPrice: true
            ),

            _buildItem(
              context,
              getTranslated('remaining_balance', context),
              result.financedAmount.toString(),isPrice: true
            ),

            _buildItem(
              context,
              getTranslated('interest_rate', context),
              "${result.interestRate.toString()}%",
            ),

            _buildItem(
              context,
              getTranslated('financing_term', context),
              "${result.months}",isMonth:true
            ),

            Divider(
              height: 30.h,
              color: ColorResources.getBorderColor(context),
            ),

            _buildItem(
              context,
              getTranslated('total_amount', context),
              result.totalAmount.toString(),
              isBold: true,
            ),

            SizedBox(height: 18.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 18.w,
                vertical: 18.h,
              ),
              decoration: BoxDecoration(
                color: ColorResources.getPrimaryColor(context)
                    .withOpacity(.08),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Column(
                children: [

                  Text(
                    getTranslated('monthly_payment', context),
                    style: AppTextStyles.h6(context),
                  ),

                  SizedBox(height: 10.h),

                  Text(
                    Helpers.formatTextWithNum(result.monthlyPayment.toString()),
                    style: AppTextStyles.h1(
                      context,
                      fontSize: 30.sp,
                    ).copyWith(
                      color:
                      ColorResources.getPrimaryColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    "/ ${getTranslated('month', context)}",
                    style: AppTextStyles.h7(context).copyWith(
                      color: ColorResources.getTextColor(context)
                          .withOpacity(.6),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            CustomButton(
              text: getTranslated('done', context),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
      BuildContext context,
      String title,
      String value, {
        bool isBold = false,bool isPrice = false, bool isMonth = false
      }) { SplashProvider splashProvider = Provider.of<SplashProvider>(context);
  String currency =
      splashProvider.configModel!.currencySymbol ?? '\$';
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [

          Expanded(
            child: Text(
              title,
              style: AppTextStyles.h6(context).copyWith(
                color: ColorResources.getTextColor(context)
                    .withOpacity(.75),
              ),
            ),
          ),

          Text(isMonth? '${Helpers.formatTextWithNum(value)} ${getTranslated('month/s', context)}':isPrice?'$currency${Helpers.formatTextWithNum(value)}':
          Helpers.formatTextWithNum(value)   ,
            style: (isBold
                ? AppTextStyles.h4(context)
                : AppTextStyles.h5(context))
                .copyWith(
              fontWeight:
              isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}