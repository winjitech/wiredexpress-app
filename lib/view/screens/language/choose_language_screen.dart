import 'package:wired_express/data/model/response/language_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/language_provider.dart';
import 'package:wired_express/provider/localization_provider.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/utill/color_resources.dart';

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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 5),
              child: Text(
                getTranslated('choose_the_language', context)!,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(height: 20),

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
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      child: CustomButton(
                        backgroundColor:
                            ColorResources.getScaffoldColor(context),
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
      onTap: () {
        languageProvider.changeSelectIndex(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: languageProvider.selectIndex == index
              ? ColorResources.getScaffoldColor(context).withOpacity(.15)
              : null,
          border: Border(
              top: BorderSide(
                  width: languageProvider.selectIndex == index ? 1.0 : 0.0,
                  color: languageProvider.selectIndex == index
                      ? ColorResources.getScaffoldColor(context)
                      : Colors.transparent),
              bottom: BorderSide(
                  width: languageProvider.selectIndex == index ? 1.0 : 0.0,
                  color: languageProvider.selectIndex == index
                      ? ColorResources.getScaffoldColor(context)
                      : Colors.transparent)),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1.0,
                    color: languageProvider.selectIndex == index
                        ? Colors.transparent
                        : (languageProvider.selectIndex! - 1) == (index! - 1)
                            ? Colors.transparent
                            : ColorResources.getScaffoldColor(context))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(languageModel.imageUrl!, width: 34, height: 34),
                  const SizedBox(width: 30),
                  Text(
                    languageModel.languageName!,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 17,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                ],
              ),
              languageProvider.selectIndex == index
                  ? Image.asset(
                      Images.done,
                      width: 17,
                      height: 17,
                      color: ColorResources.getScaffoldColor(context),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
