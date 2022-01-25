import 'package:flutter_notification/model/review_image_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@JsonSerializable()
class Review {
  Review({
    required this.uniqueId,
    required this.content,
    required this.type,
    required this.images,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);

  final String uniqueId;
  String content;
  String type;
  List<ReviewImage> images;
}