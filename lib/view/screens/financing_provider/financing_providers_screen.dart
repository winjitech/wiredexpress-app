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
import 'package:wired_express/view/screens/financing_provider/financing_provider_details_screen.dart';

class FinancingProvidersScreen extends StatefulWidget {
  const FinancingProvidersScreen({super.key});

  @override
  State<FinancingProvidersScreen> createState() =>
      _FinancingProvidersScreenState();
}

class _FinancingProvidersScreenState extends State<FinancingProvidersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      body: Column(
        children: [
          CustomAppBar(title: 'financing_providers', showBackButton: true),
          Expanded(
            child: Consumer2<PlaceOrderProvider, PaymentProvider>(
              builder: (context, prov, paymentProv, child) {
                final splashProvider =
                Provider.of<SplashProvider>(context, listen: false);

                ConfigModel config = splashProvider.configModel!;
                List<FinancingProviderModel> financingProviders = config.financingProviders!;
                String logoUrl = splashProvider.configModel!.baseUrls!.financingImageUrl!;

                return Scrollbar(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.r),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          getTranslated('choose_financing_provider', context),
                          style: AppTextStyles.h2(context).copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 6.h),

                        Text(
                          getTranslated(
                            'apply_directly_with_selected_provider',
                            context,
                          ),
                          style: AppTextStyles.h7(context).copyWith(
                            color: ColorResources.getHintColor(context),
                          ),
                        ),

                        SizedBox(height: 15.h),
                          ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: financingProviders.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            FinancingProviderModel provider = financingProviders[index];

                            return Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              padding: EdgeInsets.all(16.r),
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

                                  /// Logo + Popular Badge
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Image.network(
                                        "$logoUrl/${provider.logoPath}",
                                        height: 38.h,
                                        fit: BoxFit.contain,
                                      ),

                                      if (provider.badge != null && provider.badge!.isNotEmpty)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: ColorResources.getPrimaryColor(context),
                                            borderRadius: BorderRadius.circular(30.r),
                                          ),
                                          child: Text(
                                            provider.badge!,
                                            style: AppTextStyles.h9(context).copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),

                                  SizedBox(height: 15.h),

                                  Text(
                                    provider.shortDescription ?? "",
                                    style: AppTextStyles.h7(context).copyWith(
                                      color: ColorResources.getHintColor(context),
                                      height: 1.4,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FinancingProviderDetailsScreen(provider:provider))),
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: ColorResources.getBorderColor(context),
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 13.h),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.r),
                                            ),
                                          ),
                                          child: Text(
                                            getTranslated('learn_more', context),
                                            style: AppTextStyles.h6(context),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 10.w),

                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () =>
                                              Helpers.launchURL(provider.websiteUrl!),
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:
                                            ColorResources.getPrimaryColor(context),
                                            padding: EdgeInsets.symmetric(vertical: 13.h),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.r),
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.open_in_new,
                                            color: Colors.white,
                                            size: 18.sp,
                                          ),
                                          label: Text(
                                            getTranslated('apply_now', context),
                                            style: AppTextStyles.h6(context).copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 15.h),

                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(14.r),
                          decoration: BoxDecoration(
                            color: ColorResources.getPrimaryColor(context)
                                .withOpacity(.08),
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: ColorResources.getPrimaryColor(context),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: ColorResources.getPrimaryColor(context),
                                size: 22.sp,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  getTranslated(
                                    'financing_provider_disclaimer',
                                    context,
                                  ),
                                  style: AppTextStyles.h7(context).copyWith(
                                    color: ColorResources.getTextColor(context).withOpacity(0.8),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    );
  }

}
