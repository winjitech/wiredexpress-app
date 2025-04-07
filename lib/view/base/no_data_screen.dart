import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:provider/provider.dart';

class NoDataScreen extends StatelessWidget {
  final bool isOrder;
  final bool isCart;
  final bool isNothing;
  NoDataScreen(
      {this.isCart = false, this.isNothing = false, this.isOrder = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
                isOrder
                    ? Images.clock
                    : isCart
                        ? Images.shopping_cart
                        : Images.binoculars,
                width: MediaQuery.of(context).size.height * 0.22,
                height: MediaQuery.of(context).size.height * 0.22,
                color: ColorResources.getScaffoldColor(context)),
            Text(
              getTranslated(
                  isOrder
                      ? 'no_order_history_available'
                      : isCart
                          ? 'empty_cart'
                          : 'nothing_found',
                  context),
              style: rubikBold.copyWith(
                  color: ColorResources.getScaffoldColor(context),
                  fontSize: MediaQuery.of(context).size.height * 0.023),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              isOrder
                  ? getTranslated('buy_something_to_see', context)
                  : isCart
                      ? getTranslated('look_like_have_not_added', context)
                      : '',
              style: rubikMedium.copyWith(
                  color: ColorResources.getTextColor(context),
                  fontSize: MediaQuery.of(context).size.height * 0.0175),
              textAlign: TextAlign.center,
            ),
          ]),
    );
  }
}
