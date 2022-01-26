// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      uniqueId: json['uniqueId'] as String,
      content: json['content'] as String,
      icon: json['icon'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool,
      createDate: DateTime.parse(json['createDate'] as String),
      updateDate: DateTime.parse(json['updateDate'] as String),
      diffTime: json['diffTime'] as String,
      params: json['params'] as String,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'content': instance.content,
      'icon': instance.icon,
      'type': instance.type,
      'isRead': instance.isRead,
      'createDate': instance.createDate.toIso8601String(),
      'updateDate': instance.updateDate.toIso8601String(),
      'diffTime': instance.diffTime,
      'params': instance.params,
    };
