import 'package:json_annotation/json_annotation.dart';

part 'list_model.g.dart';

@JsonSerializable()
class CollectionList {
  const CollectionList({
    required this.uniqueId,
    required this.title,
    required this.description,
  });

  factory CollectionList.fromJson(Map<String, dynamic> json) => _$CollectionListFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionListToJson(this);

  final String uniqueId;
  final String title;
  final String description;
}