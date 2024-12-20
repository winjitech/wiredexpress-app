import 'package:flutter/material.dart';
import 'package:wired_express/data/repository/main_repo.dart';

class MainProvider extends ChangeNotifier {
  final MainRepo? mainRepo;
  MainProvider({@required this.mainRepo});

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool status) {
    _loading = status;
    notifyListeners();
  }
}