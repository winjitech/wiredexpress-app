import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/banner_model.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/data/repository/banner_repo.dart';

class BannerProvider extends ChangeNotifier {
  final BannerRepo? bannerRepo;
  BannerProvider({@required this.bannerRepo});

  List<BannerModel>? _bannerList = [];
  List<BannerModel>? get bannerList => _bannerList;

  bool _bannerListIsLoading = false;
  bool get bannerListIsLoading => _bannerListIsLoading;

  Future<ResponseModel> getBannerList(
      BuildContext? context, bool reload) async {
    if (_bannerList == null || _bannerList!.isEmpty || reload) {
      _bannerListIsLoading = true;
      notifyListeners();

      ResponseModel responseModel;

      ApiResponse apiResponse = await bannerRepo!.getBannerList();

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _bannerList = [];

        apiResponse.response!.data.forEach((item) {
          BannerModel bannerModel = BannerModel.fromJson(item);

          if (bannerModel.productId != null) {
            getProductDetails(context, bannerModel.productId.toString());
          }

          _bannerList!.add(bannerModel);
        });

        responseModel = ResponseModel(true, 'successful');
      } else {
        String errorMessage;

        if (apiResponse.error is String) {
          errorMessage = apiResponse.error.toString();
        } else {
          errorMessage = apiResponse.error.errors[0].message;
        }

        responseModel = ResponseModel(false, errorMessage);
      }

      _bannerListIsLoading = false;
      notifyListeners();

      return responseModel;
    }

    return ResponseModel(true, 'successful');
  }

  List<ProductModel>? _productList = [];
  List<ProductModel>? get productList => _productList;

  bool _productDetailsIsLoading = false;
  bool get productDetailsIsLoading => _productDetailsIsLoading;

  Future<ResponseModel> getProductDetails(
      BuildContext? context, String productID) async {
    _productDetailsIsLoading = true;
    notifyListeners();

    ResponseModel responseModel;

    ApiResponse apiResponse = await bannerRepo!.getProductDetails(productID);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _productList ??= [];
      _productList!.add(ProductModel.fromJson(apiResponse.response!.data));

      responseModel = ResponseModel(true, 'successful');
    } else {
      String errorMessage;

      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }

      responseModel = ResponseModel(false, errorMessage);

      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }

    _productDetailsIsLoading = false;
    notifyListeners();

    return responseModel;
  }
}
