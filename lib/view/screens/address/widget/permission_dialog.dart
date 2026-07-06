import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:geolocator/geolocator.dart';

class PermissionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Container(
        width: 300,
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.add_location_alt_rounded,
                color: ColorResources.getPrimaryColor(context), size: 100),
            SizedBox(height: 20.h),
            Text(
              getTranslated('you_denied_location_permission', context),
              textAlign: TextAlign.justify,
              style: AppTextStyles.h6(context),
            ),
            SizedBox(height: 20.h),
            Row(children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        side: BorderSide(
                            width: 2, color: ColorResources.getPrimaryColor(context),)),
                    minimumSize: Size(1, 50),
                  ),
                  child: Text(
                    getTranslated('no', context),
                    style: AppTextStyles.h7(context),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Expanded(
                  child: CustomButton(
                      text: getTranslated('yes', context),
                      onTap: () async {
                        await Geolocator.openAppSettings();
                        Navigator.pop(context);
                      })),
            ]),
          ]),
        ),
      ),
    );
  }
}
