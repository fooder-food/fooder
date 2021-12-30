// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_follower_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantFollower _$RestaurantFollowerFromJson(Map<String, dynamic> json) =>
    RestaurantFollower(
      uniqueId: json['uniqueId'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      avatar: json['avatar'] as String,
      favoriteUniqueId: json['favoriteUniqueId'] as String,
    );

Map<String, dynamic> _$RestaurantFollowerToJson(RestaurantFollower instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'username': instance.username,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'avatar': instance.avatar,
      'favoriteUniqueId': instance.favoriteUniqueId,
    };
