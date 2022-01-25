

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';
import 'package:flutter_notification/model/country_model.dart';
import 'package:flutter_notification/model/review_image_model.dart';
import 'package:flutter_notification/model/review_model.dart';

class ReviewApiProvider {
  final NetworkService _networkService = NetworkService();

  Future<Review> fetchReview({
    required String uniqueId,
  }) async {
    try {
      final response = await _networkService.get('comments/$uniqueId');
      final data = response.data['data'];
      final review = Review.fromJson(data as Map<String, dynamic>);
      return review;

    } catch (e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<void> updateReview({
    required String content,
    required String type,
    required String commentUniqueId,
    List<ReviewImage>? delPhotos,
    List<File>? photos,
  }) async {
    print('photos $photos');
    try {
      Map<String, dynamic> data = {
        "content": content,
        "type": type,
        "commentUniqueId": commentUniqueId,
      };
      if(delPhotos != null) {
        final encodeDelPhotos = jsonEncode(delPhotos.map((item) => item.toJson()).toList());
        data["delImages"] = encodeDelPhotos;
      }
      if(photos != null) {
        final totalPhotoFiles = await Future.wait(photos.map((photo) async  =>  await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split('/').last,
        )));
        data["photos"] = totalPhotoFiles;
      }
      print(data);
      await _networkService.put('restaurants/comments/update', data: data, isFormData: true,);
    } catch(e) {
      print(e);
    }
  }


}