import 'package:flutter/foundation.dart';
import 'package:flutter_notification/core/service/storage/storage_service.dart';

import '../auth_model.dart';
import '../user_model.dart';

class UserSearchRadiusModel extends ChangeNotifier {
  double _radius = 0.0;
  double _distance = 100;
  String _distanceText = '100m';

  double get radius => _radius;
  double get distance => _distance;
  String get distanceText => _distanceText;

  void updateRadius(double radius) {
    _radius = radius;
    if(radius <= 1) {
      _distance = 100;
      _distanceText = '100m';
    } else if (radius <= 2) {
      _distance = 300;
      _distanceText = '300m';
    } else if (radius <= 3) {
      _distance = 500;
      _distanceText = '500m';
    } else if (radius < 4) {
      _distance = 1000;
      _distanceText = '1km';
    } else {
      _distance = 3000;
      _distanceText = '3km';
    }
    print(_distanceText);
    notifyListeners();
  }

  void updateRadiusWhenChangeEnd() async {
    _radius = _radius = _radius.floor().toDouble();
    notifyListeners();
  }
}