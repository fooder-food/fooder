// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth _$AuthFromJson(Map<String, dynamic> json) => Auth(
      code: json['code'] as int?,
      message: json['message'] as String,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String? ?? "",
    );

Map<String, dynamic> _$AuthToJson(Auth instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'user': instance.user,
      'token': instance.token,
    };
