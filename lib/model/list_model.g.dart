// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionList _$CollectionListFromJson(Map<String, dynamic> json) =>
    CollectionList(
      uniqueId: json['uniqueId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$CollectionListToJson(CollectionList instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
    };
