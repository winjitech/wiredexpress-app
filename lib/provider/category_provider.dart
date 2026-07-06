import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/data/model/response/userinfo_model.dart';
import 'package:wired_express/data/repository/category_repo.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo? repo;

  CategoryProvider({@required this.repo});

  List<CategoryModel>? _allCategoriesList;
  List<CategoryModel>? get allCategoriesList => _allCategoriesList;
  bool? _allCategoriesListLoading = false;
  bool? get allCategoriesListLoading => _allCategoriesListLoading;

  Future<ResponseModel> getAllCategories(
    BuildContext? context, {
    bool? loading = true,
  }) async {
    if (loading!) {
      _allCategoriesListLoading = true;
    }
    notifyListeners();
    ResponseModel _responseModel;
    ApiResponse apiResponse = await repo!.getAllCategories();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _allCategoriesList = [];

      _allCategoriesList!.add(
        CategoryModel(
          id: -1,
          name: 'contractor_zone',
        ),
      );

      for (var item in apiResponse.response!.data!) {
        CategoryModel itemModel = CategoryModel.fromJson(item);

        bool exists = _allCategoriesList!.any(
          (e) => e.name == itemModel.name,
        );

        if (!exists) {
          _allCategoriesList!.add(itemModel);
        }
      }

      _responseModel = ResponseModel(true, 'successful');
      _allCategoriesListLoading = false;
      notifyListeners();
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      _responseModel = ResponseModel(false, _errorMessage);
      _allCategoriesListLoading = false;
      notifyListeners();
    }
    notifyListeners();
    return _responseModel;
  }

  CategoryModel? _selectedSubCat;
  CategoryModel? get selectedSubCat => _selectedSubCat;
  void setSelectedSubCat(CategoryModel? subCat) {
    _selectedSubCat = subCat;
    notifyListeners();
  }

  void clearSelectedSubCat() {
    _selectedSubCat = null;
    notifyListeners();
  }

  List<CategoryModel>? _subCategoriesList;
  List<CategoryModel>? get subCategoriesList => _subCategoriesList;
  bool? _subCategoriesListLoading = false;
  bool? get subCategoriesListLoading => _subCategoriesListLoading;

  Future<ResponseModel> getSubCategories(
    BuildContext? context,
    int catId, {
    bool? loading = true,
  }) async {
    if (loading!) {
      _subCategoriesListLoading = true;
    }
    notifyListeners();
    ResponseModel _responseModel;
    ApiResponse apiResponse = await repo!.getSubCategories(catId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _subCategoriesList = [];

      apiResponse.response!.data!.forEach((item) {
        CategoryModel itemModel = CategoryModel.fromJson(item);
        _subCategoriesList!.add(itemModel);
      });
      _responseModel = ResponseModel(true, 'successful');
      _subCategoriesListLoading = false;
      notifyListeners();
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      _responseModel = ResponseModel(false, _errorMessage);
      _subCategoriesListLoading = false;
      notifyListeners();
    }
    notifyListeners();
    return _responseModel;
  }

  int? _totalProductsSize;
  int? get totalProductsSize => _totalProductsSize;

  String? _productByCategoryOffset;
  String? get productByCategoryOffset => _productByCategoryOffset;

  List<ProductModel>? _productByCategoryList = [];
  List<ProductModel>? get productByCategoryList => _productByCategoryList;

  List<String> _productByCategoryOffsetList = [];

  bool _productByCategoryIsLoading = false;
  bool get productByCategoryIsLoading => _productByCategoryIsLoading;

  bool _bottomProductByCategoryLoading = false;
  bool get bottomProductByCategoryLoading => _bottomProductByCategoryLoading;
  Future<void> getProductsByCategory(
    BuildContext context,
    String offset, {
    required int categoryId,
    int? subcategoryId,
    bool loading = true,
  }) async {
    if (offset == '1') {
      _productByCategoryIsLoading = true;
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
    if (!_productByCategoryOffsetList.contains(offset)) {
      _productByCategoryOffsetList.add(offset);
      ApiResponse apiResponse = await repo!.getProductsByCategory(offset,
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          showEarlyAccess: showProductsEarlyAccess);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _bottomProductByCategoryLoading = false;

        if (offset == '1') {
          _productByCategoryList = [];
        }

        _totalProductsSize = ProductBody.fromJson(
          apiResponse.response!.data,
        ).totalSize;
        _productByCategoryList!.addAll(
          ProductBody.fromJson(apiResponse.response!.data).products!,
        );
        _productByCategoryOffset = ProductBody.fromJson(
          apiResponse.response!.data,
        ).offset;
        _productByCategoryIsLoading = false;
      } else {
        _bottomProductByCategoryLoading = false;
        _productByCategoryIsLoading = false;
      }
    } else {
      if (_productByCategoryIsLoading) {
        _bottomProductByCategoryLoading = false;
        _productByCategoryIsLoading = false;
        notifyListeners();
      }
    }
    notifyListeners();
  }

  void clearProductsOffset() {
    _productByCategoryOffsetList.clear();
    _productByCategoryList!.clear();
    notifyListeners();
  }

  void showBottomProductsLoader() {
    _bottomProductByCategoryLoading = true;
    notifyListeners();
  }
}
