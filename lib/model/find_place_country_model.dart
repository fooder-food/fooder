
import 'package:json_annotation/json_annotation.dart';

part 'find_place_country_model.g.dart';

@JsonSerializable()
class FindPlaceCountry {
  FindPlaceCountry({
    required this.id,
    required this.name,
    required this.iso2,
    this.tagIndex = '',
  });

  factory FindPlaceCountry.fromJson(Map<String, dynamic> json) => _$FindPlaceCountryFromJson(json);
  Map<String, dynamic> toJson() => _$FindPlaceCountryToJson(this);


  final int id;
  final String name;
  final String iso2;
  String? tagIndex;

}