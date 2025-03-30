import 'dart:async';
import 'dart:io';import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/theme/dark_theme.dart';
import 'package:wired_express/theme/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/helper/html_type.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlViewerScreen extends StatefulWidget {
  final HtmlType? htmlType;
  HtmlViewerScreen({@required this.htmlType});

  @override
  _HtmlViewerScreenState createState() => _HtmlViewerScreenState();
}

class _HtmlViewerScreenState extends State<HtmlViewerScreen> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController? controllerGlobal;

  String? _viewID;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();


    _viewID = widget.htmlType.toString();
  }
  @override
  Widget build(BuildContext context) {
   // final String _language = getTranslated('language_code', context);
    String? _data;
    _data = widget.htmlType == HtmlType.TERMS_AND_CONDITION ?
    '${Provider.of<SplashProvider>(context, listen: false).configModel!.termsAndConditions}'
        : widget.htmlType == HtmlType.PRIVACY_POLICY ?
    Provider.of<SplashProvider>(context, listen: false).configModel!.privacyPolicy: null;
    print('url: ${_data}');


    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),

        appBar: CustomAppBar(title: getTranslated(widget.htmlType == HtmlType.TERMS_AND_CONDITION ? 'terms_and_condition'
            : widget.htmlType == HtmlType.PRIVACY_POLICY ? 'privacy_policy' : 'no_data_found', context)),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: ColorResources.BACKGROUND_COLOR,
            child: Stack(
              children: [
                // Center(
                //   child: SizedBox(width: 1170, child:
                //
                //   WebView(
                //     initialUrl: _data,
                //     javascriptMode: JavascriptMode.unrestricted,
                //     onWebViewCreated: (WebViewController webViewController) {
                //       _controller.future.then((value) => controllerGlobal = value);
                //       _controller.complete(webViewController);
                //     },
                //     onPageFinished: (String url) {
                //       setState(() {
                //         _isLoading = false;
                //       });
                //     },
                //   ),
                //   ),
                // ),
                _isLoading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ColorResources.getPrimaryColor(context)))) : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controllerGlobal!.canGoBack()) {
      controllerGlobal!.goBack();
      return Future.value(false);
    } else {
      return true;
    }
  }
}
