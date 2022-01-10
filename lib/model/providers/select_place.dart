import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter_notification/model/find_place_state_model.dart';

class SelectPlaceModel extends ChangeNotifier {
  FindPlaceState? _selectedPlace;
  bool _locationFirst = false;
  FindPlaceState? get selectedPlace => _selectedPlace;
  bool get locationFirst => _locationFirst;
  void updateState(FindPlaceState newState) {
    _selectedPlace = newState;
    notifyListeners();
  }
  void updateLocationPriority(bool newPriority) {
    _locationFirst = newPriority;
    notifyListeners();
  }

}