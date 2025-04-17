import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/view/screens/dashboard/dashboard_screen.dart';
import 'package:wired_express/view/screens/payment/payment_success_screen.dart';

// #enddocregion platform_imports


const String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>
''';

const String kLocalExamplePage = '''
<!DOCTYPE html>
<html lang="en">
<head>
<title>Load file or HTML string example</title>
</head>
<body>

<h1>Local demo page</h1>
<p>
  This is an example page used to demonstrate how to load a local file or HTML
  string using the <a href="https://pub.dev/packages/webview_flutter">Flutter
  webview</a> plugin.
</p>

</body>
</html>
''';

const String kTransparentBackgroundPage = '''
  <!DOCTYPE html>
  <html>
  <head>
    <title>Transparent background test</title>
  </head>
  <style type="text/css">
    body { background: transparent; margin: 0; padding: 0; }
    #container { position: relative; margin: 0; padding: 0; width: 100vw; height: 100vh; }
    #shape { background: red; width: 200px; height: 200px; margin: 0; padding: 0; position: absolute; top: calc(50% - 100px); left: calc(50% - 100px); }
    p { text-align: center; }
  </style>
  <body>
    <div id="container">
      <p>Transparent background test</p>
      <div id="shape"></div>
    </div>
  </body>
  </html>
''';

class PaymentWebView extends StatefulWidget {

  final String? url;

  PaymentWebView({

    @required this.url
  });

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  WebViewController _controller = WebViewController();
  String? selectedUrl;

  @override
  void initState() {
    super.initState();
    selectedUrl = widget.url;
    // #docregion platform_features
    PlatformWebViewControllerCreationParams params = PlatformWebViewControllerCreationParams();
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) async {
            bool _isSuccess = url.contains('https://wiredexpress01.com/payment-success') && url.contains(AppConstants.BASE_URL);
            bool _isFailed = url.contains('https://wiredexpress01/payment-fail') && url.contains(AppConstants.BASE_URL);
            if(_isSuccess)  {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext? context)=>
                  PaymentSuccessScreen(success: true)));
            }
            if(_isFailed)  {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext? context)=>
                  PaymentSuccessScreen(success: false)));
            }

            debugPrint('is failed: $_isFailed');
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(selectedUrl!));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext? context) =>
        DashboardScreen(pageIndex: 0)));
    return true;
  }

  @override
  Widget build(BuildContext? context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.3,
          title:  Text(getTranslated('PAYMENT', context!), style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => DashboardScreen(pageIndex: 1)));
            },
          ),
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls({@required this.webViewController});

  final WebViewController? webViewController;

  @override
  Widget build(BuildContext? context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await webViewController!.canGoBack()) {
              await webViewController!.goBack();
            } else {
              // if (context.mounted) {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(content: Text('No back history item')),
              //   );
              // }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await webViewController!.canGoForward()) {
              await webViewController!.goForward();
            } else {
              // if (context.mounted) {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(content: Text('No forward history item')),
              //   );
              // }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => webViewController!.reload(),
        ),
      ],
    );
  }
}