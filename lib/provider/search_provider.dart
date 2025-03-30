import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/brands_model.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/repository/search_repo.dart';

class SearchProvider with ChangeNotifier {
  final SearchRepo? searchRepo;
  SearchProvider({@required this.searchRepo});

  int _filterIndex = 0;
  double _lowerValue = 0;
  double _upperValue = 0;
  List<String> _historyList = [];

  int get filterIndex => _filterIndex;
  double get lowerValue => _lowerValue;
  double get upperValue => _upperValue;

  List<String> get historyList => _historyList;

  /// BRANDS
  List<Brand>? _brandsList;
  List<Brand>? get brandsList => _brandsList;

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  Brand? _selectedBrand;
  Brand? get selectedBrand => _selectedBrand;

  CategoryModel? _selectedCategory;
  CategoryModel? get selectedCategory => _selectedCategory;

  bool _brandsLoading = false;
  bool get brandsLoading => _brandsLoading;

  bool _bottomLoading = false;
  bool get bottomLoading => _bottomLoading;

  List<Product> _brandProductsList = [];
  List<Product> get brandProductsList => _brandProductsList;

  int? _totalBrandProductsSize;
  int? get totalBrandProductsSize => _totalBrandProductsSize;

  String? _brandOffset;
  String? get brandOffset => _brandOffset;

  List<String> _brandsOffsetList = [];

  void setFilterIndex(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  void setLowerAndUpperValue(double lower, double upper) {
    _lowerValue = lower;
    _upperValue = upper;
    notifyListeners();
  }

  void sortSearchList(int categoryIndex, List<CategoryModel> categoryList) {
    _searchProductList= [];
    _searchProductList!.addAll(_filterProductList!);
    if(_upperValue > 0) {
      _searchProductList!.removeWhere((product) => (product.price) !<= _lowerValue || (product.price) !>= _upperValue);
    }
    if(categoryIndex != -1) {
      int categoryID = categoryList[categoryIndex].id!;
      _searchProductList!.removeWhere((product) {
        List<String> _ids = [];
        product.categoryIds!.forEach((element) => _ids.add(element.id!));
        return !_ids.contains(categoryID.toString());
      });
    }
    if(_rating != -1) {
      _searchProductList!.removeWhere((product) => product.rating == null || product.rating!.length == 0 || double.parse(product.rating![0].average!) < _rating);
    }
    notifyListeners();
  }

  List<Product>? _searchProductList;
  List<Product>? _filterProductList;
  bool _isClear = true;
  String _searchText = '';

  List<Product>? get searchProductList => _searchProductList;

  List<Product>? get filterProductList => _filterProductList;

  bool get isClear => _isClear;

  String get searchText => _searchText;

  void setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  void cleanSearchProduct() {
    _searchProductList = [];
    _isClear = true;
    _searchText = '';
    notifyListeners();
  }

  void searchProduct(String query, BuildContext? context) async {
    _searchText = query;
    _isClear = false;
    _searchProductList = null;
    _filterProductList = null;
    _rating = -1;
    _upperValue = 0;
    _lowerValue = 0;
    notifyListeners();

    ApiResponse apiResponse = await searchRepo!.getSearchProductList(query);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if (query.isEmpty) {
        _searchProductList = [];
      } else {
        _searchProductList = [];
        _searchProductList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        // _filterProductList = [];
        // _filterProductList.addAll(ProductModel.fromJson(apiResponse.response!.data).products);
      }
      notifyListeners();
    } else {
    //  ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future<void> getBrandCategories(BuildContext? context, String brandId) async {
    _brandsLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await searchRepo!.getBrandsCategories(brandId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _brandsLoading = false;
      _categoryList = [];
      apiResponse.response!.data.forEach(
              (category) => _categoryList!.add(CategoryModel.fromJson(category)));
      notifyListeners();
    } else {
      _brandsLoading = false;
      //  ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future<void> getBrands(BuildContext? context) async {
    _brandsLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await searchRepo!.getBrands();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      _brandsLoading = false;
         _brandsList = [];
         apiResponse.response!.data.forEach(
                 (brand) => _brandsList!.add(Brand.fromJson(brand)));

      notifyListeners();
    } else {
      _brandsLoading = false;
      //  ApiChecker.checkApi(context, apiResponse);
    }
  }


  void setBrand(Brand item) {
    _selectedBrand = item;
    _selectedCategory = null;
    notifyListeners();
  }

  void setCategory(CategoryModel category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void filteredProducts(String type,String problem,String serviceId, BuildContext? context) async {
    ApiResponse apiResponse = await searchRepo!.filteredProducts(type, problem, serviceId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _filterProductList = [];
      _filterProductList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);

    } else {
      //  ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future<void> sendSearch(String search) async {
    ApiResponse apiResponse = await searchRepo!.sendSearch(search);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      print('-------- Sent successfully--------');
    } else {
      print('-------- Failed--------');
    }
    notifyListeners();
  }

  void initHistoryList() {
    _historyList = [];
    _historyList.addAll(searchRepo!.getSearchAddress());
  }

  void saveSearchAddress(String searchAddress) async {
    if (!_historyList.contains(searchAddress)) {
      _historyList.add(searchAddress);
      searchRepo!.saveSearchAddress(searchAddress);
      notifyListeners();
    }
  }

  void clearSearchAddress() async {
    searchRepo!.clearSearchAddress();
    _historyList = [];
    notifyListeners();
  }

  int _rating = -1;

  int get rating => _rating;

  void setRating(int rate) {
    _rating = rate;
    notifyListeners();
  }

  Future<void> getBrandsProductsList(BuildContext? context, String offset, String brandId, String categoryId) async {

    if(offset == '1'){
      _brandsLoading = true;
    }

    if (!_brandsOffsetList.contains(offset)) {
      _brandsOffsetList.add(offset);
      ApiResponse apiResponse = await searchRepo!.getBrandProducts(offset, brandId, categoryId);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _bottomLoading = false;

        if (offset == '1') {
          _brandProductsList = [];
        }
        _totalBrandProductsSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _brandProductsList.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        _brandOffset = ProductModel.fromJson(apiResponse.response!.data).offset;
        _brandsLoading = false;
      } else {
        _bottomLoading = false;
        _brandsLoading = false;
        ScaffoldMessenger.of(context!).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      }
    } else {
      if(_brandsLoading) {
        _bottomLoading = false;
        _brandsLoading = false;
        //notifyListeners();
      }
    }
    notifyListeners();
  }

  void clearOffset() {
    _brandsOffsetList = [];
    _brandProductsList = [];
    notifyListeners();
  }

  void showBottomLoader() {
    _bottomLoading = true;
    notifyListeners();
  }
}
