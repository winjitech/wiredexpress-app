import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/contractor_request_model.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/contractor_request_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/Custom_button.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/no_data_found_view.dart';
import 'package:wired_express/view/screens/contractor_request/add_contractor_request_screen.dart';
import 'package:wired_express/view/screens/contractor_request/contractor_request_details_screen.dart';
import 'package:wired_express/view/screens/contractor_request/widget/cancel_contractor_request_dialog.dart';

class ContractorRequestsScreen extends StatefulWidget {
  @override
  State<ContractorRequestsScreen> createState() =>
      _ContractorRequestsScreenState();
}

class _ContractorRequestsScreenState extends State<ContractorRequestsScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 0), () async {
      final prov =
          Provider.of<ContractorRequestProvider>(context, listen: false);
      prov.getContractorRequests(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorResources.getPrimaryColor(context),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    AddContractorRequestScreen())),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          CustomAppBar(title: 'contractor_requests', showBackButton: true),
          Expanded(
            child: Consumer2<ContractorRequestProvider, SplashProvider>(
              builder: (context, prov, splash, child) {
                return prov.contractorRequestListLoading! ||
                        prov.contractorRequestList == null
                    ? CustomCircularIndicator()
                    : prov.contractorRequestList!.isEmpty
                        ? const NoDataFoundView(
                            text: 'no_any_request_yet',
                            showIcon: false,
                          )
                        : ListView.builder(
                            itemCount: prov.contractorRequestList!.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              ContractorRequestModel req =
                                  prov.contractorRequestList![index];
                              String attachmentUrl = splash.configModel!
                                  .baseUrls!.contractorRequestAttachmentsUrl!;
                              Color statusColor = Helpers.statusColor(
                                context,
                                req.status!,
                              )!;
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ContractorRequestDetailsScreen(
                                                  req: req),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(15.r),
                                      decoration: BoxDecoration(
                                        color: ColorResources
                                            .getTextFieldFillColor(
                                          context,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              if (req.attachment != null &&
                                                  req.attachment!.isNotEmpty)
                                                Row(
                                                  children: [
                                                    req.attachment!
                                                            .toLowerCase()
                                                            .endsWith('.pdf')
                                                        ? GestureDetector(
                                                            onTap: () async {
                                                              String fullUrl =
                                                                  "$attachmentUrl/${req.attachment!}";
                                                              await Helpers
                                                                  .downloadPdf(
                                                                req.attachment!,
                                                                fullUrl,
                                                              );
                                                            },
                                                            child: Container(
                                                              width: 70.w,
                                                              height: 65.h,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: ColorResources
                                                                    .getPrimaryColor(
                                                                        context),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.r),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .picture_as_pdf,
                                                                size: 35.sp,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          )
                                                        : GestureDetector(
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true,
                                                                barrierColor: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.8),
                                                                builder: (_) =>
                                                                    Dialog(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  insetPadding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                          '$attachmentUrl/${req.attachment}',
                                                                      cacheKey:
                                                                          '$attachmentUrl/${req.attachment}',
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.r),
                                                              child:
                                                                  CachedNetworkImage(
                                                                width: 70.w,
                                                                height: 65.h,
                                                                fit: BoxFit
                                                                    .cover,
                                                                imageUrl:
                                                                    '$attachmentUrl/${req.attachment}',
                                                                cacheKey:
                                                                    '$attachmentUrl/${req.attachment}',
                                                              ),
                                                            ),
                                                          ),
                                                    SizedBox(width: 15.w),
                                                  ],
                                                ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      getTranslated(
                                                          req.type == 'quote'
                                                              ? 'request_quote'
                                                              : req.type!,
                                                          context),
                                                      style: AppTextStyles.h4(
                                                              context)
                                                          .copyWith(
                                                        color: ColorResources
                                                            .getTextColor(
                                                                context),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      req.messageOrItems ?? '',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: AppTextStyles.h6(
                                                              context)
                                                          .copyWith(
                                                        color: ColorResources
                                                                .getTextColor(
                                                                    context)
                                                            .withOpacity(0.7),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 15.w),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.r),
                                                      color: statusColor
                                                          .withOpacity(
                                                        0.2,
                                                      ),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 4.h,
                                                    ),
                                                    child: Text(
                                                      getTranslated(
                                                        req.status!,
                                                        context,
                                                      ),
                                                      style: AppTextStyles.h6(
                                                              context)
                                                          .copyWith(
                                                        color: statusColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  Text(
                                                    DateConverter
                                                        .convertIsoStringToDayMonthFormat(
                                                      context,
                                                      req.createdAt!,
                                                    ),
                                                    style: AppTextStyles.h6(
                                                            context)
                                                        .copyWith(
                                                      color: ColorResources
                                                              .getTextColor(
                                                                  context)
                                                          .withOpacity(0.5),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          if (req.status == "pending") ...[
                                            SizedBox(
                                              height: 4.h,
                                            ),
                                            CustomButton(
                                              height: 40,
                                              backgroundColor:
                                                  Colors.transparent,
                                              textColor: Colors.red,
                                              borderColor: Colors.red,
                                              text: getTranslated(
                                                  'cancel_request', context),
                                              onTap: () => showModalBottomSheet(
                                                context: context,
                                                builder: (_) =>
                                                    CancelContractorRequestDialog(
                                                  req: req,
                                                  fromList: true,
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                                isScrollControlled: true,
                                                barrierColor: Colors.black54,
                                                isDismissible: false,
                                                useSafeArea: true,
                                                enableDrag: false,
                                              ),
                                            )
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
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
