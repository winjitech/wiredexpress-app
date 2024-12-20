import 'package:wired_express/data/model/response/language_model.dart';
import 'package:wired_express/utill/images.dart';

class AppConstants {
  static const String APP_NAME = 'Wired Express';
// 192.168.1.3 or 172.18.128.1
  //192.168.0.112
  static const String BASE_URL = 'https://wiredexpress01.com';
  static const String CATEGORY_URI = '/api/v1/categories';
  static const String CATEGORY_FEATURED_URI = '/api/v1/categories/featured';
  static const String CATEGORY_URI_FUlL = '/api/v1/categories/full';
  static const String BANNER_URI = '/api/v1/banners';

  static const String POPULAR_PRODUCT_URI = '/api/v1/products/latest';
  static const String PRODUCTS_LIST_URI = '/api/v1/products/category';
  static const String SEARCH_PRODUCT_URI = '/api/v1/products/details/';
  static const String SUB_CATEGORY_URI = '/api/v1/categories/childes/';
  //static const String CATEGORY_URI = '/api/v1/categories/childes/';
  static const String CATEGORY_PRODUCT_URI = '/api/v1/categories/products/';
  static const String CONFIG_URI = '/api/v1/config';
  static const String TRACK_URI = '/api/v1/customer/order/track';
  static const String MESSAGE_URI = '/api/v1/customer/message/get';
  static const String SEND_MESSAGE_URI = '/api/v1/customer/message/send';
  static const String FORGET_PASSWORD_URI = '/api/v1/auth/forgot-password';
  static const String VERIFY_TOKEN_URI = '/api/v1/auth/verify-token';
  static const String RESET_PASSWORD_URI = '/api/v1/auth/reset-password';
  static const String VERIFY_PHONE_URI = '/api/v1/auth/verify-phone';
  static const String CHECK_EMAIL_URI = '/api/v1/auth/check-email';
  static const String VERIFY_EMAIL_URI = '/api/v1/auth/verify-email';
  static const String REGISTER_URI = '/api/v1/auth/register';
  static const String LOGIN_URI = '/api/v1/auth/login';
  static const String LOGIN_BY_PHONE_URI = '/api/v1/auth/loginbyphone';
  static const String SIGN_BY_PHONE_URI = '/api/v1/auth/store-name';
  static const String TOKEN_URI = '/api/v1/customer/cm-firebase-token';
  static const String PLACE_ORDER_URI = '/api/v1/customer/order/place';
  static const String ADDRESS_LIST_URI = '/api/v1/customer/address/list';
  static const String REMOVE_ADDRESS_URI = '/api/v1/customer/address/delete?address_id=';
  static const String ADD_ADDRESS_URI = '/api/v1/customer/address/add';
  static const String UPDATE_ADDRESS_URI = '/api/v1/customer/address/update/';
  static const String SET_MENU_URI = '/api/v1/products/best-seller';
  static const String CUSTOMER_INFO_URI = '/api/v1/customer/info';

  static const String COUPON_URI = '/api/v1/coupon/list';
  static const String COUPON_APPLY_URI = '/api/v1/coupon/apply?code=';
  static const String ORDER_LIST_URI = '/api/v1/customer/order/list';
  static const String HISTORY_ORDER_LIST_URI = '/api/v1/customer/order/history-list';
  static const String RUNNING_ORDER_LIST_URI = '/api/v1/customer/order/running-list';

  static const String ORDER_CANCEL_URI = '/api/v1/customer/order/cancel';
  static const String UPDATE_METHOD_URI = '/api/v1/customer/order/payment-method';
  static const String ORDER_DETAILS_URI = '/api/v1/customer/order/details?order_id=';
  static const String WISH_LIST_GET_URI = '/api/v1/customer/wish-list';
  static const String WISH_LIST_PRODUCTIDS_URI = '/api/v1/customer/wish-list/product-ids';

  static const String ADD_WISH_LIST_URI = '/api/v1/customer/wish-list/add-to-wishlist';
  static const String REMOVE_WISH_LIST_URI = '/api/v1/customer/wish-list/remove?product_id=';
  static const String NOTIFICATION_URI = '/api/v1/notifications';
  static const String UPDATE_PROFILE_URI = '/api/v1/customer/update-profile';

  static const String UPDATE_USER_NAME_URI = '/api/v1/customer/update-name';

  static const String SEARCH_URI = '/api/v1/products/search?name=';
  static const String BRANDS_URI = '/api/v1/products/brands';
  static const String BRAND_PRODUCTS_URI = '/api/v1/products/brand-products';
  static const String BRANDS_CATEGORIES_URI = '/api/v1/products/brand-categories';
  static const String SEND_SEARCH_URI = '/api/v1/customer/search';
  static const String REVIEW_URI = '/api/v1/products/reviews/submit';
  static const String PRODUCT_DETAILS_URI = '/api/v1/products/details/';
  static const String LAST_LOCATION_URI = '/api/v1/delivery-man/last-location?order_id=';
  static const String DELIVER_MAN_REVIEW_URI = '/api/v1/delivery-man/reviews/submit';
  static const String UPDATE_VERSION_CODE_URI = '/api/v1/customer/update-version';
  static const String SEND_IMAGE_URI = '/api/v1/customer/message/send-image';
  static const String GET_SEARCHED_FOOD = '/api/v1/nutrition/search';
  static const String FILTERED_PRODUCTS = '/api/v1/products/filtered-products';
  static const String CHECK_PASSWORD_URI = '/api/v1/customer/check-password';
  static const String DELETE_ACCOUNT = '/api/v1/customer/delete-account';
  static const String SEND_APP_REVIEW_URI = '/api/v1/customer/app-review';
  static const String CART_LIST_PRODUCTIDS_URI = '/api/v1/customer/cart/product-ids';
  static const String CART_LIST_URI = '/api/v1/customer/cart';
  static const String ADD_CART_URI = '/api/v1/customer/cart/add-to-cart';
  static const String REMOVE_CART_URI = '/api/v1/customer/cart/remove';
  static const String GET_ZONE_URI = '/api/v1/customer/order/get-zone';
  static const String API_KEY = 'AIzaSyDittP8hJ4T6bhdHQv601p0RVlYHN-D_hc'; // TEMPORARY

//// deliveryman chat
  static const String DM_MESSAGE_URI = '/api/v1/customer/dm-message/get';
  static const String DM_SEND_MESSAGE_URI = '/api/v1/customer/dm-message/send';
  static const String DM_SEND_IMAGE_URI = '/api/v1/customer/dm-message/send-image';

  // Shared Key
  static const String THEME = 'theme';
  static const String TOKEN = 'token';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String CART_LIST = 'cart_list';
  static const String USER_PASSWORD = 'user_password';
  static const String USER_ADDRESS = 'user_address';
  static const String USER_EMAIL = 'USER_EMAIL';
  static const String SEARCH_ADDRESS = 'search_address';
  static const String TOPIC = 'notify';
  static const String Specific_TOPIC = 'notify_specific';
  static const String GIFT_PRODUCT = 'gift_product';
  static const String GIFT_CHECK = 'gift_check';
  static const String CURRENCY = '€';
  static const String SAVE_ADDRESS_ID = 'address_id';

  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
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
