import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/order_details_model.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/data/model/body/review_body_model.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/data/model/response/userinfo_model.dart';
import 'package:wired_express/data/repository/product_repo.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo? repo;

  ProductProvider({@required this.repo});
  bool _isLoading = false;
  int? _popularPageSize;
  List<String> _offsetList = [];
  List<dynamic>? _variationIndex;
  int _quantity = 1;
  int? get quantity => _quantity;

  bool get isLoading => _isLoading;
  int? get popularPageSize => _popularPageSize;
  List<dynamic>? get variationIndex => _variationIndex;

  bool _productDetailsLoading = false;
  bool get productDetailsLoading => _productDetailsLoading;
  ProductModel? _productDetailsModel;
  ProductModel? get productDetailsModel => _productDetailsModel;
  Future<ResponseModel> getProductDetails(
      BuildContext? context, int productId) async {
    _productDetailsLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    ApiResponse apiResponse = await repo!.getProductDetails(productId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _productDetailsModel = ProductModel.fromJson(apiResponse.response!.data);
      _responseModel = ResponseModel(true, 'successful');
      _productDetailsLoading = false;
      notifyListeners();
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      _responseModel = ResponseModel(false, _errorMessage);
      _productDetailsLoading = false;
      notifyListeners();
    }
    notifyListeners();
    return _responseModel;
  }

  List<ProductModel>? _productListWithCategoriesId;

  List<ProductModel>? get productListWithCategoriesId =>
      _productListWithCategoriesId;
  int? _pageSize;
  int? get pageSize => _pageSize;

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void initCartData(int quantity, List<dynamic> variationIndex) {
    _variationIndex = variationIndex;
    _quantity = quantity;
  }

  void setQuantity(int quantity) {
    _quantity = quantity;
    notifyListeners();
  }

  void setCartVariationIndex(int index, int i) {
    _variationIndex![index] = i;
    notifyListeners();
  }

  List<int> _ratingList = [];
  List<String> _reviewList = [];
  List<bool> _loadingList = [];
  List<bool> _submitList = [];
  int _deliveryManRating = 0;

  List<int> get ratingList => _ratingList;
  List<String> get reviewList => _reviewList;
  List<bool> get loadingList => _loadingList;
  List<bool> get submitList => _submitList;
  int get deliveryManRating => _deliveryManRating;

  void initRatingData(List<OrderDetailsModel> orderDetailsList) {
    _ratingList = [];
    _reviewList = [];
    _loadingList = [];
    _submitList = [];
    _deliveryManRating = 0;
    orderDetailsList.forEach((orderDetails) {
      _ratingList.add(0);
      _reviewList.add('');
      _loadingList.add(false);
      _submitList.add(false);
    });
  }

  void setRating(int index, int rate) {
    _ratingList[index] = rate;
    notifyListeners();
  }

  void setReview(int index, String review) {
    _reviewList[index] = review;
  }

  void setDeliveryManRating(int rate) {
    _deliveryManRating = rate;
    notifyListeners();
  }

  Future<ResponseModel> submitReview(int index, ReviewBody reviewBody) async {
    _loadingList[index] = true;
    notifyListeners();

    ApiResponse response = await repo!.submitReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response!.statusCode == 200) {
      _submitList[index] = true;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      notifyListeners();
    } else {
      String errorMessage;
      if (response.error is String) {
        errorMessage = response.error.toString();
      } else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _loadingList[index] = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> submitDeliveryManReview(ReviewBody reviewBody) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await repo!.submitDeliveryManReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response!.statusCode == 200) {
      _deliveryManRating = 0;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      notifyListeners();
    } else {
      String errorMessage;
      if (response.error is String) {
        errorMessage = response.error.toString();
      } else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  int? _totalFeaturedProductsSize;
  int? get totalFeaturedProductsSize => _totalFeaturedProductsSize;

  String? _featuredProductsOffset;
  String? get featuredProductsOffset => _featuredProductsOffset;

  List<ProductModel>? _featuredProductsList = [];
  List<ProductModel>? get featuredProductsList => _featuredProductsList;

  List<String> _featuredProductsOffsetList = [];

  bool _featuredProductsIsLoading = false;
  bool get featuredProductsIsLoading => _featuredProductsIsLoading;

  bool _bottomFeaturedProductsLoading = false;
  bool get bottomFeaturedProductsLoading => _bottomFeaturedProductsLoading;
  Future<void> getFeaturedProducts(
    BuildContext context,
    String offset, {
    bool loading = true,
  }) async {
    print("API START");
    if (offset == '1') {
      _featuredProductsIsLoading = true;
    }
    int showProductsEarlyAccess = 0;
    final authProvider =
        Provider.of<CustomAuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    bool isLoggedIn = authProvider.isLoggedIn() ?? false;
    UserInfoModel? userInfo = profileProvider.userInfoModel;

    if (isLoggedIn && userInfo != null && userInfo.productsEarlyAccess == 1) {
      print("productsEarlyAccess === ${userInfo.productsEarlyAccess == 1}");
      showProductsEarlyAccess = 1;
    }
    if (!_featuredProductsOffsetList.contains(offset)) {
      _featuredProductsOffsetList.add(offset);
      ApiResponse apiResponse = await repo!.getFeaturedProducts(offset,
          showEarlyAccess: showProductsEarlyAccess);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        print("API DONE");
        _bottomFeaturedProductsLoading = false;

        if (offset == '1') {
          _featuredProductsList = [];
        }
        ProductBody body = ProductBody.fromJson(apiResponse.response!.data);

        _totalFeaturedProductsSize = body.totalSize;

        _featuredProductsList!.addAll(body.products ?? []);

        _featuredProductsOffset = body.offset;
        _featuredProductsIsLoading = false;
        print(featuredProductsList?.length);
      } else {
        _bottomFeaturedProductsLoading = false;
        _featuredProductsIsLoading = false;
      }
    } else {
      if (_featuredProductsIsLoading) {
        _bottomFeaturedProductsLoading = false;
        _featuredProductsIsLoading = false;
        notifyListeners();
      }
    }
    notifyListeners();
  }

  void clearFeaturedProductsOffset() {
    _featuredProductsOffsetList.clear();
    _featuredProductsList!.clear();
    notifyListeners();
  }

  void showBottomFeaturedProductsLoader() {
    _bottomFeaturedProductsLoading = true;
    notifyListeners();
  }
}
