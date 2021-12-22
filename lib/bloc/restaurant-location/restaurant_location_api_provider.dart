import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';
import 'package:flutter_notification/model/google_autocomplete_place_model.dart';
import 'package:flutter_notification/model/google_map_location_model.dart';
import 'package:flutter_notification/model/google_place_details_model.dart';

class RestaurantLocationApiProvider {
  final NetworkService _networkService = NetworkService.googleMapApi();
  Future<List<GoogleAutoCompletePlace>> fetchPlaces(String keyword, String? countryCode) async {
    try {
      final key = dotenv.env['GOOGLE_PLACE_AUTOCOMPLETE_API_KEY'];
      Map<String, dynamic> _queryMap = {
        "input": keyword,
        "key": key,
        "types": "establishment",
      };

      if(countryCode != null) {
        _queryMap["components"] = "country:$countryCode";
      }

      final response = await _networkService.get('place/autocomplete/json', queryParams:_queryMap);
      final data = response.data["predictions"] as List;
      List<GoogleAutoCompletePlace> places = List.from(
          data.map((place) => GoogleAutoCompletePlace.fromJson(place as Map<String, dynamic>))
      );
      return places;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<GoogleMapLocation> fetchGoogleMapLocation({
    required String longitude,
    required String latitude,
  }) async {
    try {
      final key = dotenv.env['GOOGLE_PLACE_AUTOCOMPLETE_API_KEY'];
      Map<String, dynamic> _queryMap = {
        "key": key,
        "latlng": '$latitude, $longitude',
      };
      final response = await _networkService.get('geocode/json', queryParams:_queryMap);
      final data = response.data['results'][0];
      GoogleMapLocation place = GoogleMapLocation.fromJson(data as Map<String, dynamic>);
      return place;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<GooglePlaceDetails> fetchSinglePlaceDetails(String placeId) async {
    try {
      final key = dotenv.env['GOOGLE_PLACE_AUTOCOMPLETE_API_KEY'];
      Map<String, dynamic> _queryMap = {
        "key": key,
        "place_id": placeId,
      };


      final response = await _networkService.get('place/details/json', queryParams:_queryMap);
      final data = response.data['result'];
      GooglePlaceDetails place = GooglePlaceDetails.fromJson(data as Map<String, dynamic>);
      // List<GoogleAutoCompletePlace> places = List.from(
      //     data.map((place) => GoogleAutoCompletePlace.fromJson(place as Map<String, dynamic>))
      // );
      return place;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }
}