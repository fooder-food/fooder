// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_map_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleMapLocation _$GoogleMapLocationFromJson(Map<String, dynamic> json) =>
    GoogleMapLocation(
      placeId: json['place_id'] as String,
      formattedAddress: json['formatted_address'] as String,
      geometry: GooglePlaceGeometry.fromJson(
          json['geometry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GoogleMapLocationToJson(GoogleMapLocation instance) =>
    <String, dynamic>{
      'formatted_address': instance.formattedAddress,
      'place_id': instance.placeId,
      'geometry': instance.geometry,
    };
