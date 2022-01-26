import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  const NotificationModel({
    required this.uniqueId,
    required this.content,
    required this.icon,
    required this.type,
    required this.isRead,
    required this.createDate,
    required this.updateDate,
    required this.diffTime,
    required this.params,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  final String uniqueId;
  final String content;
  final String icon;
  final String type;
  final bool isRead;
  final DateTime createDate;
  final DateTime updateDate;
  final String diffTime;
  final String params;
}