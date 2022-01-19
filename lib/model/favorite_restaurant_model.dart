import 'package:json_annotation/json_annotation.dart';

part 'favorite_restaurant_model.g.dart';

@JsonSerializable()
class FavoriteRestaurant {
  const FavoriteRestaurant({
    required this.uniqueId,
    required this.state,
    required this.name,
    required this.rating,
    required this.view,
    required this.review,
    required this.image,
  });

  factory FavoriteRestaurant.fromJson(Map<String, dynamic> json) => _$FavoriteRestaurantFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteRestaurantToJson(this);

  final String uniqueId;
  final String state;
  final String name;
  final double rating;
  final int view;
  final int review;
  final String image;
}