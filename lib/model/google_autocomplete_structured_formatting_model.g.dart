// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_autocomplete_structured_formatting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleAutoCompleteStructuredFormatting
    _$GoogleAutoCompleteStructuredFormattingFromJson(
            Map<String, dynamic> json) =>
        GoogleAutoCompleteStructuredFormatting(
          mainText: json['main_text'] as String,
          secondaryText: json['secondary_text'] as String,
        );

Map<String, dynamic> _$GoogleAutoCompleteStructuredFormattingToJson(
        GoogleAutoCompleteStructuredFormatting instance) =>
    <String, dynamic>{
      'main_text': instance.mainText,
      'secondary_text': instance.secondaryText,
    };
