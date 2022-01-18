// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_list_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionListInfo _$CollectionListInfoFromJson(Map<String, dynamic> json) =>
    CollectionListInfo(
      uniqueId: json['uniqueId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CollectionListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      updateDate: DateTime.parse(json['updateDate'] as String),
    );

Map<String, dynamic> _$CollectionListInfoToJson(CollectionListInfo instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'items': instance.items,
      'updateDate': instance.updateDate.toIso8601String(),
    };
