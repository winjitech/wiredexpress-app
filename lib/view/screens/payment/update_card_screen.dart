import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/payment_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';

class UpdateCardSreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch the token from the provider
    String? token =
        Provider.of<CustomAuthProvider>(context, listen: false).getUserToken();

    final String url =
        Provider.of<PaymentProvider>(context, listen: false).paymentLink!;
    final int userId =
        Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.id!;

    Future<bool> _onWillPop() async {
      Provider.of<PaymentProvider>(context, listen: false)
          .getPaymentCardList(context, userId);
      Navigator.pop(context);
      return true;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            CustomAppBar(
                title: getTranslated('payment_info', context),
                isBackButtonExist: true),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri(url),
                    headers: {"Authorization": "Bearer $token"},
                  ),
                  onLoadStart: (controller, url) {
                    print("URL == ${url}");
                    if (url.toString() ==
                        "https://wiredexpress01.com/card-success") {
                      // Navigate to another page
                      Provider.of<PaymentProvider>(context, listen: false)
                          .getPaymentCardList(context, userId)
                          .then((value) {
                        Navigator.pop(context);
                      });
                    }
                  },
                  onLoadStop: (controller, url) async {},
                  onLoadError: (controller, url, code, message) {},
                  onProgressChanged: (controller, progress) {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
