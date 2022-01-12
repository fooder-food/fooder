
import 'package:flutter_notification/bloc/search-restaurant/search_restaurant_api_provider.dart';
import 'package:flutter_notification/model/restaurant_search_history_model.dart';
import 'package:flutter_notification/model/search_restaurant_model.dart';

class SearchRestaurantRepo {
  factory SearchRestaurantRepo() {
    return _instance;
  }
  SearchRestaurantRepo._constructor();
  static final SearchRestaurantRepo _instance = SearchRestaurantRepo._constructor();

  final SearchRestaurantApiProvider _searchRestaurantApiProvider = SearchRestaurantApiProvider();

  Future<List<SearchRestaurant>> fetchRestaurant({
  required String keyword,
 }) => _searchRestaurantApiProvider.fetchRestaurant(keyword: keyword);

  Future<List<RestaurantSearchHistory>> fetchSearchHistory() => _searchRestaurantApiProvider.fetchSearchHistory();
  Future<void> addSearchHistory({
    required String title,
    required String restaurantUniqueId
  }) => _searchRestaurantApiProvider.addSearchHistory(title: title, restaurantUniqueId: restaurantUniqueId);

  Future<List<RestaurantSearchHistory>> delSearchHistory({
  required String uniqueId,
}) => _searchRestaurantApiProvider.delSearchHistory(uniqueId: uniqueId);
}