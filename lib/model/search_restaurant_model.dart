import 'package:json_annotation/json_annotation.dart';

part 'search_restaurant_model.g.dart';

@JsonSerializable()
class SearchRestaurant {
  const SearchRestaurant({
    required this.uniqueId,
    required this.restaurantName
  });

  factory SearchRestaurant.fromJson(Map<String, dynamic> json) => _$SearchRestaurantFromJson(json);
  Map<String, dynamic> toJson() => _$SearchRestaurantToJson(this);

 final String uniqueId;
 final String restaurantName;
}