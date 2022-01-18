import 'package:flutter_notification/model/collection_list_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collection_list_info_model.g.dart';

@JsonSerializable()
class CollectionListInfo {
  const CollectionListInfo({
    required this.uniqueId,
    required this.title,
    required this.description,
    required this.image,
    required this.items,
    required this.updateDate,
  });

  factory CollectionListInfo.fromJson(Map<String, dynamic> json) => _$CollectionListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionListInfoToJson(this);

  final String uniqueId;
  final String title;
  final String description;
  final String image;
  final List<CollectionListItem> items;
  final DateTime updateDate;
}