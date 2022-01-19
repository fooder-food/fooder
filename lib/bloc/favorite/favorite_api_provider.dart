
import 'package:flutter/cupertino.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';
import 'package:flutter_notification/model/collection_list_info_model.dart';
import 'package:flutter_notification/model/collection_list_item_model.dart';
import 'package:flutter_notification/model/favorite_model.dart';
import 'package:flutter_notification/model/list_model.dart';
import 'package:flutter_notification/model/list_search_restaurant_model.dart';
class FavoriteApiProvider {
  final NetworkService _networkService = NetworkService();

  Future<List<Favorite>> fetchFavoriteList() async {
    try {

      final response = await _networkService.get('restaurants/favorite/all',);
      final data = response.data!["data"];
      final List<Favorite> favoriteList = List.from(
        data.map((favorite) => Favorite.fromJson(favorite as Map<String, dynamic>)),
      );
      return favoriteList;
    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }
}