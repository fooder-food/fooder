

import 'package:flutter/material.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';
import 'package:flutter_notification/model/country_model.dart';

class SearchCountryApiProvider {
  final NetworkService _networkService = NetworkService.country();
  
  Future<List<Country>> fetchAllCountry() async {
    try {
      final response = await _networkService.get('all');
      final data = response.data as List;
      List<Country> countries = List.from(
        data.map((country) =>Country.fromJson(country)));
      return countries;
      
    } catch (e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

}