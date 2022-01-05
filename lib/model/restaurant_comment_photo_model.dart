import 'package:flutter_notification/model/comment_user_model.dart';
import 'package:flutter_notification/model/geo_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_comment_photo_model.g.dart';

@JsonSerializable()
class RestaurantCommentPhoto {
  const RestaurantCommentPhoto({
    required this.updateDate,
    required this.createDate,
    required this.uniqueId,
    required this.imageUrl,

  });

  factory RestaurantCommentPhoto.fromJson(Map<String, dynamic> json) => _$RestaurantCommentPhotoFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantCommentPhotoToJson(this);

  final String uniqueId;
  final String imageUrl;
  final DateTime createDate;
  final DateTime updateDate;

}