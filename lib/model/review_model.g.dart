// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      uniqueId: json['uniqueId'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) => ReviewImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'content': instance.content,
      'type': instance.type,
      'images': instance.images,
    };
