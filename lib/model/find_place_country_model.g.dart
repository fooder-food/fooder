// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_place_country_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindPlaceCountry _$FindPlaceCountryFromJson(Map<String, dynamic> json) =>
    FindPlaceCountry(
      id: json['id'] as int,
      name: json['name'] as String,
      iso2: json['iso2'] as String,
      tagIndex: json['tagIndex'] as String? ?? '',
    );

Map<String, dynamic> _$FindPlaceCountryToJson(FindPlaceCountry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iso2': instance.iso2,
      'tagIndex': instance.tagIndex,
    };
