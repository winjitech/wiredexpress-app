import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/userinfo_model.dart';
import 'package:wired_express/data/repository/home_repo.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/banner_provider.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/location_provider.dart';
import 'package:wired_express/provider/place_order_provider.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/subscription_provider.dart';
import 'package:wired_express/provider/wishlist_provider.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepo? repo;
  HomeProvider({@required this.repo});

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool status) {
    _loading = status;
    notifyListeners();
  }

  Future<void> loadData(BuildContext context) async {
    final authProvider =
        Provider.of<CustomAuthProvider>(context, listen: false);
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final subscriptionProvider =
        Provider.of<SubscriptionProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final wishListProvider =
        Provider.of<WishListProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final bannerProvider = Provider.of<BannerProvider>(context, listen: false);
    final placeOrder = Provider.of<PlaceOrderProvider>(context, listen: false);
    final location = Provider.of<LocationProvider>(context, listen: false);
    final productProv = Provider.of<ProductProvider>(context, listen: false);
    productProv.clearFeaturedProductsOffset();
    productProv.getFeaturedProducts(context, "1");
    if (authProvider.isLoggedIn()!) {
      UserInfoModel? userInfo = profileProvider.userInfoModel;

      if (userInfo != null) {
        String? subscriptionExpireDate = userInfo.subscriptionExpireDate;
        if (subscriptionExpireDate != null) {
          DateTime expireDate = DateTime.parse(subscriptionExpireDate);
          DateTime now = DateTime.now();
          DateTime yesterday = DateTime(now.year, now.month, now.day)
              .subtract(const Duration(days: 1));

          bool isExpiredYesterday = expireDate.year == yesterday.year &&
              expireDate.month == yesterday.month &&
              expireDate.day == yesterday.day;
          if (isExpiredYesterday) {
            String? subscriptionId =
                userInfo.userSubscription?.paypalSubscriptionId ??
                    userInfo.userSubscription?.stripeSubscriptionId;
            if (subscriptionId != null &&
                userInfo.subscriptionWayType != 'stripe') {
              subscriptionProvider
                  .subscriptionDetails(context, subscriptionId)
                  .then((_) {
                if (subscriptionProvider.subscriptionStatus == "CANCELLED") {
                  subscriptionProvider
                      .cancelSubscription(context, subscriptionId)
                      .then((_) => profileProvider.getUserInfo(context));
                }
              });
            } else if (userInfo.subscriptionWayType == 'stripe') {
              subscriptionProvider.stripeSubscriptionDetails(context).then((_) {
                if (subscriptionProvider.subscriptionStatus == "canceled") {
                  subscriptionProvider
                      .stripeCancelSubscription(context)
                      .then((_) => profileProvider.getUserInfo(context));
                }
              });
            }
          }
        }

        // if (userInfo.freeDelivery == 1) {
        //   _showFreeDeliverySnackBar();
        // }

        if (userInfo.nearbyElectricians == 1 &&
            location.addressList?.isNotEmpty == true) {
          final userAddressId = authProvider.getUserAddressId();
          final matchedAddress = location.addressList!.firstWhere(
            (element) =>
                element.id ==
                (userAddressId == 0
                    ? location.addressList![0].id
                    : userAddressId),
            orElse: () => location.addressList![0],
          );

          splashProvider.getNearbyElectricians(
            context,
            matchedAddress.latitude!,
            matchedAddress.longitude!,
          );
        }
        placeOrder.getPendingInstallmentPayments(context);

        placeOrder.getAwaitingDownPaymentOrderList(context);
      }

      subscriptionProvider.getSubscriptionPlans(context);
      profileProvider.getUserInfo(context);

      location.initAddressList(context);
      wishListProvider.initWishListProductIds(context);
      cartProvider.initCartList(context);
      cartProvider.initCartListProductIds(context);
    }

    categoryProvider.getAllCategories(context, loading: false);
    bannerProvider.getBannerList(context, false);
    placeOrder.getRunningOrderList(context);

    if (placeOrder.runningOrderList?.isNotEmpty ?? false) {
      await placeOrder.runningOrderList!.first;
    }
    //
    // await categoryProvider.getCategoryFeaturedList(context, false).then((_) {
    //   final featuredList = categoryProvider.categoryFeaturedList;
    //   if (featuredList?.isNotEmpty ?? false) {
    //     final firstCategory = featuredList!.first;
    //     categoryProvider.setCategory(firstCategory);
    //     // categoryProvider.clearCategoryProductListOffset();
    //     // categoryProvider.getCategoryProductList(
    //     //     context, "1", firstCategory.id.toString());
    //   }
    // });
  }
}
