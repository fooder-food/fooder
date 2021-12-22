import 'package:flutter_notification/model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_component_model.g.dart';

@JsonSerializable()
class AddressComponent {
  AddressComponent({
   required this.placeId,
   required this.address,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) => _$AddressComponentFromJson(json);
  Map<String, dynamic> toJson() => _$AddressComponentToJson(this);

  final String placeId;
  final String address;
}