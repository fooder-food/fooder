import 'package:flutter_notification/model/favorite_restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
class Favorite {
  const Favorite({
    required this.uniqueId,
    required this.isActive,
    required this.restaurant,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => _$FavoriteFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteToJson(this);

  final String uniqueId;
  final bool isActive;
  final FavoriteRestaurant restaurant;
}