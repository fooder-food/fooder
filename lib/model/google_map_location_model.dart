import 'package:flutter_notification/model/google_place_geometry_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'google_map_location_model.g.dart';

@JsonSerializable()
class GoogleMapLocation {
  const GoogleMapLocation({
    required this.placeId,
    required this.formattedAddress,
    required this.geometry,
  });

  factory GoogleMapLocation.fromJson(Map<String, dynamic> json) => _$GoogleMapLocationFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleMapLocationToJson(this);

  @JsonKey(name: 'formatted_address')
  final String formattedAddress;

  @JsonKey(name: 'place_id')
  final String placeId;

  final GooglePlaceGeometry geometry;



}