// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
      restaurantName: json['restaurantName'] as String,
      uniqueId: json['uniqueId'] as String,
      state: json['state'] as String,
      view: json['view'] as int,
      comments: json['comments'] as String,
      follower: json['follower'] as String,
      rating: (json['rating'] as num).toDouble(),
    );

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'restaurantName': instance.restaurantName,
      'uniqueId': instance.uniqueId,
      'state': instance.state,
      'view': instance.view,
      'comments': instance.comments,
      'follower': instance.follower,
      'rating': instance.rating,
    };
