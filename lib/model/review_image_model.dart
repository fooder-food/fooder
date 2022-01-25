import 'package:json_annotation/json_annotation.dart';

part 'review_image_model.g.dart';

@JsonSerializable()
class ReviewImage {
  const ReviewImage({
    required this.id,
    required this.uniqueId,
    required this.imageUrl
  });

  factory ReviewImage.fromJson(Map<String, dynamic> json) => _$ReviewImageFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewImageToJson(this);
  final int id;
  final String uniqueId;
  final String imageUrl;
}