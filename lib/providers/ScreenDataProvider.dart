import 'package:flutter/material.dart';

class ScreenDataProvider extends ChangeNotifier {
  Map<dynamic, dynamic> _data = {};

  Map<dynamic, dynamic> getData() {
    return _data;
  }

  void addData(dynamic key, dynamic value) {
    _data[key] = value;
    notifyListeners();
  }

  void clearData() {
    _data.clear();
    notifyListeners();
  }
}
