// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_comment_photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantCommentPhoto _$RestaurantCommentPhotoFromJson(
        Map<String, dynamic> json) =>
    RestaurantCommentPhoto(
      updateDate: DateTime.parse(json['updateDate'] as String),
      createDate: DateTime.parse(json['createDate'] as String),
      uniqueId: json['uniqueId'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$RestaurantCommentPhotoToJson(
        RestaurantCommentPhoto instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'imageUrl': instance.imageUrl,
      'createDate': instance.createDate.toIso8601String(),
      'updateDate': instance.updateDate.toIso8601String(),
    };
