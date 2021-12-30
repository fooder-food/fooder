import 'package:json_annotation/json_annotation.dart';

part 'restaurant_follower_model.g.dart';

@JsonSerializable()
class RestaurantFollower {
  const RestaurantFollower({
    required this.uniqueId,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.avatar,
    required this.favoriteUniqueId,
  });

  factory RestaurantFollower.fromJson(Map<String, dynamic> json) => _$RestaurantFollowerFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantFollowerToJson(this);
  final String uniqueId;
  final String username;
  final String email;
  final String phoneNumber;
  final String avatar;
  final String favoriteUniqueId;
}