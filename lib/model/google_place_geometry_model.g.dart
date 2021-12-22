// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_place_geometry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GooglePlaceGeometry _$GooglePlaceGeometryFromJson(Map<String, dynamic> json) =>
    GooglePlaceGeometry(
      GooglePlaceLocation.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GooglePlaceGeometryToJson(
        GooglePlaceGeometry instance) =>
    <String, dynamic>{
      'location': instance.location,
    };
