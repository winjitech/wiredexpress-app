import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/config_model.dart';
import 'package:wired_express/data/model/response/installment_plan_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/Custom_button.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/screens/installment/widget/installment_result_dialog.dart';

class InstallmentCalculatorScreen extends StatefulWidget {
  @override
  State<InstallmentCalculatorScreen> createState() =>
      _InstallmentCalculatorScreenState();
}

class _InstallmentCalculatorScreenState
    extends State<InstallmentCalculatorScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _downPaymentController = TextEditingController();

  final FocusNode _amountFocus = FocusNode();
  final FocusNode _downPaymentFocus = FocusNode();
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 0), () async {
      final prov = Provider.of<OrderProvider>(context, listen: false);
      prov.clearSelectedInstallmentPlan();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      body: Column(
        children: [
          CustomAppBar(title: 'installment_calculator', showBackButton: true),
          Expanded(
            child: Consumer2<OrderProvider , SplashProvider>(
              builder: (context, prov,splash , _) {
                ConfigModel config = splash.configModel!;
                List<InstallmentPlanModel> installmentPlans = config.installmentPlans!;
                bool isDark = Provider.of<ThemeProvider>(context, listen: false).darkTheme;

                return Scrollbar(
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(25.r),
                        physics: BouncingScrollPhysics(),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated('installment_calculator', context),
                              style: AppTextStyles.h2(context),
                            ),
                            SizedBox(height: 4.h),

                            Text(
                              getTranslated(
                                'calculate_your_monthly_installment_before_applying_for_financing',
                                context,
                              ),
                              style: AppTextStyles.h6(context).copyWith(
                                color: ColorResources.getTextColor(context).withOpacity(0.7),
                              ),
                            ),


                            SizedBox(height: 30.h),

                            Text(
                              getTranslated('amount_to_finance', context),
                              style: AppTextStyles.h5(context),
                            ),
                            SizedBox(height: 10.h),

                            CustomTextField(
                              controller: _amountController,
                              focusNode: _amountFocus,
                              nextFocus: _downPaymentFocus,radius: 15,
                              inputType: const TextInputType.numberWithOptions(decimal: true),
                              inputAction: TextInputAction.next,
                              hintText: getTranslated('enter_amount_to_finance', context),
                              fill: true,fillColor: ColorResources.getTextFieldFillColor(context),
                            ),

                            SizedBox(height: 20.h),

                            Text(
                              getTranslated('down_payment', context),
                              style: AppTextStyles.h5(context),
                            ),
                            SizedBox(height: 10.h),

                            CustomTextField(
                              controller: _downPaymentController,
                              focusNode: _downPaymentFocus,radius: 15,
                              inputType: const TextInputType.numberWithOptions(decimal: true),
                              inputAction: TextInputAction.done,
                              hintText: getTranslated('enter_down_payment', context),
                              fill: true,fillColor: ColorResources.getTextFieldFillColor(context),
                            ),


                            SizedBox(height: 20.h),
                            Text(
                              getTranslated('payment_period', context),
                              style: AppTextStyles.h5(context),
                            ),
                            SizedBox(height: 10.h),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                  color: ColorResources.getCardColor(context),
                                  borderRadius: BorderRadius.circular(15.r)),
                              child: Row(
                                children: [
                                  SizedBox(width: 15.w),
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<InstallmentPlanModel>(
                                        isExpanded: true,
                                        value: prov.selectedInstallmentPlan,
                                        dropdownColor: ColorResources.getCardColor(context),
                                        borderRadius: BorderRadius.circular(15.r),
                                        hint: Text(getTranslated('select_period', context,),
                                          style: AppTextStyles.h6(context).copyWith(
                                            color: Color(isDark ? 0xBFFFFFFF : 0xFF8391A1,),),),
                                        onChanged: (InstallmentPlanModel? newValue) {
                                          if (newValue != null) {
                                            prov.setSelectedInstallmentPlan(newValue);
                                          }
                                        },
                                        items: installmentPlans.map((plan) {
                                          return DropdownMenuItem<InstallmentPlanModel>(
                                            value: plan,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text('${plan.months!} ${getTranslated('month/s', context)}',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: AppTextStyles.h6(context),
                                                  ),
                                                ),
                                                if (prov.selectedInstallmentPlan?.months == plan.months)
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 10.w,
                                                    ),
                                                    child: Icon(
                                                      Icons.check_circle_sharp,
                                                      color:
                                                      ColorResources.getPrimaryColor(
                                                        context,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          );
                                        }).toList(),

                                        selectedItemBuilder:
                                            (BuildContext context) {
                                          return installmentPlans.map<Widget>((
                                              InstallmentPlanModel model,
                                              ) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: Text('${model.months!} ${getTranslated('month/s', context)}',
                                                    maxLines: 1,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: AppTextStyles.h6(
                                                      context,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h,),
                            prov.calculatingInstallmentLoading?CustomCircularIndicator():CustomButton(text: getTranslated('calculate', context) ,
                            onTap: () async {
                              if(_amountController.text.isEmpty){
                                showCustomSnackBar(getTranslated('enter_amount_to_finance', context), context);
                              }else if(_downPaymentController.text.isEmpty){
                                showCustomSnackBar(getTranslated('enter_down_payment', context), context);
                              }else if(prov.selectedInstallmentPlan == null){
                                showCustomSnackBar(getTranslated('select_plan', context), context);
                              }else{
                                await prov.calculateInstallment(
                                  amount: double.parse(_amountController.text),
                                  downPayment: double.parse(_downPaymentController.text),
                                );

                                showDialog(
                                  context: context,
                                  builder: (_) => InstallmentResultDialog(),
                                );
                              }
                            },),
                            SizedBox(height: 20.h,),

                          ],
                        )));
              },
            ),
          ),
        ],
      ),
    );
  }

}
