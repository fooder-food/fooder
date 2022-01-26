import 'package:flutter/foundation.dart';
import 'package:flutter_notification/core/service/storage/storage_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../auth_model.dart';
import '../user_model.dart';

class AuthModel extends ChangeNotifier {
  Auth? _user;

  Auth? get user => _user;

  void setUser(Auth user) async {
      _user = user;
    notifyListeners();
  }

  void updateUser(User user) {
    _user!.user = user;
    notifyListeners();
  }


  Future<void> logoutUser() async {
    _user = null;
    OneSignal.shared.removeExternalUserId();
    await StorageService().remove("user");
    notifyListeners();
  }
}