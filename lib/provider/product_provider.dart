import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/order_details_model.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/data/model/body/review_body_model.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/data/repository/product_repo.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo? productRepo;

  ProductProvider({@required this.productRepo});

  // Latest products
  List<ProductModel>? _popularProductList;
  bool _isLoading = false;
  int? _popularPageSize;
  List<String> _offsetList = [];
  List<dynamic>? _variationIndex;
  int _quantity = 1;

  List<ProductModel>? get popularProductList => _popularProductList;
  bool get isLoading => _isLoading;
  int? get popularPageSize => _popularPageSize;
  List<dynamic>? get variationIndex => _variationIndex;
  int? get quantity => _quantity;

  void getPopularProductList(BuildContext? context, String offset) async {
    print('productsss 1 --');
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse =
          await productRepo!.getPopularProductList(offset);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        print('productsss 2 --');
        if (offset == '1') {
          _popularProductList = [];
        }
        _popularProductList!.addAll(
            ProductBody.fromJson(apiResponse.response!.data).products!);
        _popularPageSize =
            ProductBody.fromJson(apiResponse.response!.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        print('productsss 3 --');
        ScaffoldMessenger.of(context!).showSnackBar(
            SnackBar(content: Text(apiResponse.error.toString())));
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
  bool _productDetailsLoading = false;
  bool get productDetailsLoading => _productDetailsLoading;
  ProductModel? _productDetailsModel;
  ProductModel? get productDetailsModel => _productDetailsModel;
  Future<ResponseModel> getProductDetails(
      BuildContext? context, int productId) async {
    _productDetailsLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    ApiResponse apiResponse = await productRepo!.getProductDetails(productId);
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

  //////////////////////////////////////////////////////////////////////////////

  //di htkon function tb3 el filter widget eli f el shopping screen
  void getProductList(
      BuildContext? context, String offset, int categoryId) async {
    print('productsss 1 --');
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse =
          await productRepo!.getProductList(offset, categoryId);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        print('productsss 2 --');
        if (offset == '1') {
          _productListWithCategoriesId = [];
        }
        _productListWithCategoriesId!.addAll(
            ProductBody.fromJson(apiResponse.response!.data).products!);
        _pageSize = ProductBody.fromJson(apiResponse.response!.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        print('productsss 3 --');
        ScaffoldMessenger.of(context!).showSnackBar(
            SnackBar(content: Text(apiResponse.error.toString())));
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

///////////////////////////////////////////////////////////////////////////////
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

    ApiResponse response = await productRepo!.submitReview(reviewBody);
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
    ApiResponse response =
        await productRepo!.submitDeliveryManReview(reviewBody);
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
}
