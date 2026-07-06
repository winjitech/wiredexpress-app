import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';

class CustomButton extends StatelessWidget {
  final double? width, height, radius, textSize;
  final Color? backgroundColor, textColor, borderColor;
  final String? text;
  final VoidCallback? onTap;
  final IconData? icon;

  const CustomButton({
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    required this.text,
    this.radius,
    this.onTap,
    this.textSize,
    this.borderColor,
    this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (width ?? double.infinity).w,
        height: (height ?? 50).h,
        decoration: BoxDecoration(
          color: backgroundColor ?? ColorResources.getPrimaryColor(context),
          borderRadius: BorderRadius.circular((radius ?? 25).r),
          border: Border.all(color: borderColor ?? Colors.transparent),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Row(
                children: [
                  Icon(
                    icon!,
                    color: textColor ?? ColorResources.getCardColor(context),
                    size: 20.sp,
                  ),
                  SizedBox(width: 15.w),
                ],
              ),
            Text(
              text!.toUpperCase(),
              style: AppTextStyles.h3(context).copyWith(
                color: textColor ?? Colors.white,
                fontSize: (textSize ?? 12).sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

