import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/userinfo_model.dart';
import 'package:wired_express/data/repository/search_repo.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';

class SearchProvider with ChangeNotifier {
  final SearchRepo? searchRepo;
  SearchProvider({@required this.searchRepo});

  List<String> _historyList = [];

  List<String> get historyList => _historyList;

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  CategoryModel? _selectedCategory;
  CategoryModel? get selectedCategory => _selectedCategory;

  List<ProductModel>? _searchProductList;
  bool _isClear = true;
  String _searchText = '';

  List<ProductModel>? get searchProductList => _searchProductList;


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
    int showProductsEarlyAccess = 0;
    final authProvider =
        Provider.of<CustomAuthProvider>(context!, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    bool isLoggedIn = authProvider.isLoggedIn() ?? false;
    UserInfoModel? userInfo = profileProvider.userInfoModel;

    if (isLoggedIn && userInfo != null && userInfo.productsEarlyAccess == 1) {
      print("productsEarlyAccess === ${userInfo.productsEarlyAccess == 1}");
      showProductsEarlyAccess = 1;
    }
    _searchText = query;
    _isClear = false;
    _searchProductList = null;
    _rating = -1;
    notifyListeners();

    ApiResponse apiResponse = await searchRepo!
        .getSearchProductList(query, showEarlyAccess: showProductsEarlyAccess);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (query.isEmpty) {
        _searchProductList = [];
      } else {
        _searchProductList = [];
        _searchProductList!
            .addAll(ProductBody.fromJson(apiResponse.response!.data).products!);
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
