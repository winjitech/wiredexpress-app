import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/payment_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/screens/payment/widget/remove_card_bottom_sheet.dart';

class UpdateCardSreen extends StatelessWidget {
  final bool? fromUpdate;

  const UpdateCardSreen({super.key, this.fromUpdate = false});
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
        appBar: AppBar(
          title: Text(
            getTranslated('payment_info', context),
            style: AppTextStyles.h2(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 18.sp),
            color: ColorResources.getTextColor(context),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            if (fromUpdate!)
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => RemoveCardBottomSheet(
                      cardId:
                          Provider.of<PaymentProvider>(context, listen: false)
                              .paymentCardList![0]
                              .id!),
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  barrierColor: Colors.black54,
                  isDismissible: true,
                  useSafeArea: true,
                ),
                child: Padding(
                  padding: EdgeInsets.all(5.r),
                  child: Icon(Icons.delete, color: Colors.red),
                ),
              ),
          ],
          backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(40.r),
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
