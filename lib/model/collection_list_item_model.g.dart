// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionListItem _$CollectionListItemFromJson(Map<String, dynamic> json) =>
    CollectionListItem(
      uniqueId: json['uniqueId'] as String,
      order: json['order'] as int,
      createDate: DateTime.parse(json['createDate'] as String),
      updateDate: DateTime.parse(json['updateDate'] as String),
      restaurant: CollectionListItemRestaurant.fromJson(
          json['restaurant'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CollectionListItemToJson(CollectionListItem instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'order': instance.order,
      'restaurant': instance.restaurant,
      'createDate': instance.createDate.toIso8601String(),
      'updateDate': instance.updateDate.toIso8601String(),
    };
