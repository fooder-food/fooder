import 'dart:core';

import 'package:flutter/foundation.dart';

class NotificationCountModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  void updateCount(int count) {
    _count = count;
    notifyListeners();
  }

  // void resetIndex() {
  //   _count = 0;
  //   notifyListeners();
  // }

}