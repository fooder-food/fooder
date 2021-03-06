import 'package:flutter_notification/bloc/add-restaurant/restaurant_categories_api_provider.dart';
import 'package:flutter_notification/model/restaurant_category_model.dart';
import 'package:image_picker/image_picker.dart';

class AddRestaurantRepo {
  factory AddRestaurantRepo() {
    return _instance;
  }
  AddRestaurantRepo._constructor();
  static final AddRestaurantRepo _instance = AddRestaurantRepo._constructor();

  final RestaurantCategoriesApiProvider _restaurantCategoriesApiProvider = RestaurantCategoriesApiProvider();

  Future<List<RestaurantCategory>> fetchRestaurantCategories() async => _restaurantCategoriesApiProvider.fetchRestaurantCategory();

  Future<Map<String, dynamic>?> addRestaurant({
    required String restaurantName,
    required String restaurantAddress,
    required String placeId,
    required String phoneNumber,
    required String selectedCategoryId,
    required XFile image,
  }) async => _restaurantCategoriesApiProvider.addRestaurant(
      image: image,
      restaurantName: restaurantName,
      restaurantAddress: restaurantAddress,
      placeId: placeId,
      phoneNumber: phoneNumber,
      selectedCategoryId: selectedCategoryId
  );
}