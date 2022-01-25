

import 'package:flutter_notification/bloc/restaurant-details/restaurant_details_api_provider.dart';
import 'package:flutter_notification/bloc/restaurant-location/restaurant_location_api_provider.dart';
import 'package:flutter_notification/model/google_autocomplete_place_model.dart';
import 'package:flutter_notification/model/google_map_location_model.dart';
import 'package:flutter_notification/model/google_place_details_model.dart';
import 'package:flutter_notification/model/restaurant_comment_photo_model.dart';
import 'package:flutter_notification/model/restaurant_details_model.dart';

class RestaurantDetailsRepo {
  factory RestaurantDetailsRepo() {
    return _instance;
  }

  RestaurantDetailsRepo._constructor();

  static final RestaurantDetailsRepo _instance = RestaurantDetailsRepo
      ._constructor();

  final RestaurantDetailsApiProvider _restaurantDetailsApiProvider = RestaurantDetailsApiProvider();

  Future<RestaurantDetails> fetchRestaurantData({
    required String uniqueId,
  }) async => _restaurantDetailsApiProvider.fetchRestaurant(uniqueId: uniqueId);
  Future<RestaurantDetails> setCommentLike({
    required String commentUniqueId,
  }) async => _restaurantDetailsApiProvider.setLike(commentUniqueId: commentUniqueId);

  Future<void> addFavorite({
    required String userUniqueId,
    required String restaurantUniqueId,
  }) async => _restaurantDetailsApiProvider.addFavorite(userUniqueId: userUniqueId, restaurantUniqueId: restaurantUniqueId);

  Future<void> delFavorite({
    required String uniqueId,
  }) async => _restaurantDetailsApiProvider.deleteFavorite(uniqueId: uniqueId);

  Future<RestaurantDetails> delReview({
  required String commentUniqueId,
}) async => _restaurantDetailsApiProvider.deleteReview(commentUnique: commentUniqueId);

  Future<List<RestaurantCommentPhoto>> fetchPhotos({
  required String uniqueId,
}) async => _restaurantDetailsApiProvider.fetchAllPhoto(uniqueId: uniqueId);
}