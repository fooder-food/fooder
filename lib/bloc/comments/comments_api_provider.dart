import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';
class CommentApiProvider {
  final NetworkService _networkService = NetworkService();

  Future<void> addReview({
    required String content,
    required int type,
    required String restaurantUniqueId,
    List<File>? photos,
  }) async {
    print('photos $photos');
    try {
      final data = {
        "content": content,
        "type": type,
        "restaurantUniqueId": restaurantUniqueId,
      };
      if(photos != null) {
        final totalPhotoFiles = await Future.wait(photos.map((photo) async  =>  await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split('/').last,
        )));
        data["photos"] = totalPhotoFiles;
      }
      final response = await _networkService.post('restaurants/comments/create', data: data, isFormData: true,);
    } catch(e) {
      print(e);
    }
  }


}