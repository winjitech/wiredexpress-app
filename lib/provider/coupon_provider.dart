import 'package:flutter/material.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/coupon_model.dart';
import 'package:wired_express/data/repository/coupon_repo.dart';
import 'package:wired_express/helper/api_checker.dart';

class CouponProvider extends ChangeNotifier {
  final CouponRepo? couponRepo;
  CouponProvider({@required this.couponRepo});

  double? _couponDiscountAmount = 0.0;
  double? get couponDiscountAmount => _couponDiscountAmount;

  CouponModel? _couponDiscount;
  CouponModel? get couponDiscount => _couponDiscount;

  bool? _couponListLoading = false;
  bool? get couponListLoading => _couponListLoading;

  bool? _useLoyaltyPoints = false;
  bool? get useLoyaltyPoints => _useLoyaltyPoints;

  double? _useLoyaltyPointsAmount = 0.0;
  double? get useLoyaltyPointsAmount => _useLoyaltyPointsAmount;

  bool? _applyCouponLoading = false;
  bool? get applyCouponLoading => _applyCouponLoading;

  bool? _removeCouponLoading = false;
  bool? get removeCouponLoading => _removeCouponLoading;

  List<CouponModel>? _couponList;
  List<CouponModel>? get couponList => _couponList;

  Future<void> getCouponList(BuildContext? context) async {
    _couponListLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await couponRepo!.getCouponList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _couponListLoading = false;
      _couponList = [];
      apiResponse.response!.data!.forEach(
          (category) => _couponList!.add(CouponModel.fromJson(category)));
      notifyListeners();
    } else {
      _couponListLoading = false;
      notifyListeners();

      ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future<double> applyCoupon(String coupon, double orderAmount) async {
    _applyCouponLoading = true;
    notifyListeners();
    print('orderAmount -- $orderAmount');
    ApiResponse apiResponse = await couponRepo!.applyCoupon(coupon);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _couponDiscount = CouponModel.fromJson(apiResponse.response!.data);
      _couponDiscountAmount =
          Helpers.applyDiscount(_couponDiscount!, orderAmount);
      _applyCouponLoading = false;
      notifyListeners();
    } else {
      print(apiResponse.error.toString());
      _couponDiscountAmount = 0.0;
      _applyCouponLoading = false;
      notifyListeners();
    }

    return _couponDiscountAmount!;
  }

  void removeCouponData(bool notify) {
    _couponDiscount = null;
    _removeCouponLoading = false;
    _couponDiscountAmount = 0.0;
    if (notify) {
      notifyListeners();
    }
  }

  void applyUseLoyaltyPoints(double discount) {
    _useLoyaltyPointsAmount = discount;

    _useLoyaltyPoints = true;
    notifyListeners();
  }

  void removeUseLoyaltyPoints() {
    _useLoyaltyPoints = false;
    _useLoyaltyPointsAmount = 0.0;
    notifyListeners();
  }
}
