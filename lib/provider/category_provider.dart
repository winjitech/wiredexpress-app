import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/userinfo_model.dart';
import 'package:wired_express/data/repository/category_repo.dart';
import 'package:wired_express/helper/api_checker.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo? categoryRepo;

  CategoryProvider({@required this.categoryRepo});

  // List<ProductModel>? _categoryProductList;
  CategoryModel? _category;
  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;
  List<CategoryModel>? _categoryFeaturedList;
  List<CategoryModel>? get categoryFeaturedList => _categoryFeaturedList;

  // List<ProductModel>? get categoryProductList => _categoryProductList;
  CategoryModel? get category => _category;

  // int _countPages = 2;
  // int get countPages => _countPages;
  //
  // bool? _bottomLoading = false;
  // bool? get bottomLoading => _bottomLoading;

  Future<void> getCategoryList(BuildContext? context, bool reload) async {
    if (_categoryList == null || reload) {
      ApiResponse apiResponse = await categoryRepo!.getCategoryList();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _categoryList = [];
        apiResponse.response!.data.forEach(
            (category) => _categoryList!.add(CategoryModel.fromJson(category)));
      } else {
        // ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  Future<void> getCategoryFeaturedList(
      BuildContext? context, bool reload) async {
    if (_categoryFeaturedList == null || reload) {
      ApiResponse apiResponse = await categoryRepo!.getCategoryFeaturedList();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _categoryFeaturedList = [];
        apiResponse.response!.data.forEach((category) =>
            _categoryFeaturedList!.add(CategoryModel.fromJson(category)));
      } else {
        _categoryFeaturedList = [];
        // ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  void getCategory(BuildContext? context, String categoryID) async {
    ApiResponse apiResponse = await categoryRepo!.getCategory(categoryID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _category = CategoryModel.fromJson(apiResponse.response!.data);
    } else {
      // ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<CategoryModel> getCategoryByID(
      BuildContext? context, String categoryID) async {
    ApiResponse apiResponse = await categoryRepo!.getCategory(categoryID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _category = CategoryModel.fromJson(apiResponse.response!.data);
      return _category!;
    } else {
      return CategoryModel();
    }
  }

  int? _totalCategoryProductListSize;
  int? get totalCategoryProductListSize => _totalCategoryProductListSize;

  String? _categoryProductListOffset;
  String? get categoryProductListOffset => _categoryProductListOffset;

  List<ProductModel>? _categoryProductList = [];
  List<ProductModel>? get categoryProductList => _categoryProductList;

  List<String> _categoryProductListOffsetList = [];

  bool _categoryProductListIsLoading = false;
  bool get categoryProductListIsLoading => _categoryProductListIsLoading;

  bool _bottomCategoryProductListLoading = false;
  bool get bottomCategoryProductListLoading =>
      _bottomCategoryProductListLoading;
  Future<void> getCategoryProductList(
      BuildContext context, String offset, String categoryID) async {
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

    // print('tip 1 ---');
    if (offset == '1') {
      _categoryProductList = null;
      _categoryProductListIsLoading = true;
    }
    if (!_categoryProductListOffsetList.contains(offset)) {
      // print('tip 2 ---');
      _categoryProductListOffsetList.add(offset);
      ApiResponse apiResponse = await categoryRepo!.getCategoryProductList(
          offset, categoryID,
          showEarlyAccess: showProductsEarlyAccess);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _bottomCategoryProductListLoading = false;

        if (offset == '1') {
          _categoryProductList = [];
        }
        _totalCategoryProductListSize =
            ProductBody.fromJson(apiResponse.response!.data).totalSize;
        _categoryProductList!
            .addAll(ProductBody.fromJson(apiResponse.response!.data).products!);
        _categoryProductListOffset =
            ProductBody.fromJson(apiResponse.response!.data).offset;
        _categoryProductListIsLoading = false;
      } else {
        ApiChecker.checkApi(context, apiResponse);

        _bottomCategoryProductListLoading = false;
        _categoryProductListIsLoading = false;
        print('error message -- one ${apiResponse.error.toString()}');
      }
    } else {
      if (_categoryProductListIsLoading) {
        _bottomCategoryProductListLoading = false;
        _categoryProductListIsLoading = false;
      }
    }
    notifyListeners();
  }

  void clearCategoryProductListOffset() {
    // if (_categoryProductList != null) {
    _categoryProductListOffsetList.clear();
    _categoryProductList!.clear();
    // }

    notifyListeners();
  }

  void showBottomCategoryProductListLoader() {
    _bottomCategoryProductListLoading = true;
    notifyListeners();
  }

  CategoryModel? _selectedCategory;

  CategoryModel? get selectedCategory => _selectedCategory;

  void setCategory(CategoryModel category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
