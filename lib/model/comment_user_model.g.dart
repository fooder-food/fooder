// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentUser _$CommentUserFromJson(Map<String, dynamic> json) => CommentUser(
      updateDate: DateTime.parse(json['updateDate'] as String),
      createDate: DateTime.parse(json['createDate'] as String),
      uniqueId: json['uniqueId'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      avatarType: json['avatarType'] as String,
    );

Map<String, dynamic> _$CommentUserToJson(CommentUser instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'username': instance.username,
      'email': instance.email,
      'avatar': instance.avatar,
      'avatarType': instance.avatarType,
      'createDate': instance.createDate.toIso8601String(),
      'updateDate': instance.updateDate.toIso8601String(),
    };
