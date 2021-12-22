import 'package:flutter_notification/model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class Auth {
  Auth({
    this.code,
    required this.message,
    this.user,
    this.token = "",
  });

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);
  Map<String, dynamic> toJson() => _$AuthToJson(this);

  final int? code;
  final String message;
  User? user;
  final String token;
}