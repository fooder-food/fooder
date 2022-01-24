// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantComment _$RestaurantCommentFromJson(Map<String, dynamic> json) =>
    RestaurantComment(
      updateDate: DateTime.parse(json['updateDate'] as String),
      createDate: DateTime.parse(json['createDate'] as String),
      type: json['type'] as String,
      content: json['content'] as String,
      uniqueId: json['uniqueId'] as String,
      photos: (json['photos'] as List<dynamic>)
          .map(
              (e) => RestaurantCommentPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: CommentUser.fromJson(json['user'] as Map<String, dynamic>),
      likeTotal: json['likeTotal'] as int,
      replyTotal: json['replyTotal'] as int,
      totalLikeUser: (json['totalLikeUser'] as List<dynamic>)
          .map((e) => CommentLikeUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RestaurantCommentToJson(RestaurantComment instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'content': instance.content,
      'type': instance.type,
      'createDate': instance.createDate.toIso8601String(),
      'updateDate': instance.updateDate.toIso8601String(),
      'photos': instance.photos,
      'totalLikeUser': instance.totalLikeUser,
      'likeTotal': instance.likeTotal,
      'replyTotal': instance.replyTotal,
      'user': instance.user,
    };
