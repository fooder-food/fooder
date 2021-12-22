import 'package:flutter_notification/model/google_place_location_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'google_place_geometry_model.g.dart';

@JsonSerializable()
class GooglePlaceGeometry {
  const GooglePlaceGeometry(this.location);

  factory GooglePlaceGeometry.fromJson(Map<String, dynamic> json) => _$GooglePlaceGeometryFromJson(json);
  Map<String, dynamic> toJson() => _$GooglePlaceGeometryToJson(this);

  final GooglePlaceLocation location;
}