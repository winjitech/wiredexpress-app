import 'package:wired_express/data/model/response/notification_model.dart';
import 'package:wired_express/data/model/response/notification_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationDetailsDialog extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailsDialog({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      child: Padding(
        padding: EdgeInsets.all(25.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),

            CircleAvatar(
              radius: 32.r,
              backgroundColor: ColorResources.getPrimaryColor(context),
              child: Icon(
                Icons.notifications_rounded,
                size: 40.sp,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 15.h),

            Text(
              notification.title ?? "",
              textAlign: TextAlign.center,
              style: AppTextStyles.h5(context).copyWith(fontSize: 15.sp),
            ),
            SizedBox(height: 15.h),

            Text(
              notification.description ?? "",
              textAlign: TextAlign.center,
              style: AppTextStyles.h5(context).copyWith(
                fontSize: 15.sp,
                color: ColorResources.getTextColor(context).withOpacity(0.6),
              ),
            ),
            SizedBox(height: 20.h),

            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 50.h,
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Center(
                      child: Text(
                        getTranslated('back', context),
                        style: AppTextStyles.h5(
                          context,
                        ).copyWith(color: ColorResources.getPrimaryColor(context)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
