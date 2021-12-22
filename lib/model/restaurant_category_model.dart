import 'package:json_annotation/json_annotation.dart';

part 'restaurant_category_model.g.dart';

@JsonSerializable()
class RestaurantCategory {
  const RestaurantCategory({
    required this.uniqueId,
    required this.categoryIcon,
    required this.categoryName,
    required this.createDate,
    required this.updateDate,
  });

  factory RestaurantCategory.fromJson(Map<String, dynamic> json) => _$RestaurantCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantCategoryToJson(this);

  final String uniqueId;
  final String categoryName;
  final String categoryIcon;
  final DateTime createDate;
  final DateTime updateDate;
}