import 'package:flutter_notification/bloc/home/home_api_provider.dart';
import 'package:flutter_notification/model/restaurant_model.dart';



class HomeRepo {
  factory HomeRepo() {
    return _instance;
  }

  HomeRepo._constructor();

  static final HomeRepo _instance = HomeRepo._constructor();
  final HomeApiProvider _homeApiProvider = HomeApiProvider();

  Future<List<Restaurant>> fetchRestaurant({
    double? longitude,
    double? latitude,
    double? radius,
  }) async => _homeApiProvider.fetchRestaurant(
    longitude: longitude,
    latitude: latitude,
    radius: radius,
  );
}