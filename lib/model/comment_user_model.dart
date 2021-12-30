import 'package:flutter_notification/model/geo_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_user_model.g.dart';

@JsonSerializable()
class CommentUser {
  const CommentUser({
    required this.updateDate,
    required this.createDate,
    required this.uniqueId,
    required this.username,
    required this.email,
    required this.avatar,
    required this.avatarType,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) => _$CommentUserFromJson(json);
  Map<String, dynamic> toJson() => _$CommentUserToJson(this);

  final String uniqueId;
  final String username;
  final String email;
  final String avatar;
  final String avatarType;
  final DateTime createDate;
  final DateTime updateDate;

}