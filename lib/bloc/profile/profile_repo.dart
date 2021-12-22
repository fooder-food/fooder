import 'package:flutter_notification/bloc/profile/profile_api_provider.dart';
import 'package:flutter_notification/model/auth_model.dart';
import 'package:flutter_notification/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';


class ProfileRepo {
  factory ProfileRepo() {
    return _instance;
  }

  ProfileRepo._constructor();

  static final ProfileRepo _instance = ProfileRepo._constructor();
  final ProfileApiProvider _profileApiProvider = ProfileApiProvider();

  Future<User> updateInfo({
    required String email,
    required String phone,
    required String username,
    XFile? avatar,
  }) async => _profileApiProvider.updateUser(
      email: email,
      phone: phone,
      username: username,
      avatar: avatar,
  );
}