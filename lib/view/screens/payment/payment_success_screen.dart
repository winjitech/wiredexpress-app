import 'package:flutter/material.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/Custom_button.dart';

import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:wired_express/view/screens/order/order_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final bool? success;
  PaymentSuccessScreen({@required this.success});

  @override
  Widget build(BuildContext? context) {
    return Scaffold(
      //appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)):null,
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
              success! ? 'Payment succeed!' : 'Payment Failed',
              style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

            // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            //   Text('${getTranslated('subscription_id', context)}:', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
            //   SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            //   Text('$subscriptionId', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
            // ]),

            SizedBox(height: 30),

            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: CustomButton(
                  backgroundColor: ColorResources.getPrimaryColor(context),
                  text: success! ? 'Back' : 'Home',
                  onTap: () {
                    if (success!) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext? context) =>
                                  DashboardScreen(pageIndex: 0)));
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
