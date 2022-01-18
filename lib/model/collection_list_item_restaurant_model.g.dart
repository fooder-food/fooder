// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_list_item_restaurant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionListItemRestaurant _$CollectionListItemRestaurantFromJson(
        Map<String, dynamic> json) =>
    CollectionListItemRestaurant(
      uniqueId: json['uniqueId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      image: json['image'] as String,
      rating: (json['rating'] as num).toDouble(),
    );

Map<String, dynamic> _$CollectionListItemRestaurantToJson(
        CollectionListItemRestaurant instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'name': instance.name,
      'address': instance.address,
      'image': instance.image,
      'rating': instance.rating,
    };
