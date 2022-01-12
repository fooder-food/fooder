import 'package:flutter/material.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';
import 'package:flutter_notification/model/restaurant_search_history_model.dart';
import 'package:flutter_notification/model/search_restaurant_model.dart';

class SearchRestaurantApiProvider {
  final NetworkService _networkService = NetworkService();

  Future<List<SearchRestaurant>> fetchRestaurant({
    required String keyword,
  }) async {
    try {
      final body = {
        "keyword": keyword,
      };
      final response = await _networkService.post('restaurants/search',data: body);
      final data = response.data!["data"];
      final List<SearchRestaurant> restaurants = List.from(
        data.map((restaurant) => SearchRestaurant.fromJson(restaurant)),
      );
      return restaurants;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<List<RestaurantSearchHistory>> fetchSearchHistory() async {
    try {

      final response = await _networkService.get('history/all');
      final data = response.data!["data"];
      final List<RestaurantSearchHistory> historyList = List.from(
        data.map((history) => RestaurantSearchHistory.fromJson(history)),
      );
      return historyList;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<List<RestaurantSearchHistory>> delSearchHistory({
    required String uniqueId
  }) async {
    try {
      final body = {
        "isActive": 1,
        "restaurantUniqueId": uniqueId,
      };
      final response = await _networkService.put('history/update', data: body);
      final data = response.data!["data"];
      final List<RestaurantSearchHistory> historyList = List.from(
        data.map((history) => RestaurantSearchHistory.fromJson(history)),
      );
      return historyList;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<void> addSearchHistory({
    required String title,
    required String restaurantUniqueId,
  }) async {
    try {
      final body = {
        "title": title,
        "restaurantUniqueId": restaurantUniqueId,
      };

      final response = await _networkService.post('history/create', data: body);

    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }
}