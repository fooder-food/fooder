
import 'package:flutter/cupertino.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';
import 'package:flutter_notification/model/collection_list_info_model.dart';
import 'package:flutter_notification/model/list_model.dart';
import 'package:flutter_notification/model/list_search_restaurant_model.dart';
class AddListApiProvider {
  final NetworkService _networkService = NetworkService();

  Future<List<CollectionList>> addList({
    required String title,
    required String description,
  }) async {
    try {

      final body = {
        "title": title,
        "description": description,
      };

      final response = await _networkService.post('list/create', data: body,);
      final data = response.data!["data"] as List;
      List<CollectionList> collectionList = List.from(
          data.map((list) => CollectionList.fromJson(list as Map<String, dynamic>))
      );
      return collectionList;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<List<CollectionList>> fetchList() async {
    try {
      final response = await _networkService.get('list/all');
      final data = response.data["data"] as List;
      List<CollectionList> collectionList = List.from(
          data.map((list) => CollectionList.fromJson(list as Map<String, dynamic>))
      );
      return collectionList;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<CollectionListInfo> fetchListInfo({
  required String uniqueId,
  }) async {
    try {

      final response = await _networkService.get('list/item/$uniqueId',);
      final data = response.data!["data"];
      final CollectionListInfo info = CollectionListInfo.fromJson(data as Map<String, dynamic>);
      return info;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<List<ListSearchRestaurant>> fetchRestaurant({
    required String keyword,
    required String listUniqueId,
  }) async {
    try {
      final body = {
        "keyword": keyword,
        "listUniqueId": listUniqueId,
      };
      final response = await _networkService.post('list/search',data: body);
      final data = response.data!["data"];
      final List<ListSearchRestaurant> restaurants = List.from(
        data.map((restaurant) => ListSearchRestaurant.fromJson(restaurant)),
      );
      return restaurants;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<List<ListSearchRestaurant>> addRestaurantBySearch({
    required String keyword,
    required String restaurantUniqueId,
    required String collectionUniqueId,
  }) async {
    try {
      final body = {
        "keyword": keyword,
        "restaurantUniqueId": restaurantUniqueId,
        "collectionUniqueId": collectionUniqueId,
      };
      final response = await _networkService.post('list/add-item',data: body);
      final data = response.data!["data"];
      final List<ListSearchRestaurant> restaurants = List.from(
        data.map((restaurant) => ListSearchRestaurant.fromJson(restaurant)),
      );
      return restaurants;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<List<ListSearchRestaurant>> delRestaurantBySearch({
    required String keyword,
    required String restaurantUniqueId,
    required String collectionUniqueId,
  }) async {
    try {
      final body = {
        "keyword": keyword,
        "restaurantUniqueId": restaurantUniqueId,
        "collectionUniqueId": collectionUniqueId,
      };
      final response = await _networkService.del('list/remove-item',data: body);
      final data = response.data!["data"];
      final List<ListSearchRestaurant> restaurants = List.from(
        data.map((restaurant) => ListSearchRestaurant.fromJson(restaurant)),
      );
      return restaurants;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }
 }