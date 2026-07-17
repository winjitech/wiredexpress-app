import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/config_model.dart';
import 'package:wired_express/data/model/response/financing_provider_model.dart';
import 'package:wired_express/data/model/response/installment_plan_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/coupon_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/screens/financing_provider/financing_providers_screen.dart';
class SelectInstallmentView extends StatelessWidget{
  final double totalOrderPrice;

  SelectInstallmentView({super.key, required this.totalOrderPrice});
  @override
  Widget build(BuildContext context) {


  return Consumer6<ProfileProvider, CartProvider, SplashProvider,
        CustomAuthProvider, CouponProvider, OrderProvider>(
        builder: (context, profileProvider, cartProvider,
            splash, authProvider, couponProvider, orderProv , child) {

          ConfigModel config = splash.configModel!;
          List<InstallmentPlanModel> installmentPlans = config.installmentPlans!;
          List<FinancingProviderModel> financingProviders = config.financingProviders!;
          bool isDark = Provider.of<ThemeProvider>(context, listen: false).darkTheme;
          String currency = config.currencySymbol ?? '\$';
          return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SwitchListTile(
        //     inactiveThumbColor: ColorResources.getTextColor(context),
        //     inactiveTrackColor: ColorResources.getTextFieldFillColor(context),
        //     activeColor: ColorResources.getPrimaryColor(context).withOpacity(1),
        //     contentPadding: EdgeInsets.zero,
        //     value: orderProv.useInstallment,
        //     onChanged: (value) {orderProv.setUseInstallment(value);},
        //     title: Text(getTranslated('pay_in_installments', context),
        //         style: AppTextStyles.h5(context))),
        // if(orderProv.useInstallment)...[
        //   Text(
        //     getTranslated('down_payment', context),
        //     style: AppTextStyles.h5(context),
        //   ),
        //   SizedBox(height: 10.h),
        //
        //   CustomTextField(
        //     controller: orderProv.downPaymentController,
        //     focusNode: orderProv.downPaymentFocus,radius: 15,
        //     inputType: const TextInputType.numberWithOptions(decimal: true),
        //     inputAction: TextInputAction.done,
        //     hintText: getTranslated('enter_down_payment', context),
        //     fill: true,fillColor: ColorResources.getTextFieldFillColor(context),
        //     onChanged: (value) {
        //       orderProv.validateInstallment(orderAmount: totalOrderPrice, downPaymentText: value);
        //       if (orderProv.selectedInstallmentPlan != null && orderProv.installmentError == null) {
        //         orderProv.calculateInstallment(amount: totalOrderPrice, downPayment: double.parse(value));
        //       }
        //     },
        //   ),
        //
        //   SizedBox(height: 20.h),
        //   Text(
        //     getTranslated('financing_term', context),
        //     style: AppTextStyles.h5(context),
        //   ),
        //   SizedBox(height: 10.h),
        //
        //   Container(
        //     padding: EdgeInsets.symmetric(horizontal: 25.w),
        //     decoration: BoxDecoration(
        //         color: ColorResources.getCardColor(context),
        //         borderRadius: BorderRadius.circular(15.r)),
        //     child: Row(
        //       children: [
        //         Expanded(
        //           child: DropdownButtonHideUnderline(
        //             child: DropdownButton<InstallmentPlanModel>(
        //               isExpanded: true,
        //               value: orderProv.selectedInstallmentPlan,
        //               dropdownColor: ColorResources.getCardColor(context),
        //               borderRadius: BorderRadius.circular(15.r),
        //               hint: Text(getTranslated('select_financing_term', context,),
        //                 style: AppTextStyles.h6(context).copyWith(
        //                   color: Color(isDark ? 0xBFFFFFFF : 0xFF8391A1,),),),
        //               onChanged: (InstallmentPlanModel? newValue) {
        //                 if (newValue != null) {
        //                   orderProv.setSelectedInstallmentPlan(newValue);
        //                   orderProv.calculateInstallment(
        //                     amount: totalOrderPrice,
        //                     downPayment: double.tryParse(orderProv.downPaymentController.text) ?? 0,
        //                   );
        //                 }
        //               },
        //
        //               items: installmentPlans.map((plan) {
        //                 return DropdownMenuItem<InstallmentPlanModel>(
        //                   value: plan,
        //                   child: Row(
        //                     children: [
        //                       Expanded(
        //                         child: Text('${plan.months!} ${getTranslated('month/s', context)}',
        //                           maxLines: 1,
        //                           overflow: TextOverflow.ellipsis,
        //                           style: AppTextStyles.h6(context),
        //                         ),
        //                       ),
        //                       if (orderProv.selectedInstallmentPlan?.months == plan.months)
        //                         Padding(
        //                           padding: EdgeInsets.only(
        //                             left: 10.w,
        //                           ),
        //                           child: Icon(
        //                             Icons.check_circle_sharp,
        //                             color:
        //                             ColorResources.getPrimaryColor(
        //                               context,
        //                             ),
        //                           ),
        //                         ),
        //                     ],
        //                   ),
        //                 );
        //               }).toList(),
        //
        //               selectedItemBuilder:
        //                   (BuildContext context) {
        //                 return installmentPlans.map<Widget>((
        //                     InstallmentPlanModel model,
        //                     ) => Row(
        //                     children: [
        //                       Expanded(
        //                         child: Text('${model.months!} ${getTranslated('month/s', context)}',
        //                           maxLines: 1,
        //                           overflow:
        //                           TextOverflow.ellipsis,
        //                           style: AppTextStyles.h6(
        //                             context,
        //                           ),
        //                         ),
        //                       ),
        //                     ],
        //                   )).toList();
        //               },
        //             ),
        //           ),
        //         ),
        //
        //
        //
        //       ],
        //     ),
        //   ),
        //   SizedBox(height: 10.h,),
        //   if(orderProv.monthlyPayment>0)...[
        //     Center(
        //       child: orderProv.calculatingInstallmentLoading
        //           ? SizedBox(
        //         width: 20.w,
        //         height: 20.w,
        //         child: CustomCircularIndicator(),
        //       )
        //           : Text(
        //         "${getTranslated('estimated_monthly_payment', context)}: "
        //             "$currency ${Helpers.formatTextWithNum(orderProv.monthlyPayment.toString())} "
        //             "/ ${orderProv.selectedInstallmentPlan?.months ?? 0} ${getTranslated('month/s', context)}",
        //         textAlign: TextAlign.center,
        //         style: AppTextStyles.h5(context).copyWith(
        //           color: ColorResources.getPrimaryColor(context),
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //     ),
        //     SizedBox(height: 15.h,),
        //   ],
        //
        // ],
        
        SizedBox(height: 15.h,),
        InkWell(
          borderRadius: BorderRadius.circular(15.r),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FinancingProvidersScreen()));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: ColorResources.getPrimaryColor(context),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    getTranslated('view_financial_options', context),
                    style: AppTextStyles.h5(context).copyWith(
                      color: ColorResources.getPrimaryColor(context),fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: ColorResources.getPrimaryColor(context),
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15.h,),



      ],
    );});
  }
}