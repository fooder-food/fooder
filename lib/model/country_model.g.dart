// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      name: CountryName.fromJson(json['name'] as Map<String, dynamic>),
      region: json['region'] as String,
      latlng: (json['latlng'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      flag: json['flag'] as String?,
      cca2: json['cca2'] as String,
      flags: Flag.fromJson(json['flags'] as Map<String, dynamic>),
      population: json['population'] as int,
      capitalInfo:
          Capital.fromJson(json['capitalInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'name': instance.name,
      'region': instance.region,
      'latlng': instance.latlng,
      'flag': instance.flag,
      'population': instance.population,
      'cca2': instance.cca2,
      'flags': instance.flags,
      'capitalInfo': instance.capitalInfo,
    };
