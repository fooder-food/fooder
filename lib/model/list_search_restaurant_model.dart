import 'package:json_annotation/json_annotation.dart';

part 'list_search_restaurant_model.g.dart';

@JsonSerializable()
class ListSearchRestaurant {
  ListSearchRestaurant({
    required this.uniqueId,
    required this.restaurantName,
    required this.rating,
    required this.image,
    required this.isAdded,
  });

  factory ListSearchRestaurant.fromJson(Map<String, dynamic> json) => _$ListSearchRestaurantFromJson(json);
  Map<String, dynamic> toJson() => _$ListSearchRestaurantToJson(this);

  final String uniqueId;
  final String restaurantName;
  final double rating;
  final String image;
  bool isAdded;
}