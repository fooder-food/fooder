import 'package:flutter/material.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';
import 'package:flutter_notification/model/find_place_country_model.dart';
import 'package:flutter_notification/model/find_place_state_model.dart';
import 'package:flutter_notification/model/restaurant_category_model.dart';

class SearchPlaceApiProvider {
  final NetworkService _networkService = NetworkService.countryState();

  Future<List<FindPlaceCountry>> fetchCountry() async {
    try {
      final response = await _networkService.get('countries');
      final data = response.data as List;
      List<FindPlaceCountry> countries = List.from(
          data.map((country) =>FindPlaceCountry.fromJson(country)));
      return countries;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<List<FindPlaceState>> fetchState({
  required String code,
}) async {
    try {
      final response = await _networkService.get('countries/$code/states');
      final data = response.data as List;
      List<FindPlaceState> states = List.from(
          data.map((country) =>FindPlaceState.fromJson(country)));
      return states;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

}