// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_place_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GooglePlaceDetails _$GooglePlaceDetailsFromJson(Map<String, dynamic> json) =>
    GooglePlaceDetails(
      placeId: json['place_id'] as String,
      geometry: GooglePlaceGeometry.fromJson(
          json['geometry'] as Map<String, dynamic>),
      restaurantName: json['name'] as String,
      formattedAddress: json['formatted_address'] as String,
    );

Map<String, dynamic> _$GooglePlaceDetailsToJson(GooglePlaceDetails instance) =>
    <String, dynamic>{
      'formatted_address': instance.formattedAddress,
      'geometry': instance.geometry,
      'name': instance.restaurantName,
      'place_id': instance.placeId,
    };
