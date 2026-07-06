import 'package:wired_express/data/model/response/contractor_request_model.dart';
import 'package:wired_express/provider/contractor_request_provider.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/Custom_button.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelContractorRequestDialog extends StatelessWidget {
  final ContractorRequestModel req;
  final bool fromList;

  const CancelContractorRequestDialog(
      {super.key, required this.req, required this.fromList});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.all(25.r),
        child: Container(
          decoration: BoxDecoration(
            color: ColorResources.getScaffoldBackgroundColor(context),
            borderRadius: BorderRadius.circular(15.r),
          ),
          width: 300.w,
          child: Consumer<ContractorRequestProvider>(
            builder: (context, prov, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20.h),
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: ColorResources.getPrimaryColor(context),
                    child: Icon(
                      Icons.cancel,
                      color: ColorResources.getScaffoldBackgroundColor(context),
                      size: 50.sp,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.r),
                    child: Text(
                      getTranslated(
                          'are_you_sure_cancel_this_contractor_zone_request',
                          context),
                      style: AppTextStyles.h5(
                        context,
                      ).copyWith(color: ColorResources.getTextColor(context)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  prov.cancelContractorRequestLoading!
                      ? CustomCircularIndicator()
                      : Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 5.h,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  height: 40,
                                  radius: 10,
                                  backgroundColor:
                                      ColorResources.getScaffoldBackgroundColor(
                                    context,
                                  ),
                                  textColor: ColorResources.getPrimaryColor(
                                    context,
                                  ),
                                  borderColor: ColorResources.getPrimaryColor(
                                    context,
                                  ),
                                  text: getTranslated('yes', context),
                                  onTap: () {
                                    prov
                                        .cancelContractorRequest(
                                            context, req.id!)
                                        .then((onValue) {
                                      if (onValue.isSuccess) {
                                        Navigator.pop(context);
                                        if (!fromList) {
                                          Navigator.pop(context);
                                        }
                                        prov.getContractorRequests(context);
                                        showCustomSnackBar(
                                          getTranslated(
                                            'contractor_request_cancel_success',
                                            context,
                                          ),
                                          context,
                                          isError: false,
                                        );
                                      }
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Expanded(
                                child: CustomButton(
                                  height: 40,
                                  radius: 10,
                                  text: getTranslated('no', context),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
