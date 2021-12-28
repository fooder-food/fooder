

import 'package:flutter/material.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';
import 'package:flutter_notification/model/country_model.dart';

class SearchCountryApiProvider {
  final NetworkService _networkService = NetworkService();
  
  Future<List<Country>> fetchAllCountry() async {
    try {
      final response = await _networkService.get('restaurants/all');
      print('test');
      final data = response.data["data"] as List;
      List<Country> countries = List.from(
        data.map((country) =>Country.fromJson(country)));
      return countries;
      
    } catch (e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

}