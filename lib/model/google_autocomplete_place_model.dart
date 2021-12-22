import 'package:flutter_notification/model/google_autocomplete_structured_formatting_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'google_autocomplete_place_model.g.dart';

@JsonSerializable()
class GoogleAutoCompletePlace {
  const GoogleAutoCompletePlace({
    required this.description,
    required this.placeId,
    required this.completeStructure,
});

  factory GoogleAutoCompletePlace.fromJson(Map<String, dynamic> json) => _$GoogleAutoCompletePlaceFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleAutoCompletePlaceToJson(this);

  final String description;
  @JsonKey(name: 'place_id')
  final String placeId;
  @JsonKey(name: 'structured_formatting')
  final GoogleAutoCompleteStructuredFormatting completeStructure;

}