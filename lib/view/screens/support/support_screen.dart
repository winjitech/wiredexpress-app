import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/chat_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/screens/chat/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/utill/color_resources.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      body: Column(
        children: [
          CustomAppBar(title: 'help_and_support', showBackButton: true),
          Expanded(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   Images.support,
                        //   height: 300,
                        //   width: 300,
                        // ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: ColorResources.getPrimaryColor(context),
                              size: 25.sp,
                            ),
                            Text(
                              getTranslated('store_address', context),
                              style: AppTextStyles.h7(context).copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          Provider.of<SplashProvider>(context, listen: false)
                              .configModel!
                              .storeAddress!,
                          style: AppTextStyles.h7(context),
                          textAlign: TextAlign.center,
                        ),
                        Divider(
                          thickness: 2,
                          color: ColorResources.COLOR_GRAY,
                        ),
                        SizedBox(height: 50.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.r),
                                    side: BorderSide(
                                      width: 2,
                                      color: ColorResources
                                          .getScaffoldBackgroundColor(context),
                                    ),
                                  ),
                                  minimumSize: Size(1, 50),
                                ),
                                onPressed: () {
                                  launch(
                                      'tel:${Provider.of<SplashProvider>(context, listen: false).configModel!.storePhone!}');
                                },
                                child: Text(
                                  getTranslated('call_now', context),
                                  style: AppTextStyles.h5(context).copyWith(
                                    color: ColorResources
                                        .getScaffoldBackgroundColor(context),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
