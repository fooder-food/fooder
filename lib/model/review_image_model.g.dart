// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewImage _$ReviewImageFromJson(Map<String, dynamic> json) => ReviewImage(
      id: json['id'] as int,
      uniqueId: json['uniqueId'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$ReviewImageToJson(ReviewImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uniqueId': instance.uniqueId,
      'imageUrl': instance.imageUrl,
    };
