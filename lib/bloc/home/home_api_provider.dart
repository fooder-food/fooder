import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';
import 'package:flutter_notification/model/restaurant_model.dart';
import 'package:flutter_notification/model/user_model.dart';
import 'package:image_picker/image_picker.dart';

class HomeApiProvider {
  final NetworkService _networkService = NetworkService();

  Future<List<Restaurant>> fetchRestaurant({
    double? longitude,
    double? latitude,
    double? radius,
    String? state,
    required List<String> filter,
    required sort,
  }) async{

    bool isSearchByGeo = false;
    Map<String, dynamic>? geoQueryData;
    String url ='restaurants/all';
    if(latitude != null && longitude != null && radius != null) {
      print(sort);
      //  url = url + '?radius=${radius}&longitude=${longitude}&latitude=${latitude}&sort=$sort';
      url = url + '?radius=${radius}&longitude=103.6715&latitude=1.5177&sort=$sort';
    } else {
      url = url + '?sort=$sort&state=$state';
    }

    if(filter.isNotEmpty) {
      final newFilter = filter.join(',');
      url+='&filter=$newFilter';
    }

    print(url);

   try {
     final response = await _networkService.get(url,);
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