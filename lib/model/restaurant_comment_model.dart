import 'package:flutter_notification/model/comment_user_model.dart';
import 'package:flutter_notification/model/geo_model.dart';
import 'package:flutter_notification/model/restaurant_comment_photo_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'comment_like_user_model.dart';

part 'restaurant_comment_model.g.dart';

@JsonSerializable()
class RestaurantComment {
  const RestaurantComment({
    required this.updateDate,
    required this.createDate,
    required this.type,
    required this.content,
    required this.uniqueId,
    required this.photos,
    required this.user,
    required this.likeTotal,
    required this.replyTotal,
    required this.totalLikeUser,
  });

  factory RestaurantComment.fromJson(Map<String, dynamic> json) => _$RestaurantCommentFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantCommentToJson(this);

  final String uniqueId;
  final String content;
  final String type;
  final DateTime createDate;
  final DateTime updateDate;
  final List<RestaurantCommentPhoto> photos;
  final List<CommentLikeUser> totalLikeUser;
  final int likeTotal;
  final int replyTotal;
  final CommentUser user;

}