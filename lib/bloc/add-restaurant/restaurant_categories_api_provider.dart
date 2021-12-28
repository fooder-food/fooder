import 'package:flutter/material.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';
import 'package:flutter_notification/model/restaurant_category_model.dart';

class RestaurantCategoriesApiProvider {
  final NetworkService _networkService = NetworkService();
  Future<List<RestaurantCategory>> fetchRestaurantCategory() async {
    try {
      final response = await _networkService.get('category/all');
      final data = response.data["data"]["categories"] as List;
      List<RestaurantCategory> restaurantCategory = List.from(
          data.map((category) => RestaurantCategory.fromJson(category as Map<String, dynamic>))
      );
      return restaurantCategory;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>?> addRestaurant({
    required String restaurantName,
    required String restaurantAddress,
    required String placeId,
    required String phoneNumber,
    required String selectedCategoryId,
  }) async {
    final mapData = {
      'restaurantName': restaurantName,
      'restaurantAddress': restaurantAddress,
      'placeId': placeId,
      'phoneNumber': phoneNumber,
      'selectedCategoryUniqueId': selectedCategoryId,
    };
   final response = await _networkService.post('restaurants/create', data: mapData);
   return response.data;
  }

}