
import 'package:flutter_notification/bloc/search_place/search_place_api_provider.dart';
import 'package:flutter_notification/model/country_model.dart';
import 'package:flutter_notification/model/find_place_country_model.dart';
import 'package:flutter_notification/model/find_place_state_model.dart';

class SearchPlaceRepo {
  factory SearchPlaceRepo() {
    return _instance;
  }
  SearchPlaceRepo._constructor();
  static final SearchPlaceRepo _instance = SearchPlaceRepo._constructor();

  final SearchPlaceApiProvider _searchPlaceApiProvider = SearchPlaceApiProvider();

  Future<List<FindPlaceCountry>> fetchAllCountry() async => _searchPlaceApiProvider.fetchCountry();
  Future<List<FindPlaceState>> fetchAllState({required String code}) async => _searchPlaceApiProvider.fetchState(code: code);
}