import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/model/response/wishlist_model.dart';
import 'package:wired_express/data/repository/product_repo.dart';
import 'package:wired_express/data/repository/wishlist_repo.dart';
import 'package:wired_express/helper/api_checker.dart';

class WishListProvider extends ChangeNotifier {
  final WishListRepo? wishListRepo;
  final ProductRepo? productRepo;
  WishListProvider({@required this.wishListRepo, @required this.productRepo});

  List<WishlistModel> _wishList = [];
  List<WishlistModel> get wishList => _wishList;
  bool _loading = false;
  bool get loading => _loading;

  List<int> _wishIdList = [];
  List<int> get wishIdList => _wishIdList;

  Future<void> initWishList(BuildContext context) async {
    _loading = true;
    notifyListeners();

    try {
      ApiResponse apiResponse = await wishListRepo!.getWishList();

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _wishList = [];

        if (apiResponse.response!.data != null) {
          if (apiResponse.response!.data is List) {
         //   List<dynamic> data = apiResponse.response!.data as List<dynamic>;
            apiResponse.response!.data.forEach((item) {
              _wishList.add(WishlistModel.fromJson(item));
            });
            print('wishlist => ${_wishIdList}');
          } else {

          }
        }

        _loading = false;
      } else {
        _loading = false;
        print('Api error: ${apiResponse.error.toString()}');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(apiResponse.error.toString())),
        // );
      }
    } catch (error) {
      _loading = false;
      print("Error occurred: $error");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Error occurred: $error")),
      // );
    }
    notifyListeners();
  }


  Future<void> initWishListProductIds(BuildContext context, [bool fromSplash = false]) async {
    _loading = true;
    if(fromSplash){
      notifyListeners();
    }

    try {
      ApiResponse apiResponse = await wishListRepo!.getWishListProductIds();

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _wishIdList = [];

        if (apiResponse.response!.data != null) {
          if (apiResponse.response!.data is List) {
            apiResponse.response!.data.forEach((item) {
              _wishIdList.add(item);
            });
          } else {
            print("Data is not a List. Value: ${apiResponse.response!.data}");
          }
        }
        _loading = false;
      } else {
        _loading = false;
        print('Api error: ${apiResponse.error.toString()}');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(apiResponse.error.toString())),
        // );
      }
    } catch (error) {
      _loading = false;
      print("Error occurred: $error");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Error occurred: $error")),
      // );
    }
    notifyListeners();
  }


  void addToWishList(Product product, Function feedbackMessage) async {
    ApiResponse apiResponse = await wishListRepo!.addWishList(product.id!);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
     Map map = apiResponse.response!.data;
     String message = map['message'];
     print('message => ${message}');
     feedbackMessage(message);
      //_wishList.add(WishlistModel.fromJson(apiResponse.response!.data));
      _wishIdList.add(product.id!);
    } else {
      feedbackMessage('${apiResponse.error.toString()}');
      print('${apiResponse.error.toString()}');
    }
    notifyListeners();
  }

  void removeFromWishList(Product product, Function feedbackMessage) async {
    ApiResponse apiResponse = await wishListRepo!.removeWishList(product.id!);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String message = map['message'];
      feedbackMessage(message);
      int _idIndex = _wishIdList.indexOf(product.id!);
      _wishIdList.removeAt(_idIndex);
    //  _wishList.removeAt(_idIndex);
    } else {
      print('${apiResponse.error.toString()}');
      feedbackMessage('${apiResponse.error.toString()}');
    }
    notifyListeners();
  }


  // Future<void> initWishList(BuildContext? context) async {
  //   _loading = true;
  //   _wishList = [];
  //   _wishIdList = [];
  //   ApiResponse apiResponse = await wishListRepo!.getWishList();
  //   if (apiResponse.response != null &&
  //       apiResponse.response!.statusCode == 200) {
  //     notifyListeners();
  //     apiResponse.response!.data!.forEach((wishList) async {
  //       ApiResponse productResponse = await productRepo!.searchProduct(
  //           WishListModel.fromJson(wishList).productId.toString());
  //       if (productResponse.response != null &&
  //           productResponse.response!.statusCode == 200) {
  //         Product _product = Product.fromJson(productResponse.response!.data);
  //         _wishList!.add(_product);
  //         _wishIdList.add(_product.id!);
  //         notifyListeners();
  //       } else {
  //         /// ApiChecker.checkApi(context, apiResponse);
  //         _loading = false;
  //         notifyListeners();
  //       }
  //     });
  //   } else {
  //     _loading = false;
  //     ApiChecker.checkApi(context, apiResponse);
  //   }
  // }
}
