import 'package:flutter_notification/bloc/add-restaurant/restaurant_categories_api_provider.dart';
import 'package:flutter_notification/model/restaurant_category_model.dart';

class AddRestaurantRepo {
  factory AddRestaurantRepo() {
    return _instance;
  }
  AddRestaurantRepo._constructor();
  static final AddRestaurantRepo _instance = AddRestaurantRepo._constructor();

  final RestaurantCategoriesApiProvider _restaurantCategoriesApiProvider = RestaurantCategoriesApiProvider();

  Future<List<RestaurantCategory>> fetchRestaurantCategories() async => _restaurantCategoriesApiProvider.fetchRestaurantCategory();

}