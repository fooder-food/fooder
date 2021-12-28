// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_component_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressComponent _$AddressComponentFromJson(Map<String, dynamic> json) =>
    AddressComponent(
      placeId: json['placeId'] as String,
      address: json['address'] as String,
      geo: json['geo'] == null
          ? null
          : GooglePlaceLocation.fromJson(json['geo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddressComponentToJson(AddressComponent instance) =>
    <String, dynamic>{
      'placeId': instance.placeId,
      'address': instance.address,
      'geo': instance.geo,
    };
