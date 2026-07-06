import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/config_model.dart';
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
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';

class AddContractorRequestScreen extends StatefulWidget {
  @override
  State<AddContractorRequestScreen> createState() =>
      _AddContractorRequestScreenState();
}

class _AddContractorRequestScreenState
    extends State<AddContractorRequestScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _descriptionFocus = FocusNode();
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 0), () async {
      final prov =
          Provider.of<ContractorRequestProvider>(context, listen: false);
      prov.setRequestType(prov.requestTypes.first);
      prov.clearContractorRequestFile();
    });
  }
  List<String> contractorBenefits = [
    'volume_discounts_on_bulk_orders',
    'priority_processing_and_delivery',
    'flexible_payment_terms',
    'dedicated_account_manager',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      body: Column(
        children: [
          CustomAppBar(title: 'contractor_request', showBackButton: true),
          Expanded(
            child: Consumer2<ContractorRequestProvider , SplashProvider>(
              builder: (context, prov,splash , _) {
                ConfigModel config = splash.configModel!;
                String storePhone = config.storePhone??"" ;
                String storeEmail = config.storeEmail??"" ;
                List<OpeningHoursModel> workingHours = config.openingHours??[];
                List<String> workingDays = config.workingDays??[];
                return Scrollbar(
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(25.r),
                        physics: BouncingScrollPhysics(),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated('contractor_service', context),
                              style: AppTextStyles.h2(context),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              getTranslated('special_services_for_licensed_contractors_and_businesses', context),
                              style: AppTextStyles.h6(context).copyWith(color: ColorResources.getTextColor(context).withOpacity(0.7)),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  children: prov.requestTypes.map((type) {
                                    bool isSelected = prov.selectedRequestType == type;

                                    return Padding(
                                      padding: EdgeInsets.only(right: 5.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          prov.setRequestType(type);
                                          _descriptionController.clear();
                                          prov.clearContractorRequestFile();
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15.w,
                                            vertical: 10.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? ColorResources.getPrimaryColor(context)
                                                : ColorResources.getCardColor(context),
                                            borderRadius: BorderRadius.circular(15.r),
                                          ),
                                          child: Text(
                                            getTranslated(type, context),
                                            style: AppTextStyles.h6(context).copyWith(
                                              color: isSelected
                                                  ? Colors.white
                                                  : ColorResources.getTextColor(context),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            if (prov.selectedRequestType ==
                                'request_quote') ...[
                              Text(
                                getTranslated('request_a_quote', context),
                                style: AppTextStyles.h4(context),
                              ),
                              Text(
                                getTranslated('request_a_quote_hint', context),
                                style: AppTextStyles.h8(context).copyWith(
                                    color: ColorResources.getTextColor(context)
                                        .withOpacity(0.7)),
                              ),
                              SizedBox(height: 15.h),
                              Text(
                                getTranslated('materials_needed', context),
                                style: AppTextStyles.h4(context),
                              ),

                              SizedBox(height: 15.h),

                              CustomTextField(
                                hintText: getTranslated(
                                  'list_all_material_quantities_and_specifications',
                                  context,
                                ),
                                isShowBorder: true,
                                maxLines: 5,
                                inputType: TextInputType.multiline,
                                inputAction:
                                TextInputAction.newline,
                                capitalization:
                                TextCapitalization.sentences,
                                controller: _descriptionController,
                                focusNode: _descriptionFocus,
                              ),
                              SizedBox(height: 20.h),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: getTranslated('attachment', context),
                                      style: AppTextStyles.h4(context),
                                    ),
                                    TextSpan(
                                      text: ' (${getTranslated('optional', context).toLowerCase()})',
                                      style: AppTextStyles.h4(context).copyWith(
                                        color: ColorResources.getHintColor(context).withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15.h),

                              prov.contractorRequestFileName == null
                                  ? GestureDetector(
                                      onTap: () => Helpers.chooseContractorRequestFile(prov),
                                      child: _buildChooseFileButton())
                                  : GestureDetector(
                                      onTap: () =>
                                          Helpers.chooseContractorRequestFile(prov),
                                      child: _buildChosenFilePreview(prov)),
                              SizedBox(height: 20.h,),

                              prov.saveContractorRequestLoading!?
                                  CustomCircularIndicator()
                                  :CustomButton(text: getTranslated('submit_quote_request', context),
                                onTap: (){
                                  FocusScope.of(context).unfocus();
                                  if(_descriptionController.text.isEmpty){
                                    showCustomSnackBar(getTranslated('please_enter_your_materials', context), context);
                                  }else{
                                    ContractorRequestModel contractorRequest = ContractorRequestModel(
                                      messageOrItems: _descriptionController.text,
                                      type: 'quote',
                                    );
                                    prov.saveContractorRequest(context, contractorRequest).then((status) {
                                      if(status.isSuccess){
                                        showCustomSnackBar(getTranslated('contractor_request_sent_successfully', context), context , isError: false);
                                        prov.getContractorRequests(context);
                                        Navigator.pop(context);
                                      }else{
                                        showCustomSnackBar(getTranslated('something_went_wrong', context), context);
                                      }
                                    });
                                  }
                                },
                              ),

                              SizedBox(height: 20.h,),

                              Text(getTranslated('we_will_review_your_request_and_send_you_a_detailed_quote_within_24_hours', context) ,textAlign: TextAlign.center, style: AppTextStyles.h8(context).copyWith(color: ColorResources.getTextColor(context).withOpacity(0.6)),),
                              SizedBox(height: 10.h,),
                            ],
                            if (prov.selectedRequestType == 'bulk_order') ...[
                              Text(
                                getTranslated('bulk_order_request', context),
                                style: AppTextStyles.h4(context),
                              ),
                              Text(getTranslated('bulk_order_request_hint', context),
                                style: AppTextStyles.h8(context).copyWith(color: ColorResources.getTextColor(context).withOpacity(0.7))),
                              SizedBox(height: 15.h),
                              Text(getTranslated('items_and_quantities', context),
                                style: AppTextStyles.h4(context)),
                              SizedBox(height: 15.h),

                              CustomTextField(
                                hintText: getTranslated('items_and_quantities_hint', context),
                                isShowBorder: true,
                                maxLines: 5,
                                inputType: TextInputType.multiline,
                                inputAction:
                                TextInputAction.newline,
                                capitalization:
                                TextCapitalization.sentences,
                                controller: _descriptionController,
                                focusNode: _descriptionFocus,
                              ),
                              SizedBox(height: 20.h,),
                              Container(
                                padding: EdgeInsets.all(15.r),
                                decoration: BoxDecoration(
                                  color: ColorResources.getPrimaryColor(context).withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(15.r),
                                ),child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getTranslated('contractor_benefits', context),style: AppTextStyles.h4(context),),
                                SizedBox(height: 10.h),
                                  Column(
                                    children: contractorBenefits.map((item) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 2.h),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.check,
                                              size: 18.sp,
                                              color: ColorResources.getTextColor(context).withOpacity(0.8),
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              child: Text(
                                                getTranslated(item, context),
                                                style: AppTextStyles.h6(context).copyWith(
                                                  color: ColorResources.getTextColor(context).withOpacity(0.8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),

                                ],
                              ),
                              ),
                              SizedBox(height: 20.h,),

                              prov.saveContractorRequestLoading!?
                              CustomCircularIndicator()
                                  :CustomButton(text: getTranslated('request_bulk_pricing', context),
                                onTap: (){
                                  FocusScope.of(context).unfocus();
                                  if(_descriptionController.text.isEmpty){
                                    showCustomSnackBar(getTranslated('please_enter_items', context), context);
                                  }else{
                                    ContractorRequestModel contractorRequest = ContractorRequestModel(
                                      messageOrItems: _descriptionController.text,
                                      type: 'bulk_order',
                                    );
                                    prov.saveContractorRequest(context, contractorRequest).then((status) {
                                      if(status.isSuccess){
                                        showCustomSnackBar(getTranslated('contractor_request_sent_successfully', context), context , isError: false);
                                        prov.getContractorRequests(context);
                                        Navigator.pop(context);
                                      }else{
                                        showCustomSnackBar(getTranslated('something_went_wrong', context), context);
                                      }
                                    });
                                  }
                                },),

                              SizedBox(height: 20.h,),

                              Center(child: Text(getTranslated('bulk_orders_qualify_for_special_contractor_pricing', context) ,textAlign: TextAlign.center , style: AppTextStyles.h8(context).copyWith(color: ColorResources.getTextColor(context).withOpacity(0.6)),)),
                              SizedBox(height: 10.h,),
                            ],
                            if (prov.selectedRequestType == 'contact_sales')...[
                              Text(
                                getTranslated('contact_sales_team', context),
                                style: AppTextStyles.h4(context),
                              ),
                              Text(getTranslated('contact_sales_team_hint', context),
                                  style: AppTextStyles.h8(context).copyWith(color: ColorResources.getTextColor(context).withOpacity(0.7))),
                              SizedBox(height: 15.h),
                              Text(getTranslated('your_message', context),
                                  style: AppTextStyles.h4(context)),
                              SizedBox(height: 15.h),

                              CustomTextField(
                                hintText: getTranslated('tell_us_about_your_project_or_inquiry', context),
                                isShowBorder: true,
                                maxLines: 5,
                                inputType: TextInputType.multiline,
                                inputAction:
                                TextInputAction.newline,
                                capitalization:
                                TextCapitalization.sentences,
                                controller: _descriptionController,
                                focusNode: _descriptionFocus,
                              ),
                              SizedBox(height: 20.h,),

                              prov.saveContractorRequestLoading!?
                              CustomCircularIndicator()
                                  :CustomButton(text: getTranslated('send_message', context),
                                onTap: (){
                                  FocusScope.of(context).unfocus();
                                  if(_descriptionController.text.isEmpty){
                                    showCustomSnackBar(getTranslated('please_enter_your_message', context), context);
                                  }else{
                                    ContractorRequestModel contractorRequest = ContractorRequestModel(
                                      messageOrItems: _descriptionController.text,
                                      type: 'contact_sales',
                                    );
                                    prov.saveContractorRequest(context, contractorRequest).then((status) {
                                      if(status.isSuccess){
                                        showCustomSnackBar(getTranslated('contractor_request_sent_successfully', context), context , isError: false);
                                        prov.getContractorRequests(context);
                                        Navigator.pop(context);
                                      }else{
                                        showCustomSnackBar(getTranslated('something_went_wrong', context), context);
                                      }
                                    });
                                  }
                                },),

                              SizedBox(height: 20.h,),
                              Container(
                                padding: EdgeInsets.all(15.r),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  border: Border.all(color: ColorResources.getBorderColor(context))
                                ),child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getTranslated('phone', context),style: AppTextStyles.h4(context),),
                                  SizedBox(height: 10.h),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Expanded(
                                        child: Text(storePhone,
                                          style: AppTextStyles.h6(context).copyWith(
                                            color: ColorResources.getPrimaryColor(context),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                              ),
                              SizedBox(height: 10.h,),
                              Container(
                                padding: EdgeInsets.all(15.r),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    border: Border.all(color: ColorResources.getBorderColor(context))
                                ),child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getTranslated('email', context),style: AppTextStyles.h4(context),),
                                  SizedBox(height: 10.h),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Expanded(
                                        child: Text(storeEmail,
                                          style: AppTextStyles.h6(context).copyWith(
                                            color: ColorResources.getPrimaryColor(context),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                              ),SizedBox(height: 10.h,),
                              Container(
                                padding: EdgeInsets.all(15.r),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  border: Border.all(
                                    color: ColorResources.getBorderColor(context),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated('business_hours', context),
                                      style: AppTextStyles.h4(context),
                                    ),
                                    SizedBox(height: 10.h),

                                    if (workingDays.isNotEmpty)
                                        Text(
                                          "${getTranslated('working_days', context)}: "
                                              "${workingDays.map((day) => DateConverter.localizeWeekDay(context, day)).join(', ')}",
                                          style: AppTextStyles.h6(context),
                                        ),

                                    SizedBox(height: 10.h),

                                    ...workingHours.map(
                                          (hour) => Padding(
                                        padding: EdgeInsets.only(bottom: 6.h),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 18.sp,
                                              color: ColorResources.getPrimaryColor(context),
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              "${DateConverter.convertTimeToTime(hour.start!)} - ${DateConverter.convertTimeToTime(hour.end!)}",
                                              style: AppTextStyles.h6(context).copyWith(
                                                color: ColorResources.getPrimaryColor(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        )));
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildChooseFileButton() {
    return Container(
      width: double.infinity,
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: ColorResources.getBorderColor(context),
          width: 0.5,
        ),
      ),
      child: Center(
        child: Text(
          getTranslated('choose_pic_or_pdf', context),
          style: AppTextStyles.h6(context),
        ),
      ),
    );
  }

  Widget _buildChosenFilePreview(ContractorRequestProvider contractorRequestProvider) {
    String? attachmentName = contractorRequestProvider.contractorRequestFileName;
    File? attachment = contractorRequestProvider.contractorRequestFile;

    return Center(
      child: Container(
        height: 220.h,
        width: 350.w,
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: ColorResources.getBorderColor(context),
            width: 0.5,
          ),
        ),
        child: Center(
          child:  attachment!.path.toLowerCase().endsWith('.pdf')
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.picture_as_pdf,
                size: 45.sp,
                color: ColorResources.getTextColor(context)),
              SizedBox(height: 15.h),
              Text(attachmentName ?? "",textAlign: TextAlign.center,
                style: AppTextStyles.h6(context)),
            ],
          )
              : Image.file(attachment, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
