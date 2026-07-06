import 'package:wired_express/utill/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/utill/styles.dart';

class NoDataFoundView extends StatefulWidget {
  final String text;
  final bool showIcon;

  const NoDataFoundView(
      {super.key, required this.text, required this.showIcon});
  @override
  State<NoDataFoundView> createState() => _NoDataFoundViewState();
}

class _NoDataFoundViewState extends State<NoDataFoundView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          25.r,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.showIcon == true)
              Image.asset(
                Images.noDataFoundIcon,
                width: 100.w,
                height: 100.h,
                color: ColorResources.getTextColor(context),
              ),
            if (widget.showIcon == true) SizedBox(height: 25.h),
            Text(
              getTranslated(widget.text, context),
              textAlign: TextAlign.center,
              style: AppTextStyles.h4(context).copyWith(
                fontWeight: FontWeight.w600,
                color: ColorResources.getTextColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
