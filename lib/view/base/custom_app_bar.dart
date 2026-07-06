import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final bool showBackButton;
  final Color? color;
  final VoidCallback? onBackPressed;

  CustomAppBar({
    super.key,
    required this.title,
    required this.showBackButton,
    this.color,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            if (showBackButton == true)
              IconButton(
                onPressed:  onBackPressed ?? (){Navigator.pop(context);},
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18.sp,
                  color: color ?? ColorResources.getTextColor(context),
                ),
              ),
            SizedBox(width: (showBackButton == true ? 5 : 25).w),
            Expanded(
              child: Text(
                getTranslated(title!, context),
                style: AppTextStyles.h3(context).copyWith(
                  color: color ?? ColorResources.getTextColor(context),
                ),
              ),
            ),
            SizedBox(width: 10.w),
          ],
        ),
      ),
    );
  }
}
