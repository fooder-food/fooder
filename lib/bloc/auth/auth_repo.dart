import 'package:flutter_notification/model/auth_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_api_provider.dart';

class AuthRepo {
  factory AuthRepo() {
    return _instance;
  }

  AuthRepo._constructor();

  static final AuthRepo _instance = AuthRepo._constructor();
  final AuthApiProvider _authApiProvider = AuthApiProvider();

  Future<Auth> register({
    required String email,
    required String password,
    required String username,
  }) async => _authApiProvider.register(email: email, password: password, username: username);

  Future<Auth> login({
    required String email,
    required String password,
    required String deviceToken,

  }) async => _authApiProvider.login(email: email, password: password, deviceToken: deviceToken);

  Future<GoogleSignInAccount?> googleSignIn() async => _authApiProvider.googleSignIn();

  Future<bool> checkEmailIsExist(String email) async => _authApiProvider.checkEmailExist(email);
}