// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capital_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Capital _$CapitalFromJson(Map<String, dynamic> json) => Capital(
      latlng: (json['latlng'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$CapitalToJson(Capital instance) => <String, dynamic>{
      'latlng': instance.latlng,
    };
