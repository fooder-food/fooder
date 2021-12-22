
import 'package:flutter_notification/model/capital_model.dart';
import 'package:flutter_notification/model/country_name_model.dart';
import 'package:flutter_notification/model/flag_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'country_model.g.dart';

@JsonSerializable()
class Country {
  const Country({
    required this.name,
    required this.region,
    required this.latlng,
    this.flag,
    required this.cca2,
    required this.flags,
    required this.population,
    required this.capitalInfo,
  });

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);
  Map<String, dynamic> toJson() => _$CountryToJson(this);

  @JsonKey(name: 'name')
  final CountryName name;
  final String region;
  final List<double> latlng;
  final String? flag;
  final int population;
  final String cca2;
  final Flag flags;
  @JsonKey(name: 'capitalInfo')
  final Capital capitalInfo;

}