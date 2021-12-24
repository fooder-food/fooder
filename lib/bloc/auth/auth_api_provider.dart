import 'package:flutter_notification/core/service/network/network_service.dart';
import 'package:flutter_notification/model/auth_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthApiProvider {
  final NetworkService _networkService = NetworkService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
  ],);

  Future<Auth> register({
    required String email,
    required String password,
    required String username,
  }) async {
    final data = {
      "email": email,
      "password": password,
      "username": username,
    };
    final response = await _networkService.post('auth/user/register/email', data: data);
    print(response);
    final Auth auth = Auth.fromJson(response.data!["data"] as Map<String, dynamic>);
    return auth;
  }

  Future<Auth> login({
    required String email,
    required String password,
    required String deviceToken,
  }) async {
    final data = {
      "email": email,
      "password": password,
      "deviceToken": deviceToken,
    };
    final response = await _networkService.post('auth/login/email', data: data);
    final Auth auth = Auth.fromJson(response.data!["data"] as Map<String, dynamic>);
    return auth;
  }

  Future<bool> checkEmailExist(String email) async {
    final response = await _networkService.post('auth/user/email/validate/$email');
    final bool isAvailable = response.data!["data"]["isAvailable"];
    return isAvailable;
  }

  Future<GoogleSignInAccount?> googleSignIn() async => await _googleSignIn.signIn();
}