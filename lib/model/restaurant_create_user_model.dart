import 'package:json_annotation/json_annotation.dart';

part 'restaurant_create_user_model.g.dart';

@JsonSerializable()
class RestaurantCreateUser {
  const RestaurantCreateUser({
    required this.uniqueId,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.avatar,
  });

  factory RestaurantCreateUser.fromJson(Map<String, dynamic> json) => _$RestaurantCreateUserFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantCreateUserToJson(this);
  final String uniqueId;
  final String username;
  final String email;
  final String phoneNumber;
  final String avatar;
}