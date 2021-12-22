import 'package:json_annotation/json_annotation.dart';

part 'google_autocomplete_structured_formatting_model.g.dart';

@JsonSerializable()
class GoogleAutoCompleteStructuredFormatting {
  const GoogleAutoCompleteStructuredFormatting({
    required this.mainText,
    required this.secondaryText,
});
  factory GoogleAutoCompleteStructuredFormatting.fromJson(Map<String, dynamic> json) => _$GoogleAutoCompleteStructuredFormattingFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleAutoCompleteStructuredFormattingToJson(this);

  @JsonKey(name: 'main_text')
  final String mainText;
  @JsonKey(name: 'secondary_text')
  final String secondaryText;
}