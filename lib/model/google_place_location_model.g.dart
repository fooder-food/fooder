// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_place_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GooglePlaceLocation _$GooglePlaceLocationFromJson(Map<String, dynamic> json) =>
    GooglePlaceLocation(
      longitude: (json['lng'] as num).toDouble(),
      latitude: (json['lat'] as num).toDouble(),
    );

Map<String, dynamic> _$GooglePlaceLocationToJson(
        GooglePlaceLocation instance) =>
    <String, dynamic>{
      'lat': instance.latitude,
      'lng': instance.longitude,
    };
