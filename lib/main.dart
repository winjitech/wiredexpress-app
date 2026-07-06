import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/provider/contractor_request_provider.dart';
import 'package:wired_express/provider/payment_provider.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/subscription_provider.dart';
import 'package:wired_express/provider/timer_provider.dart';
import 'package:wired_express/theme/dark_theme.dart';
import 'package:wired_express/theme/light_theme.dart';
import 'package:wired_express/view/screens/notification/my_notification.dart';
import 'package:wired_express/view/screens/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wired_express/localization/app_localization.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/banner_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/chat_provider.dart';
import 'package:wired_express/provider/coupon_provider.dart';
import 'package:wired_express/provider/localization_provider.dart';
import 'package:wired_express/provider/home_provider.dart';
import 'package:wired_express/provider/notification_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/language_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/search_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:wired_express/utill/http_overrides.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'di_container.dart' as di;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter_localizations/src/cupertino_localizations.dart';
import 'package:flutter_localizations/src/widgets_localizations.dart';
import 'package:flutter_localizations/src/material_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await Firebase.initializeApp();
  await di.init();
  int? _orderID;

  final applicationDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(applicationDocumentDir.path);
  await Hive.openBox('myBox');
  HttpOverrides.global = MyHttpOverrides();

  try {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      //  _orderID = notificationAppLaunchDetails!.payload != null ? int.parse(notificationAppLaunchDetails.payload!) : null;
      // _screenID = notificationAppLaunchDetails.payload.toString();
      //   print('the screen id is ' + '$_screenID');
    }
    await MyNotification.initialize(flutterLocalNotificationsPlugin);
    // await MyNotification.showData(message);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    // MyNotification.
  } catch (e) {}

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TimerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BannerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CustomAuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CartProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CouponProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WishListProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SearchProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<HomeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<PlaceOrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SubscriptionProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<PaymentProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ContractorRequestProvider>()),

    ],
    child: ScreenUtilInit(
      designSize: Size(448, 998),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        print("Screen Width = ${ScreenUtil().screenWidth}");
        print("Screen Height = ${ScreenUtil().screenHeight}");
        print(
          "Width: ${MediaQuery.of(context).size.width}, "
              "Height: ${MediaQuery.of(context).size.height}, "
              "TextScaleFactor: ${MediaQuery.of(context).textScaleFactor}",
        );
        return MyApp(isWeb: !kIsWeb);
      },
    ),
  ));
}

class MyApp extends StatefulWidget {
  final int? orderId;
  final bool? isWeb;
  final String? screenId;
  MyApp(
      {@required this.orderId, @required this.isWeb, @required this.screenId});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getToken().then((value) => print(value));
    // RouterHelper.setupRouter();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(_globalKey)
        .then((bool isSuccess) {
      if (isSuccess) {
        Timer(Duration(seconds: 0), () async {
          if (Provider.of<CustomAuthProvider>(context, listen: false)
              .isLoggedIn()!) {
            Provider.of<CustomAuthProvider>(context, listen: false)
                .updateToken();
            // await Provider.of<WishListProvider>(context, listen: false).initWishList(context);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> _locals = [];
    AppConstants.languages.forEach((language) {
      _locals.add(Locale(language.languageCode!, language.countryCode));
    });

    return Consumer2<SplashProvider, ThemeProvider>(
      builder: (context, splashProvider, themeProvider, child) {
        return (kIsWeb && splashProvider.configModel == null)
            ? SizedBox()
            : MaterialApp(
                // onGenerateRoute: RouterHelper.router.generator,
                //  initialRoute: Routes.getSplashRoute(),
                home: SplashScreen(),
                // home: LoginWithPhoneScreen(),
                title: splashProvider.configModel != null
                    ? splashProvider.configModel!.storeName ?? ''
                    : AppConstants.appName,
                debugShowCheckedModeBanner: false,
                navigatorKey: MyApp.navigatorKey,
          theme: themeProvider.darkTheme ? dark : light,
                locale: Provider.of<LocalizationProvider>(context).locale,
                localizationsDelegates: [
                  AppLocalization.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: _locals,
              );
      },
    );
  }
}
// Colors.black
