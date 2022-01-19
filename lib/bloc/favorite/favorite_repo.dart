import 'dart:io';

import 'package:flutter_notification/bloc/add-list/add_list_api_provider.dart';
import 'package:flutter_notification/model/collection_list_info_model.dart';
import 'package:flutter_notification/model/collection_list_item_model.dart';
import 'package:flutter_notification/model/favorite_model.dart';
import 'package:flutter_notification/model/list_model.dart';
import 'package:flutter_notification/model/list_search_restaurant_model.dart';

import 'favorite_api_provider.dart';

class FavoriteRepo {
  factory FavoriteRepo() {
    return _instance;
  }

  FavoriteRepo._constructor();

  static final FavoriteRepo _instance = FavoriteRepo._constructor();
  final FavoriteApiProvider _favoriteApiProvider = FavoriteApiProvider();

  Future<List<Favorite>> fetchFavoriteList() async => _favoriteApiProvider.fetchFavoriteList();
}