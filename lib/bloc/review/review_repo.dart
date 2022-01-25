

import 'dart:io';

import 'package:flutter_notification/bloc/restaurant-details/restaurant_details_api_provider.dart';
import 'package:flutter_notification/bloc/restaurant-location/restaurant_location_api_provider.dart';
import 'package:flutter_notification/bloc/review/review_api_provider.dart';
import 'package:flutter_notification/model/google_autocomplete_place_model.dart';
import 'package:flutter_notification/model/google_map_location_model.dart';
import 'package:flutter_notification/model/google_place_details_model.dart';
import 'package:flutter_notification/model/restaurant_details_model.dart';
import 'package:flutter_notification/model/review_image_model.dart';
import 'package:flutter_notification/model/review_model.dart';

class ReviewRepo {
  factory ReviewRepo() {
    return _instance;
  }

  ReviewRepo._constructor();

  static final ReviewRepo _instance = ReviewRepo
      ._constructor();

  final ReviewApiProvider _reviewApiProvider = ReviewApiProvider();

  Future<Review> fetchReview({
  required String uniqueId
}) async => _reviewApiProvider.fetchReview(uniqueId: uniqueId);

  Future<void> updateReview({
    required String content,
    required String type,
    required String commentUniqueId,
    List<ReviewImage>? delPhotos,
    List<File>? photos,
  }) async => _reviewApiProvider.updateReview(
      content: content,
      type: type,
      commentUniqueId: commentUniqueId,
      photos: photos,
      delPhotos: delPhotos,
  );
}