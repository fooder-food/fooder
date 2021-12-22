
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  User({
    required this.uniqueId,
    required this.username,
    required this.email,
    required this.avatar,
    required this.avatarType,
    required this.createDate,
    required this.updateDate,
    required this.deviceToken,
});

  factory User.fromJson(Map<String, dynamic> json) =>   _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  final String uniqueId;
  final String username;
  final String email;
  final String avatar;
  final String avatarType;
  final DateTime createDate;
  final DateTime updateDate;
  final String deviceToken;
}