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
  List<Product>? _popularProductList;
  bool _isLoading = false;
  int? _popularPageSize;
  List<String> _offsetList = [];
  List<dynamic>? _variationIndex;
  int _quantity = 1;

  List<Product>? get popularProductList => _popularProductList;
  bool get isLoading => _isLoading;
  int? get popularPageSize => _popularPageSize;
  List<dynamic>? get variationIndex => _variationIndex;
  int? get quantity => _quantity;

  void getPopularProductList(BuildContext? context, String offset) async {
    print('productsss 1 --');
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo!.getPopularProductList(offset);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        print('productsss 2 --');
        if (offset == '1') {
          _popularProductList = [];
        }
        _popularProductList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        _popularPageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        print('productsss 3 --');
        ScaffoldMessenger.of(context!).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  List<Product>? _productListWithCategoriesId;

  List<Product>? get productListWithCategoriesId =>
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
            ProductModel.fromJson(apiResponse.response!.data).products!);
        _pageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
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
  // void initDataWithCart(Product product, CartlistModel? cart) {
  //   _variationIndex = [];
  //
  //
  //     _quantity = cart!.quantity!;
  //     List<String> _variationTypes = [];
  //     if(cart.variation![0].type != null) {
  //       _variationTypes.addAll(cart.variation![0].type!.split('-'));
  //     }
  //     int _varIndex = 0;
  //     product.choiceOptions!.forEach((choiceOption) {
  //       for(int index=0; index<choiceOption.options!.length; index++) {
  //         if(choiceOption.options![index].trim().replaceAll(' ', '') == _variationTypes[_varIndex].trim()) {
  //           _variationIndex!.add(index);
  //           break;
  //         }
  //       }
  //       _varIndex++;
  //     });
  //
  // }

  void initData(Product product) {
    _variationIndex = [];
    _quantity = 1;
    product.choiceOptions!.forEach((element) => _variationIndex!.add(0));
  }

  void initCartData(int quantity, List<dynamic> variationIndex) {
    _variationIndex = variationIndex;
    _quantity = quantity;
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = _quantity + 1;
    } else {
      _quantity = _quantity - 1;
    }
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

  // String getVariationType(Product product, List<dynamic> variationIndex){
  //   List<String> _variationList = [];
  //   for (int index = 0;
  //   index < product.choiceOptions!.length;
  //   index++) {
  //     _variationList.add(product.choiceOptions![index]
  //         .options![variationIndex[index]]
  //         .replaceAll(' ', ''));
  //   }
  //   String variationType = '';
  //   bool isFirst = true;
  //   _variationList.forEach((variation) {
  //     if (isFirst) {
  //       variationType = '$variationType$variation';
  //       isFirst = false;
  //     } else {
  //       variationType = '$variationType-$variation';
  //     }
  //   });
  //   return variationType;
  // }

  Variation getVariation(Product product, List<dynamic> variationIndex) {
    List<String> _variationList = [];
    List<Map<String, dynamic>> _variations = [];

    for (int index = 0; index < product.choiceOptions!.length; index++) {
      _variationList.add(product
          .choiceOptions![index].options![variationIndex[index]]
          .replaceAll(' ', ''));
    }

    String variationType = '';
    bool isFirst = true;
    _variationList.forEach((variation) {
      if (isFirst) {
        variationType = '$variationType$variation';
        isFirst = false;
      } else {
        variationType = '$variationType-$variation';
      }
    });

    double price = product.price!;
    String? _url;
    for (Variation variation in product.variations!) {
      if (variation.type == variationType) {
        price = variation.price!;
        break;
      }
    }

    return Variation(type: variationType, price: price);
  }
}
