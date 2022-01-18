import 'dart:io';

import 'package:flutter_notification/bloc/add-list/add_list_api_provider.dart';
import 'package:flutter_notification/model/collection_list_info_model.dart';
import 'package:flutter_notification/model/list_model.dart';
import 'package:flutter_notification/model/list_search_restaurant_model.dart';

class AddListRepo {
  factory AddListRepo() {
    return _instance;
  }

  AddListRepo._constructor();

  static final AddListRepo _instance = AddListRepo._constructor();
  final AddListApiProvider _addListApiProvider = AddListApiProvider();

  Future<List<CollectionList>> addNewList({
  required String title,
  required String description,
  }) async => _addListApiProvider.addList(title: title, description: description);

  Future<List<CollectionList>> fetchList() async => _addListApiProvider.fetchList();

  Future<CollectionListInfo> fetchInfo({ required String uniqueId }) async => _addListApiProvider.fetchListInfo(uniqueId: uniqueId);

  Future<List<ListSearchRestaurant>> fetchRestaurant({
    required String keyword,
    required String listUniqueId,
  }) => _addListApiProvider.fetchRestaurant(keyword: keyword, listUniqueId: listUniqueId);

  Future<List<ListSearchRestaurant>> addRestaurantBySearch({
  required String keyword,
  required String restaurantUniqueId,
  required String collectionUniqueId,
}) async => _addListApiProvider.addRestaurantBySearch(keyword: keyword, restaurantUniqueId: restaurantUniqueId, collectionUniqueId: collectionUniqueId);

  Future<List<ListSearchRestaurant>> delRestaurantBySearch({
    required String keyword,
    required String restaurantUniqueId,
    required String collectionUniqueId,
  }) async => _addListApiProvider.delRestaurantBySearch(keyword: keyword, restaurantUniqueId: restaurantUniqueId, collectionUniqueId: collectionUniqueId);
}