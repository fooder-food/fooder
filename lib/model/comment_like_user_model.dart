import 'package:json_annotation/json_annotation.dart';

part 'comment_like_user_model.g.dart';

@JsonSerializable()
class CommentLikeUser {
  const CommentLikeUser({
    required this.uniqueId,
    required this.id,
  });

  factory CommentLikeUser.fromJson(Map<String, dynamic> json) => _$CommentLikeUserFromJson(json);
  Map<String, dynamic> toJson() => _$CommentLikeUserToJson(this);
  final int id;
  final String uniqueId;

}