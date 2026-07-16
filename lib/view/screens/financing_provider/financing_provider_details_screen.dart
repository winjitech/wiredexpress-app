import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/config_model.dart';
import 'package:wired_express/data/model/response/financing_provider_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/payment_provider.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';

class FinancingProviderDetailsScreen extends StatefulWidget {
  final FinancingProviderModel provider;
  const FinancingProviderDetailsScreen({super.key, required this.provider});

  @override
  State<FinancingProviderDetailsScreen> createState() =>
      _FinancingProviderDetailsScreenState();
}

class _FinancingProviderDetailsScreenState
    extends State<FinancingProviderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18.sp,
                      color: ColorResources.getTextColor(context),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      widget.provider.name ?? "",
                      style: AppTextStyles.h3(context).copyWith(
                        color: ColorResources.getTextColor(context),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer2<PlaceOrderProvider, PaymentProvider>(
              builder: (context, prov, paymentProv, child) {
                final splashProvider =
                    Provider.of<SplashProvider>(context, listen: false);

                ConfigModel config = splashProvider.configModel!;
                List<FinancingProviderModel> financingProviders =
                    config.financingProviders!;
                String logoUrl =
                    splashProvider.configModel!.baseUrls!.financingImageUrl!;

                return Scrollbar(
                  child: SingleChildScrollView(
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Logo
                          Center(
                            child: Image.network(
                              "$logoUrl/${widget.provider.logoPath}",
                              height: 70.h,
                              fit: BoxFit.contain,
                            ),
                          ),

                          SizedBox(height: 18.h),

                          /// Description
                          Center(
                            child: Text(
                              widget.provider.detailedDescription ??
                                  widget.provider.shortDescription ??
                                  "",
                              textAlign: TextAlign.center,
                              style: AppTextStyles.h6(context).copyWith(
                                color: ColorResources.getHintColor(context),
                                height: 1.5,
                              ),
                            ),
                          ),

                          SizedBox(height: 25.h),

                          _benefitsCard(),

                          SizedBox(height: 20.h),

                          _stepsSection(),

                          SizedBox(height: 30.h),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Helpers.launchURL(widget.provider.websiteUrl!);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    ColorResources.getPrimaryColor(context),
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              icon: const Icon(
                                Icons.open_in_new,
                                color: Colors.white,
                              ),
                              label: Text(
                                "${getTranslated("apply_with", context)} ${widget.provider.name}",
                                style: AppTextStyles.h6(context).copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 12.h),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color:
                                      ColorResources.getPrimaryColor(context),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                getTranslated("back_to_providers", context),
                                style: AppTextStyles.h6(context).copyWith(
                                  color: ColorResources.getPrimaryColor(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _benefitsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: ColorResources.getCardColor(context),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: ColorResources.getBorderColor(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated("benefits", context),
            style: AppTextStyles.h4(context),
          ),
          SizedBox(height: 15.h),
          ...widget.provider.benefits!.map(
            (benefit) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: ColorResources.getPrimaryColor(context),
                    size: 20.sp,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      benefit,
                      style: AppTextStyles.h6(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getTranslated("how_it_works", context),
          style: AppTextStyles.h4(context),
        ),
        SizedBox(height: 20.h),
        ...widget.provider.steps!.map(
          (step) => Padding(
            padding: EdgeInsets.only(bottom: 22.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    color: ColorResources.getPrimaryColor(context),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${step.stepNumber}",
                    style: AppTextStyles.h6(context).copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title ?? "",
                        style: AppTextStyles.h5(context).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        step.description ?? "",
                        style: AppTextStyles.h7(context).copyWith(
                          color: ColorResources.getHintColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
