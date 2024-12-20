import 'package:flutter/material.dart';
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
      appBar: CustomAppBar(title: getTranslated('help_and_support', context)),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   Images.support,
                  //   height: 300,
                  //   width: 300,
                  // ),
                  SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.location_on,
                        color: ColorResources.getPrimaryColor(context),
                        size: 25),
                    Text(getTranslated('store_address', context),
                        style: rubikMedium.copyWith(
                            color: ColorResources.getTextColor(context))),
                  ]),
                  SizedBox(height: 10),
                  Text(
                    Provider.of<SplashProvider>(context, listen: false)
                        .configModel!
                        .storeAddress!,
                    style: rubikRegular.copyWith(
                      color: ColorResources.getTextColor(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    thickness: 2,
                    color: ColorResources.COLOR_GRAY,
                  ),
                  SizedBox(height: 50),
                  Row(children: [
                    Expanded(
                        child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: BorderSide(
                              width: 2,
                              color: ColorResources.SCAFFOLD_COLOR,
                            )),
                        minimumSize: Size(1, 50),
                      ),
                      onPressed: () {
                        launch(
                            'tel:${Provider.of<SplashProvider>(context, listen: false).configModel!.storePhone!}');
                      },
                      child: Text(getTranslated('call_now', context),
                          style:
                          TextStyle(
                                    color: ColorResources.SCAFFOLD_COLOR,
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                  )),
                    )),
                    SizedBox(width: 10),
                    Expanded(
                        child: SizedBox(
                      height: 50,
                      child: CustomButton(
                        text: getTranslated('send_a_message', context),
                        onTap: () async {
                          // Provider.of<ChatProvider>(context, listen: false)
                          //     .refresh(context, true);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext? context) =>
                          //             ChatScreen()));
                        },
                      ),
                    )),
                  ]),
                ]),
          ),
        ),
      ),
    );
  }
}
