// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_search_restaurant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListSearchRestaurant _$ListSearchRestaurantFromJson(
        Map<String, dynamic> json) =>
    ListSearchRestaurant(
      uniqueId: json['uniqueId'] as String,
      restaurantName: json['restaurantName'] as String,
      rating: (json['rating'] as num).toDouble(),
      image: json['image'] as String,
      isAdded: json['isAdded'] as bool,
    );

Map<String, dynamic> _$ListSearchRestaurantToJson(
        ListSearchRestaurant instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'restaurantName': instance.restaurantName,
      'rating': instance.rating,
      'image': instance.image,
      'isAdded': instance.isAdded,
    };
