import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

@JsonSerializable()
class Restaurant {
  const Restaurant({
    required this.restaurantName,
    required this.uniqueId,
    required this.state,
    required this.view,
    required this.comments,
    required this.follower,
    required this.rating,
    required this.image,
    this.distance,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  final String restaurantName;
  final String uniqueId;
  final String state;
  final int view;
  final String comments;
  final String follower;
  final double rating;
  final double? distance;
  final String image;

}