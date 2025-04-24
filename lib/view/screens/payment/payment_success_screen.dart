import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/subscription_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/Custom_button.dart';

import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:wired_express/view/screens/order/order_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final bool success, fromCheckoutScreen;

  PaymentSuccessScreen(
      {required this.success, required this.fromCheckoutScreen});

  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 1170,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color:
                    ColorResources.getPrimaryColor(context!).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                success! ? Icons.check_circle : Icons.sms_failed,
                color: ColorResources.getPrimaryColor(context),
                size: 80,
              ),
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            Text(
              success ? getTranslated('payment_succeed', context) : getTranslated('payment_failed', context),
              style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: CustomButton(
                  backgroundColor: ColorResources.getPrimaryColor(context),
                  text: success ? getTranslated('back', context) : getTranslated('home', context),
                  onTap: () {
                    if (success) {
                      if (fromCheckoutScreen) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext? context) =>
                                    DashboardScreen(pageIndex: 0)));
                      } else {
                        Provider.of<SubscriptionProvider>(context,
                                listen: false)
                            .getSubscriptionPlans(context);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext? context) =>
                                    DashboardScreen(pageIndex: 4)));
                      }
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext? context) =>
                                  DashboardScreen(pageIndex: 0)));
                    }
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}
