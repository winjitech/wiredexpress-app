import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/repository/search_repo.dart';

class SearchProvider with ChangeNotifier {
  final SearchRepo? searchRepo;
  SearchProvider({@required this.searchRepo});

  List<String> _historyList = [];


  List<String> get historyList => _historyList;

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  CategoryModel? _selectedCategory;
  CategoryModel? get selectedCategory => _selectedCategory;

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
    notifyListeners();

    ApiResponse apiResponse = await searchRepo!.getSearchProductList(query);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (query.isEmpty) {
        _searchProductList = [];
      } else {
        _searchProductList = [];
        _searchProductList!.addAll(
            ProductModel.fromJson(apiResponse.response!.data).products!);
        // _filterProductList = [];
        // _filterProductList.addAll(ProductModel.fromJson(apiResponse.response!.data).products);
      }
      notifyListeners();
    } else {
      //  ApiChecker.checkApi(context, apiResponse);
    }
  }

  void setCategory(CategoryModel category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void filteredProducts(String type, String problem, String serviceId,
      BuildContext? context) async {
    ApiResponse apiResponse =
        await searchRepo!.filteredProducts(type, problem, serviceId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _filterProductList = [];
      _filterProductList!
          .addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
    } else {
      //  ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future<void> sendSearch(String search) async {
    ApiResponse apiResponse = await searchRepo!.sendSearch(search);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
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
}
