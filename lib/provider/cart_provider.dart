import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:wired_express/data/helper/helpers.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/repository/cart_repo.dart';

class CartProvider extends ChangeNotifier {
  final CartRepo? cartRepo;
  CartProvider({@required this.cartRepo});

  double? _amount = 0.0;

  List<CartModel> _cartList = [];
  List<CartModel> get cartList => _cartList;

  bool _loading = false;
  bool get loading => _loading;
  List<int> _cartIdList = [];
  List<int> get cartIdList => _cartIdList;
  double? get amount => _amount;

  String _product = '';
  String? get product => _product;

  bool _existInCart = false;
  bool get existInCart => _existInCart;

  int? _matchedCartId;
  int? get matchedCartId => _matchedCartId;

  // void getCartData() {
  //   _cartList = [];
  //   _cartList!.addAll(cartRepo!.getCartList()!);
  //   _cartList!.forEach((cart) {
  //     _amount = _amount! + (cart.discountedPrice! * cart.quantity!);
  //   });
  // }

  // void addToCart(CartModel cartModel, int index, bool formCart) {
  //   if (formCart) {
  //     _amount = _amount! -
  //         (_cartList![index].discountedPrice! * _cartList![index].quantity!);
  //     _cartList!.replaceRange(index, index + 1, [cartModel]);
  //   } else {
  //     if (index != 0) {
  //       _amount = _amount! -
  //           (_cartList![index].discountedPrice! * _cartList![index].quantity!);
  //       _cartList!.replaceRange(index, index + 1, [cartModel]);
  //     } else {
  //       _cartList!.add(cartModel);
  //     }
  //   }
  //
  //   _amount = _amount! + (cartModel.discountedPrice! * cartModel.quantity!);
  //   cartRepo!.addToCartList(_cartList!);
  //   notifyListeners();
  // }

  void removeFromCart(CartModel cart) {
    _cartList.remove(cart);
    // _amount = _amount! - (cart.discountedPrice! * cart.quantity!);

    notifyListeners();
  }

  void removeCartIds() {
    _cartIdList.clear();
    _cartList.clear();
    notifyListeners();
  }

  void isExistInCart(Product product, List<dynamic> productVariationIndex) {
    _existInCart = false;
    notifyListeners();

    String selectedProductType =
        Helpers.getVariationType(product, productVariationIndex);
    print('selectedProductType=> ${selectedProductType}');
//  result 1:  'cheese-small'

    _cartList.forEach((cart) {
      if (cart.productId == product.id) {
        _matchedCartId = cart.id;
        _existInCart = true;
        // String cartProductType =
        //     Helpers.getVariationType(cart.product!, cart.variationIndex!);
        // print('cartProductType=> ${cartProductType}');
        // // result 2 'ranch-medium'
        //
        // if (selectedProductType == cartProductType) {
        //   _existInCart = true;
        // }
      }
    });
    notifyListeners();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  Future<void> initCartList(BuildContext context) async {
    _loading = true;
    notifyListeners();
    ApiResponse? apiResponse = await cartRepo!.cartList();
    _cartList = [];
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      apiResponse.response!.data.forEach((item) {
        _cartList.add(CartModel.fromJson(item));
      });

      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
      // String errorMessage = "Failed to load cart data";

      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(errorMessage)));
    }

    notifyListeners();
  }

  Future<void> initCartListProductIds(BuildContext context) async {
    _loading = true;
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
        _loading = false;
      } else {
        _loading = false;
        print('Api error: ${apiResponse.error.toString()}');
        throw Error();
      }
    } catch (error) {
      _loading = false;
      print("Error occurred: $error");
    }
  }

  bool _cartLoading = false;
  bool get cartLoading => _cartLoading;

  Future<void> addToCartList(CartModel cart, Function feedbackMessage) async {
    _cartLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await cartRepo!.addCartList(cart);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String message = map['message'];
      print('message => ${message}');
      feedbackMessage(message);
      //_wishList.add(WishlistModel.fromJson(apiResponse.response!.data));
      _cartIdList.add(cart.productId!);
      _cartLoading = false;
    } else {
      _cartLoading = false;      feedbackMessage('${apiResponse.error.toString()}');
      print('${apiResponse.error.toString()}');
    }
    _cartLoading = false;

    notifyListeners();
  }

  Future<void> removeFromCartList(
      int cartId, int productId, Function feedbackMessage) async {
    _cartLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await cartRepo!.removeCartList(cartId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String message = map['message'];
      feedbackMessage(message);
      int _idIndex = _cartIdList.indexOf(productId);
      _cartIdList.removeAt(_idIndex);
      _cartLoading = false;

      //  _wishList.removeAt(_idIndex);
    } else {
      print('${apiResponse.error.toString()}');
      feedbackMessage('${apiResponse.error.toString()}');
    }
    notifyListeners();
  }

  void updateQuantity(int cartIndex, int quantity) {
    _cartList[cartIndex].quantity = quantity;
    notifyListeners();
  }
}
