

import 'package:flutter_notification/bloc/restaurant-location/restaurant_location_api_provider.dart';
import 'package:flutter_notification/model/google_autocomplete_place_model.dart';
import 'package:flutter_notification/model/google_map_location_model.dart';
import 'package:flutter_notification/model/google_place_details_model.dart';

class RestaurantLocationRepo {
  factory RestaurantLocationRepo() {
    return _instance;
  }
  RestaurantLocationRepo._constructor();
  static final RestaurantLocationRepo _instance = RestaurantLocationRepo._constructor();

  final RestaurantLocationApiProvider _restaurantLocationApiProvider = RestaurantLocationApiProvider();

  Future<List<GoogleAutoCompletePlace>> fetchPlaces(String keyword, String? countryCode) async =>  _restaurantLocationApiProvider.fetchPlaces(keyword, countryCode);
  Future<GoogleMapLocation> fetchGoogleMapLocation({
    required String longitude,
    required String latitude,
  }) async => _restaurantLocationApiProvider.fetchGoogleMapLocation(longitude: longitude, latitude: latitude);
  Future<GooglePlaceDetails> fetchPlaceDetails(String placeId) async => _restaurantLocationApiProvider.fetchSinglePlaceDetails(placeId);
}