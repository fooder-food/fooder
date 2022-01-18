import 'package:json_annotation/json_annotation.dart';

import 'collection_list_item_restaurant_model.dart';

part 'collection_list_item_model.g.dart';

@JsonSerializable()
class CollectionListItem {
  CollectionListItem({
    required this.uniqueId,
    required this.order,
    required this.createDate,
    required this.updateDate,
    required this.restaurant,
  });

  factory CollectionListItem.fromJson(Map<String, dynamic> json) => _$CollectionListItemFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionListItemToJson(this);

  final String uniqueId;
  int order;
  final CollectionListItemRestaurant restaurant;
  final DateTime createDate;
  final DateTime updateDate;
}