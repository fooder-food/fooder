import 'package:dio/dio.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';
import 'package:flutter_notification/model/user_model.dart';
import 'package:image_picker/image_picker.dart';

class ProfileApiProvider {
  final NetworkService _networkService = NetworkService();

  Future<User> updateUser({
    required String email,
    required String phone,
    required String username,
    XFile? avatar,
  }) async{
    final bodyData = {
      "email": email,
      "phone": phone,
      "username": username,
      "avatar": avatar != null
        ? await MultipartFile.fromFile(
        avatar.path,
        filename: avatar.path.split('/').last,
      ): null,
    };
    final response = await _networkService.put(
      'users/update',
      data: bodyData,
      isFormData: true,
    );
    final User user = User.fromJson(response.data!["data"] as Map<String, dynamic>);
    return user;
  }


}