
import 'package:flutter/material.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';
import 'package:flutter_notification/model/restaurant_details_model.dart';


class RestaurantDetailsApiProvider {
  final NetworkService _networkService = NetworkService();

  Future<RestaurantDetails> fetchRestaurant({
  required String uniqueId
  }) async{
    try {
      final response = await _networkService.get('restaurants/$uniqueId',);
      final data = response.data["data"];
      final RestaurantDetails restaurant = RestaurantDetails.fromJson(data as Map<String, dynamic>);
      return restaurant;

    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<void> addFavorite({
    required String userUniqueId,
    required String restaurantUniqueId,
  }) async {
    final data = {
      "restaurantUniqueId": restaurantUniqueId,
      "userUniqueId": userUniqueId
    };
    try {
      final response = await _networkService.post('restaurants/favorite', data: data);

    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<void> deleteFavorite({
    required String uniqueId,
  }) async {

    try {
      final response = await _networkService.del('restaurants/favorite/$uniqueId');

    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }


}