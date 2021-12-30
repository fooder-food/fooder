// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_create_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantCreateUser _$RestaurantCreateUserFromJson(
        Map<String, dynamic> json) =>
    RestaurantCreateUser(
      uniqueId: json['uniqueId'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      avatar: json['avatar'] as String,
    );

Map<String, dynamic> _$RestaurantCreateUserToJson(
        RestaurantCreateUser instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'username': instance.username,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'avatar': instance.avatar,
    };
