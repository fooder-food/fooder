import 'package:json_annotation/json_annotation.dart';

part 'google_place_location_model.g.dart';

@JsonSerializable()
class GooglePlaceLocation {
  const GooglePlaceLocation({
    required this.longitude,
    required this.latitude,
});

  factory GooglePlaceLocation.fromJson(Map<String, dynamic> json) => _$GooglePlaceLocationFromJson(json);
  Map<String, dynamic> toJson() => _$GooglePlaceLocationToJson(this);

  @JsonKey(name: 'lat')
  final double latitude;

  @JsonKey(name: 'lng')
  final double longitude;
}