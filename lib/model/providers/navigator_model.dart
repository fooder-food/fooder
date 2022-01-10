import 'dart:core';

import 'package:flutter/foundation.dart';

class NavigatorModel extends ChangeNotifier {
  int _index = 0;
  int get index => _index;
  void updateIndex(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }

  void resetIndex() {
    _index = 0;
    notifyListeners();
  }

}