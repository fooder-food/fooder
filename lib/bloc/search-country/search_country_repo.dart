
import 'package:flutter_notification/bloc/search-country/search_country_api_provider.dart';
import 'package:flutter_notification/model/country_model.dart';

class SearchCountryRepo {
  factory SearchCountryRepo() {
    return _instance;
  }
  SearchCountryRepo._constructor();
  static final SearchCountryRepo _instance = SearchCountryRepo._constructor();

  final SearchCountryApiProvider _restaurantCategoriesApiProvider = SearchCountryApiProvider();

  Future<List<Country>> fetchAllCountry() async => _restaurantCategoriesApiProvider.fetchAllCountry();
}