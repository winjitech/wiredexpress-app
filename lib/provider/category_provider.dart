import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/repository/category_repo.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo? categoryRepo;

  CategoryProvider({@required this.categoryRepo});

  List<CategoryModel>? _categoryListFull;

  List<CategoryModel>? _subCategoryList;
  List<Product>? _categoryProductList;
  CategoryModel? _category;
  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;
  List<CategoryModel>? _categoryFeaturedList;
  List<CategoryModel>? get categoryFeaturedList => _categoryFeaturedList;
  List<CategoryModel>? get categoryListFull => _categoryListFull;

  List<CategoryModel>? get subCategoryList => _subCategoryList;
  List<Product>? get categoryProductList => _categoryProductList;
  CategoryModel? get category => _category;

  int _countPages = 2;
  int get countPages => _countPages;

  bool? _bottomLoading = false;
  bool? get bottomLoading => _bottomLoading;

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

  Future<void> getCategoryListFull(BuildContext? context, bool reload) async {
    if (_categoryListFull == null || reload) {
      ApiResponse apiResponse = await categoryRepo!.getCategoryListFull();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _categoryListFull = [];
        apiResponse.response!.data!.forEach((category) =>
            _categoryListFull!.add(CategoryModel.fromJson(category)));
      } else {
        //  ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  void getCategory(BuildContext? context, String categoryID) async {
    _subCategoryList = null;
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
    _subCategoryList = null;
    ApiResponse apiResponse = await categoryRepo!.getCategory(categoryID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _category = CategoryModel.fromJson(apiResponse.response!.data);
      return _category!;
    } else {
      return CategoryModel();
    }
  }

  void getSubCategoryList(BuildContext? context, String categoryID) async {
    _subCategoryList = null;
    ApiResponse apiResponse =
        await categoryRepo!.getSubCategoryList(categoryID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _subCategoryList = [];
      apiResponse.response!.data.forEach((category) =>
          _subCategoryList!.add(CategoryModel.fromJson(category)));
      getCategoryProductList(context, categoryID);
    } else {
      // ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  bool? _getCategoryLoading = false;
  bool? get getCategoryLoading => _getCategoryLoading;

  void getCategoryProductList(BuildContext? context, String categoryID) async {
    _getCategoryLoading = true;
    _categoryProductList = null;
    notifyListeners();
    ApiResponse apiResponse =
        await categoryRepo!.getCategoryProductList(1, categoryID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _categoryProductList = [];
      apiResponse.response!.data.forEach(
          (category) => _categoryProductList!.add(Product.fromJson(category)));
      _getCategoryLoading = false;

      notifyListeners();

    } else {
      _getCategoryLoading = false;

      ScaffoldMessenger.of(context!)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
  }

  void getCategoryProductListMore(
      BuildContext? context, String categoryID) async {
    _bottomLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await categoryRepo!.getCategoryProductList(_countPages, categoryID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _bottomLoading = false;

      int _productsCount = apiResponse.response!.data.length;
      if (_productsCount > 0) {
        _countPages++;
        print('Count Pages: ${_countPages}');
      }

      apiResponse.response!.data.forEach(
          (category) => _categoryProductList!.add(Product.fromJson(category)));
      if (_productsCount < 50) {}

      notifyListeners();
    } else {
      ScaffoldMessenger.of(context!)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
  }

  // int _selectCategory = -1;
  // int get selectCategory => _selectCategory;
  //
  // updateSelectCategory(int index) {
  //   _selectCategory = index;
  //   notifyListeners();
  // }

  resetPagesCount() {
    _countPages = 2;
    notifyListeners();
  }

  String? _selectedCategory;

  String? get selectedCategory => _selectedCategory;

  //
  // set selectedCategory(String? category) {
  //   _selectedCategory = category;
  //   notifyListeners();
  // }
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
