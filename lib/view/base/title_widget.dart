import 'package:flutter/material.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';

class TitleWidget extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;

  TitleWidget({@required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title!,
          style: rubikMedium.copyWith(
              color: ColorResources.getTextColor(context))),
      onTap != null && !ResponsiveHelper.isDesktop(context)
          ? InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: Text(
                  getTranslated('view_all', context),
                  style: rubikRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_SMALL,
                      color: ColorResources.getTextColor(context)),
                ),
              ),
            )
          : SizedBox(),
    ]);
  }
}
