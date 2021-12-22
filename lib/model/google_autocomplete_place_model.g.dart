// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_autocomplete_place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleAutoCompletePlace _$GoogleAutoCompletePlaceFromJson(
        Map<String, dynamic> json) =>
    GoogleAutoCompletePlace(
      description: json['description'] as String,
      placeId: json['place_id'] as String,
      completeStructure: GoogleAutoCompleteStructuredFormatting.fromJson(
          json['structured_formatting'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GoogleAutoCompletePlaceToJson(
        GoogleAutoCompletePlace instance) =>
    <String, dynamic>{
      'description': instance.description,
      'place_id': instance.placeId,
      'structured_formatting': instance.completeStructure,
    };
