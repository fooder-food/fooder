
import 'package:json_annotation/json_annotation.dart';

part 'country_name_model.g.dart';

@JsonSerializable()
class CountryName {
  const CountryName({
    required this.common,
    required this.official,
});

  factory CountryName.fromJson(Map<String, dynamic> json) => _$CountryNameFromJson(json);
  Map<String, dynamic> toJson() => _$CountryNameToJson(this);


  final String common;
  final String official;

}