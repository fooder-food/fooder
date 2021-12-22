import 'package:flutter_notification/model/google_place_geometry_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'google_place_details_model.g.dart';

@JsonSerializable()
class GooglePlaceDetails {
  const GooglePlaceDetails({
    required this.placeId,
    required this.geometry,
    required this.restaurantName,
    required this.formattedAddress,
  });

  factory GooglePlaceDetails.fromJson(Map<String, dynamic> json) => _$GooglePlaceDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$GooglePlaceDetailsToJson(this);

  @JsonKey(name: 'formatted_address')
  final String formattedAddress;

  final GooglePlaceGeometry geometry;

  @JsonKey(name: 'name')
  final String restaurantName;

  @JsonKey(name: 'place_id')
  final String placeId;



}