// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_restaurant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteRestaurant _$FavoriteRestaurantFromJson(Map<String, dynamic> json) =>
    FavoriteRestaurant(
      uniqueId: json['uniqueId'] as String,
      state: json['state'] as String,
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
      view: json['view'] as int,
      review: json['review'] as int,
      image: json['image'] as String,
    );

Map<String, dynamic> _$FavoriteRestaurantToJson(FavoriteRestaurant instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'state': instance.state,
      'name': instance.name,
      'rating': instance.rating,
      'view': instance.view,
      'review': instance.review,
      'image': instance.image,
    };
