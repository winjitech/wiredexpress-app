import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/data/model/response/language_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/language_provider.dart';
import 'package:wired_express/provider/localization_provider.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/styles.dart';

import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:wired_express/utill/Images.dart';

class ChooseLanguageScreen extends StatelessWidget {
  final bool fromHomeScreen;

  const ChooseLanguageScreen({Key? key, this.fromHomeScreen = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<LanguageProvider>(context, listen: false)
        .initializeAllLanguages(context);

    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.only(left: 5, top: 5),
              child: Text(
                getTranslated('choose_the_language', context),
                style: AppTextStyles.h3(context).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Consumer<LanguageProvider>(
                builder: (context, languageProvider, child) => Expanded(
                    child: ListView.builder(
                        itemCount: languageProvider.languages.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => _languageWidget(
                            context: context,
                            languageModel: languageProvider.languages[index],
                            languageProvider: languageProvider,
                            index: index)))),
            Consumer<LanguageProvider>(
                builder: (context, languageProvider, child) => Padding(
                      padding: EdgeInsets.only(
                          left: 15.w, right: 15.w, bottom: 15.h),
                      child: CustomButton(
                        text: getTranslated('save', context),
                        onTap: () {
                          if (languageProvider.languages.isNotEmpty &&
                              languageProvider.selectIndex != -1) {
                            Provider.of<LocalizationProvider>(context,
                                    listen: false)
                                .setLanguage(Locale(
                              AppConstants
                                  .languages[languageProvider.selectIndex!]
                                  .languageCode!,
                              AppConstants
                                  .languages[languageProvider.selectIndex!]
                                  .countryCode,
                            ));
                            if (fromHomeScreen) {
                              Navigator.pop(context);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LoginScreen()));
                            }
                          } else {
                            showCustomSnackBar(
                                getTranslated('select_a_language', context),
                                context);
                          }
                        },
                      ),
                    )),
          ],
        ),
      ),
    );
  }

  Widget _languageWidget(
      {required BuildContext context,
      required LanguageModel languageModel,
      required LanguageProvider languageProvider,
      int? index}) {
    return GestureDetector(
      onTap: () => languageProvider.changeSelectIndex(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: languageProvider.selectIndex == index
              ? ColorResources.getTextColor(context).withOpacity(0.1)
              : null,
          border: Border(
              top: BorderSide(
                  width: languageProvider.selectIndex == index ? 1.0 : 0.0,
                  color: languageProvider.selectIndex == index
                      ? ColorResources.getTextColor(context).withOpacity(0.4)
                      : Colors.transparent),
              bottom: BorderSide(
                  width: languageProvider.selectIndex == index ? 1.0 : 0.0,
                  color: languageProvider.selectIndex == index
                      ? ColorResources.getTextColor(context).withOpacity(0.4)
                      : Colors.transparent)),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
              width: 1.0,
              color: languageProvider.selectIndex == index
                  ? Colors.transparent
                  : (languageProvider.selectIndex! - 1) == (index! - 1)
                      ? Colors.transparent
                      : ColorResources.getTextColor(context).withOpacity(0.4),
            )),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(languageModel.imageUrl!, width: 34, height: 34),
                  SizedBox(width: 30.w),
                  Text(
                    languageModel.languageName!,
                    style: AppTextStyles.h4(context, fontSize: 17.sp),
                  ),
                ],
              ),
              languageProvider.selectIndex == index
                  ? Image.asset(
                      Images.done,
                      width: 17,
                      height: 17,
                      color:
                          ColorResources.getTextColor(context).withOpacity(0.4),
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
