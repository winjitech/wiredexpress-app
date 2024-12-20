import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/data/repository/set_menu_repo.dart';


class SetMenuProvider extends ChangeNotifier {
  final SetMenuRepo? setMenuRepo;
  SetMenuProvider({@required this.setMenuRepo});

  List<Product>? _setMenuList;
  List<Product>? get setMenuList => _setMenuList;

  Future<void> getSetMenuList(BuildContext? context, bool reload) async {
    print('set menu 1');
    if(setMenuList == null || reload) {
      print('set menu 2');
      ApiResponse apiResponse = await setMenuRepo!.getSetMenuList();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

        _setMenuList = [];
        apiResponse.response!.data!.forEach((setMenu) => _setMenuList!.add(Product.fromJson(setMenu)));
        print('set menu 3 --- $_setMenuList');
      } else {
       // ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }
}