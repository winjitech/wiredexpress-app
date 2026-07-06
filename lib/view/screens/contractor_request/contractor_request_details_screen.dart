import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/contractor_request_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/contractor_request_model.dart';
import 'package:wired_express/view/base/Custom_button.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/screens/contractor_request/widget/cancel_contractor_request_dialog.dart';

class ContractorRequestDetailsScreen extends StatelessWidget {
  final ContractorRequestModel req;

  const ContractorRequestDetailsScreen({super.key, required this.req});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
        body: Consumer3<ContractorRequestProvider, CustomAuthProvider,
            SplashProvider>(
          builder: (context, reqProvider, authProvider, splash, child) {
            String attachmentUrl =
                splash.configModel!.baseUrls!.contractorRequestAttachmentsUrl!;
            double imageWidth = MediaQuery.of(context).size.width - 25;
            double imageHeight = imageWidth * 9 / 16;
            Color statusColor = Helpers.statusColor(
              context,
              req.status!,
            )!;
            return Column(
              children: [
                CustomAppBar(title: 'contractor_zone', showBackButton: true),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        getTranslated(
                                            req.type == 'quote'
                                                ? 'request_quote'
                                                : req.type!,
                                            context),
                                        style:
                                            AppTextStyles.h4(context).copyWith(
                                          color: ColorResources.getTextColor(
                                              context),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        color: statusColor.withOpacity(
                                          0.2,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 4.h,
                                      ),
                                      child: Text(
                                        getTranslated(
                                          req.status!,
                                          context,
                                        ),
                                        style:
                                            AppTextStyles.h6(context).copyWith(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 15.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        getTranslated('create_at', context),
                                        style:
                                            AppTextStyles.h6(context).copyWith(
                                          color: ColorResources.getTextColor(
                                                  context)
                                              .withOpacity(0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text(
                                      DateConverter
                                          .convertIsoStringToDayMonthFormat(
                                        context,
                                        req.createdAt!,
                                      ),
                                      style: AppTextStyles.h6(context).copyWith(
                                        color: ColorResources.getTextColor(
                                            context),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h),

                                Text(
                                  getTranslated('message', context),
                                  style: AppTextStyles.h4(context),
                                ),
                                SizedBox(height: 8.h),

                                Container(
                                  padding: EdgeInsets.all(15.r),
                                  decoration: BoxDecoration(
                                    color: ColorResources.getCardColor(context),
                                    borderRadius: BorderRadius.circular(15.r),
                                    border: Border.all(
                                      color: ColorResources.getBorderColor(
                                          context),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          req.messageOrItems ?? "",
                                          style: AppTextStyles.h6(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 20.h),

                                /// Attachment
                                if (req.attachment != null &&
                                    req.attachment!.isNotEmpty) ...[
                                  Text(
                                    getTranslated('attachment', context),
                                    style: AppTextStyles.h4(context),
                                  ),
                                  SizedBox(height: 10.h),
                                  if (req.attachment!
                                      .toLowerCase()
                                      .endsWith('.pdf'))
                                    GestureDetector(
                                      onTap: () async {
                                        String fullUrl =
                                            "$attachmentUrl/${req.attachment!}";
                                        await Helpers.downloadPdf(
                                          req.attachment!,
                                          fullUrl,
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(25.r),
                                        decoration: BoxDecoration(
                                          color: ColorResources.getCardColor(
                                              context),
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          border: Border.all(
                                            color:
                                                ColorResources.getBorderColor(
                                                    context),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.picture_as_pdf,
                                              size: 55.sp,
                                              color: Colors.red,
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              req.attachment!,
                                              textAlign: TextAlign.center,
                                              style: AppTextStyles.h6(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (!req.attachment!
                                      .toLowerCase()
                                      .endsWith('.pdf'))
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => Dialog(
                                            backgroundColor: Colors.transparent,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "$attachmentUrl/${req.attachment}",
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "$attachmentUrl/${req.attachment}",
                                          width: double.infinity,
                                          height: 220.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                ],

                                SizedBox(height: 30.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (req.status == "pending")
                  Padding(
                    padding: EdgeInsets.all(15.r),
                    child: CustomButton(
                      backgroundColor: Colors.transparent,
                      textColor: Colors.red,
                      borderColor: Colors.red,
                      text: getTranslated('cancel_request', context),
                      onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (_) => CancelContractorRequestDialog(req: req, fromList: false,),
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        barrierColor: Colors.black54,
                        isDismissible: false,
                        useSafeArea: true,
                        enableDrag: false,
                      ),
                    ),
                  )
              ],
            );
          },
        ));
  }
}
