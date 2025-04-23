import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/repository/cart_repo.dart';

class CartProvider extends ChangeNotifier {
  final CartRepo? cartRepo;
  CartProvider({@required this.cartRepo});

  List<CartModel> _cartList = [];
  List<CartModel> get cartList => _cartList;

  bool _loading = false;
  bool get loading => _loading;
  List<int> _cartIdList = [];
  List<int> get cartIdList => _cartIdList;

  void removeFromCart(CartModel cart) {
    _cartList.remove(cart);

    notifyListeners();
  }

  void removeCartIds() {
    _cartIdList.clear();
    _cartList.clear();
    notifyListeners();
  }

  void clearCartList() {
    _cartList = [];
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  bool? _cartListLoading = false;
  bool? get cartListLoading => _cartListLoading;

  Future<void> initCartList(BuildContext context,
      {bool showLoading = true}) async {
    if (showLoading) {
      _cartListLoading = true;
    }
    notifyListeners();

    ApiResponse? apiResponse = await cartRepo!.cartList();
    _cartList = [];

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      apiResponse.response!.data.forEach((item) {
        _cartList.add(CartModel.fromJson(item));
      });
      _cartListLoading = false;

      notifyListeners();
    }
    _cartListLoading = false;

    notifyListeners();
  }

  bool? _cartListIdsLoading = false;
  bool? get cartListIdsLoading => _cartListIdsLoading;

  Future<void> initCartListProductIds(BuildContext context,
      {bool showLoading = true}) async {
    if (showLoading) {
      _cartListIdsLoading = true;
    }
    notifyListeners();
    try {
      ApiResponse apiResponse = await cartRepo!.getCartProductIds();

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _cartIdList = [];

        if (apiResponse.response!.data != null) {
          if (apiResponse.response!.data is List) {
            apiResponse.response!.data.forEach((item) {
              _cartIdList.add(item);
            });
          } else {
            print("Data is not a List. Value: ${apiResponse.response!.data}");
          }
        }
        _cartListIdsLoading = false;
        notifyListeners();
      } else {
        _cartListIdsLoading = false;
        notifyListeners();

        print('Api error: ${apiResponse.error.toString()}');
        throw Error();
      }
    } catch (error) {
      _cartListIdsLoading = false;
      notifyListeners();

      print("Error occurred: $error");
    }
  }

  bool _cartLoading = false;
  bool get cartLoading => _cartLoading;

  Future<void> addToCartList(CartModel cart) async {
    _cartLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await cartRepo!.addCartList(cart);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String message = map['message'];
      print('message => ${message}');
      _cartIdList.add(cart.productId!);
      _cartLoading = false;
    } else {
      _cartLoading = false;
      print('${apiResponse.error.toString()}');
    }
    _cartLoading = false;

    notifyListeners();
  }

  Future<void> removeFromCartList(int cartId, int productId) async {
    _cartLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await cartRepo!.removeCartList(cartId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String message = map['message'];
      int _idIndex = _cartIdList.indexOf(productId);
      _cartIdList.removeAt(_idIndex);
      _cartLoading = false;

      //  _wishList.removeAt(_idIndex);
    } else {
      print('${apiResponse.error.toString()}');
    }
    notifyListeners();
  }

  void updateQuantity(int cartIndex, int quantity) {
    _cartList[cartIndex].quantity = quantity;
    notifyListeners();
  }
}
