import 'package:dio/dio.dart';
import 'package:wired_express/data/repository/auth_repo.dart';
import 'package:wired_express/data/repository/banner_repo.dart';
import 'package:wired_express/data/repository/cart_repo.dart';
import 'package:wired_express/data/repository/category_repo.dart';
import 'package:wired_express/data/repository/chat_repo.dart';
import 'package:wired_express/data/repository/coupon_repo.dart';
import 'package:wired_express/data/repository/location_repo.dart';
import 'package:wired_express/data/repository/main_repo.dart';
import 'package:wired_express/data/repository/notification_repo.dart';
import 'package:wired_express/data/repository/order_repo.dart';
import 'package:wired_express/data/repository/payment_repo.dart';
import 'package:wired_express/data/repository/place_order_repo.dart';
import 'package:wired_express/data/repository/product_repo.dart';
import 'package:wired_express/data/repository/language_repo.dart';
import 'package:wired_express/data/repository/search_repo.dart';
import 'package:wired_express/data/repository/profile_repo.dart';
import 'package:wired_express/data/repository/splash_repo.dart';
import 'package:wired_express/data/repository/subscription_repo.dart';
import 'package:wired_express/data/repository/wishlist_repo.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/banner_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/chat_provider.dart';
import 'package:wired_express/provider/coupon_provider.dart';
import 'package:wired_express/provider/localization_provider.dart';
import 'package:wired_express/provider/main_provider.dart';
import 'package:wired_express/provider/notification_provider.dart';
import 'package:wired_express/provider/order_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/payment_provider.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/language_provider.dart';
import 'package:wired_express/provider/search_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/subscription_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/provider/timer_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(
      () => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => CategoryRepo(dioClient: sl()));
  sl.registerLazySingleton(() => BannerRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ProductRepo(dioClient: sl()));
  sl.registerLazySingleton(() => LanguageRepo());
  sl.registerLazySingleton(
      () => CartRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(
      () => OrderRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
          () => PlaceOrderRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ChatRepo(dioClient: sl()));
  sl.registerLazySingleton(
      () => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => LocationRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => SearchRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => NotificationRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CouponRepo(dioClient: sl()));
  sl.registerLazySingleton(() => WishListRepo(dioClient: sl()));
  sl.registerLazySingleton(() => MainRepo(dioClient: sl()));
  sl.registerLazySingleton(() => SubscriptionRepo(dioClient: sl()));
  sl.registerLazySingleton(() => PaymentRepo(dioClient: sl(), sharedPreferences: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => TimerProvider());
  sl.registerFactory(() => PlaceOrderProvider(placeOrderRepo: sl()));

  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => CategoryProvider(categoryRepo: sl()));
  sl.registerFactory(() => BannerProvider(bannerRepo: sl()));
  sl.registerFactory(() => ProductProvider(productRepo: sl()));
  sl.registerFactory(() => CartProvider(cartRepo: sl()));
  sl.registerFactory(() => OrderProvider(orderRepo: sl()));
  sl.registerFactory(() => ChatProvider(chatRepo: sl()));
  sl.registerFactory(() => CustomAuthProvider(authRepo: sl()));
  sl.registerFactory(
      () => LocationProvider(sharedPreferences: sl(), locationRepo: sl()));
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(() => NotificationProvider(notificationRepo: sl()));
  sl.registerFactory(
      () => WishListProvider(wishListRepo: sl(), productRepo: sl()));
  sl.registerFactory(() => CouponProvider(couponRepo: sl()));
  sl.registerFactory(() => SearchProvider(searchRepo: sl()));
  sl.registerFactory(() => MainProvider(mainRepo: sl()));
  sl.registerFactory(() => SubscriptionProvider(subscriptionRepo: sl()));
  sl.registerFactory(() => PaymentProvider(sharedPreferences: sl(),paymentRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
