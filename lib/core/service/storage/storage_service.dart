import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final Future<SharedPreferences> storage = SharedPreferences.getInstance();

  StorageService._constructor();

  static final StorageService _instance =
  StorageService._constructor();

  factory StorageService() {
    return _instance;
  }

  Future<void> setStr(String key, String value) async {
    final SharedPreferences prefs = await storage;
    prefs.setString(key, value);
  }

  Future<String?> getByKey(String key) async {
    final SharedPreferences prefs = await storage;
    return prefs.getString(key);
  }

  Future<void> remove(String key) async {
    final SharedPreferences prefs = await storage;
    prefs.remove(key);
  }

}