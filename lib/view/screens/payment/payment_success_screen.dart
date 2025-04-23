import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            Text(
              success ? 'Payment succeed!' : 'Payment Failed',
              style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: CustomButton(
                  backgroundColor: ColorResources.getPrimaryColor(context),
                  text: success ? 'Back' : 'Home',
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
