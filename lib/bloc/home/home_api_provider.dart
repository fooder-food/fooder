import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';
import 'package:flutter_notification/model/restaurant_model.dart';
import 'package:flutter_notification/model/user_model.dart';
import 'package:image_picker/image_picker.dart';

class HomeApiProvider {
  final NetworkService _networkService = NetworkService();

  Future<List<Restaurant>> fetchRestaurant() async{
   try {
     final response = await _networkService.get('restaurants/all',);
     final data = response.data["data"];
     final List<Restaurant> restaurants = List.from(
       data.map((restaurant) => Restaurant.fromJson(restaurant)),
     );
     return restaurants;

    } catch(e) {
     debugPrint("err cat: ${e.toString()}");
     throw Exception(e);
    }
  }


}