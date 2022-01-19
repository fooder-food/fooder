// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Favorite _$FavoriteFromJson(Map<String, dynamic> json) => Favorite(
      uniqueId: json['uniqueId'] as String,
      isActive: json['isActive'] as bool,
      restaurant: FavoriteRestaurant.fromJson(
          json['restaurant'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FavoriteToJson(Favorite instance) => <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'isActive': instance.isActive,
      'restaurant': instance.restaurant,
    };
