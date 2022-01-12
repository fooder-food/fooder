import 'package:json_annotation/json_annotation.dart';

part 'restaurant_search_history_model.g.dart';

@JsonSerializable()
class RestaurantSearchHistory {
  const RestaurantSearchHistory({
    required this.historyName,
    required this.restaurantUniqueId,
  });

  factory RestaurantSearchHistory.fromJson(Map<String, dynamic> json) => _$RestaurantSearchHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantSearchHistoryToJson(this);

  final String historyName;
  final String restaurantUniqueId;
}