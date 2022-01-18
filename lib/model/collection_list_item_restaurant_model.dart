import 'package:json_annotation/json_annotation.dart';

part 'collection_list_item_restaurant_model.g.dart';

@JsonSerializable()
class CollectionListItemRestaurant {
  const CollectionListItemRestaurant({
    required this.uniqueId,
    required this.name,
    required this.address,
    required this.image,
    required this.rating,
  });

  factory CollectionListItemRestaurant.fromJson(Map<String, dynamic> json) => _$CollectionListItemRestaurantFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionListItemRestaurantToJson(this);

  final String uniqueId;
  final String name;
  final String address;
  final String image;
  final double rating;
}