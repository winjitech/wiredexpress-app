import 'package:flutter/material.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/coupon_model.dart';
import 'package:wired_express/data/repository/coupon_repo.dart';

class CouponProvider extends ChangeNotifier {
  final CouponRepo? couponRepo;
  CouponProvider({@required this.couponRepo});

  List<CouponModel>? _couponList;
  CouponModel? _coupon;
  double? _discount = 0.0;
  bool? _isLoading = false;

  CouponModel? get coupon => _coupon;
  double? get discount => _discount;
  bool? get isLoading => _isLoading;
  List<CouponModel>? get couponList => _couponList;

  Future<void> getCouponList(BuildContext? context) async {
    _isLoading = true;
    ApiResponse apiResponse = await couponRepo!.getCouponList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      _couponList = [];
      apiResponse.response!.data!.forEach(
          (category) => _couponList!.add(CouponModel.fromJson(category)));
      notifyListeners();
    } else {
      //  ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future<double> applyCoupon(String coupon, double orderAmount) async {
    _isLoading = true;
    notifyListeners();
    print('orderrrr 1-- ${orderAmount}');
    ApiResponse apiResponse = await couponRepo!.applyCoupon(coupon);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _coupon = CouponModel.fromJson(apiResponse.response!.data);
      _discount = Helpers.applyDiscount(_coupon!, orderAmount);
    } else {
      print(apiResponse.error.toString());
      _discount = 0.0;
    }
    _isLoading = false;
    notifyListeners();
    return _discount!;
  }

  void removeCouponData(bool notify) {
    _coupon = null;
    _isLoading = false;
    _discount = 0.0;
    if (notify) {
      notifyListeners();
    }
  }
}
