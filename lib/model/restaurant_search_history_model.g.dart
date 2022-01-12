// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_search_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantSearchHistory _$RestaurantSearchHistoryFromJson(
        Map<String, dynamic> json) =>
    RestaurantSearchHistory(
      historyName: json['historyName'] as String,
      restaurantUniqueId: json['restaurantUniqueId'] as String,
    );

Map<String, dynamic> _$RestaurantSearchHistoryToJson(
        RestaurantSearchHistory instance) =>
    <String, dynamic>{
      'historyName': instance.historyName,
      'restaurantUniqueId': instance.restaurantUniqueId,
    };
