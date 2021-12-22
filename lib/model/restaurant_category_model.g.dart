// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantCategory _$RestaurantCategoryFromJson(Map<String, dynamic> json) =>
    RestaurantCategory(
      uniqueId: json['uniqueId'] as String,
      categoryIcon: json['categoryIcon'] as String,
      categoryName: json['categoryName'] as String,
      createDate: DateTime.parse(json['createDate'] as String),
      updateDate: DateTime.parse(json['updateDate'] as String),
    );

Map<String, dynamic> _$RestaurantCategoryToJson(RestaurantCategory instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'categoryName': instance.categoryName,
      'categoryIcon': instance.categoryIcon,
      'createDate': instance.createDate.toIso8601String(),
      'updateDate': instance.updateDate.toIso8601String(),
    };
