import 'package:wired_express/data/model/response/language_model.dart';
import 'package:wired_express/utill/images.dart';

class AppConstants {
  static const String appName = 'Wired Express';

  // static const String baseUrl = 'https://192.168.1.7/wired_express';

  static const String baseUrl = 'https://wiredexpress01.com';
  static const String categoryUrl = '/api/v1/categories';
  static const String categoryFeaturedUrl = '/api/v1/categories/featured';
  static const String bannerUrl = '/api/v1/banners';

  static const String electriciansUrl = '/api/v1/nearby-electricians';

  static const String popularProductUrl = '/api3/v1/products/latest';
  static const String productsListUrl = '/api/v1/products/category';
  static const String categoryProductUrl = '/api/v1/categories/products/';
  static const String configUrl = '/api/v1/config';
  static const String trackUrl = '/api/v1/customer/order/track';
  static const String messageUrl = '/api/v1/customer/message/get';
  static const String sendMessageUrl = '/api/v1/customer/message/send';
  static const String forgotPasswordUrl = '/api/v1/auth/forgot-password';
  static const String verifyTokenUrl = '/api/v1/auth/verify-token';
  static const String resetPasswordUrl = '/api/v1/auth/reset-password';
  static const String verifyPhoneUrl = '/api/v1/auth/verify-phone';
  static const String checkEmailUrl = '/api/v1/auth/check-email';
  static const String verifyEmailUrl = '/api/v1/auth/verify-email';
  static const String registerUrl = '/api/v1/auth/register';
  static const String loginUrl = '/api/v1/auth/login';
  static const String loginByPhoneUrl = '/api/v1/auth/loginbyphone';
  static const String tokenUrl = '/api/v1/customer/cm-firebase-token';
  static const String placeOrderUrl = '/api/v1/customer/order/place';
  static const String addressListUrl = '/api/v1/customer/address/list';
  static const String removeAddressUrl = '/api/v1/customer/address/delete?address_id=';
  static const String addAddressUrl = '/api/v1/customer/address/add';
  static const String updateAddressUrl = '/api/v1/customer/address/update/';
  static const String customerInfoUrl = '/api/v1/customer/info';

  static const String couponUrl = '/api/v1/coupon/list';
  static const String couponApplyUrl = '/api/v1/coupon/apply?code=';
  static const String historyOrderListUrl = '/api/v1/customer/order/history-list';
  static const String runningOrderListUrl = '/api/v1/customer/order/running-list';

  static const String orderCancelUrl = '/api/v1/customer/order/cancel';
  static const String updateMethodUrl = '/api/v1/customer/order/payment-method';
  static const String orderDetailsUrl = '/api/v1/customer/order/details?order_id=';
  static const String wishListUrl = '/api/v1/customer/wish-list';
  static const String wishListIdsUrl = '/api/v1/customer/wish-list/product-ids';

  static const String addToWishListUrl = '/api/v1/customer/wish-list/add-to-wishlist';
  static const String removeFromWishListUrl = '/api/v1/customer/wish-list/remove?product_id=';
  static const String notificationUrl = '/api/v1/notifications';
  static const String updateProfileUrl = '/api/v1/customer/update-profile';


  static const String searchUrl = '/api/v1/products/search';
  static const String sendSearchUrl = '/api/v1/customer/search';
  static const String reviewUrl = '/api/v1/products/reviews/submit';
  static const String productDetailsUrl = '/api/v1/products/details/';
  static const String lastLocationUrl = '/api/v1/delivery-man/last-location?order_id=';
  static const String deliveryManReviewUrl = '/api/v1/delivery-man/reviews/submit';
  static const String updateVersionUrl = '/api/v1/customer/update-version';
  static const String sendImageUrl = '/api/v1/customer/message/send-image';
  static const String filteredProductsUrl = '/api/v1/products/filtered-products';
  static const String checkPasswordUrl = '/api/v1/customer/check-password';
  static const String deleteAccountUrl = '/api/v1/customer/delete-account';
  static const String cartListIdsUrl = '/api/v1/customer/cart/product-ids';
  static const String cartListUrl = '/api/v1/customer/cart';
  static const String addToCartUrl = '/api/v1/customer/cart/add-to-cart';
  static const String removeFromCartUrl = '/api/v1/customer/cart/remove';
  static const String apiKey = 'AIzaSyDittP8hJ4T6bhdHQv601p0RVlYHN-D_hc';


  /// subscription
  static const String getSubscriptionPlansUrl = '/api/v1/customer/subscription/subscription-plans';
  static const String subscriptionUserUrl = '/api/v1/customer/payment/subscribe';
  static const String cancelSubscriptionUrl = '/api/v1/customer/payment/cancel-subscription';
  static const String subscriptionDetailsUrl =  '/api/v1/customer/payment/details';

  static const String getLastDeliveryCoordinatesUrl = '/api/v1/delivery-man/get-last-delivery-coordinates?order_id=';

  /// Shared Key
  static const String theme = 'theme';
  static const String token = 'token';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String cartList = 'cart_list';
  static const String userPassword = 'user_password';
  static const String userAddress = 'user_address';
  static const String userEmail = 'userEmail';
  static const String searchAddress = 'search_address';
  static const String topic = 'notify';
  static const String specificTopic = 'notify_specific';
  static const String addressId = 'address_id';


  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: Images.united_kindom,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: Images.spain,
        languageName: 'Spanish',
        countryCode: 'ES',
        languageCode: 'es'),
  ];
}
