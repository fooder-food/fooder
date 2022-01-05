import 'package:flutter_notification/model/geo_model.dart';
import 'package:flutter_notification/model/restaurant_comment_model.dart';
import 'package:flutter_notification/model/restaurant_comment_photo_model.dart';
import 'package:flutter_notification/model/restaurant_create_user_model.dart';
import 'package:flutter_notification/model/restaurant_follower_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_details_model.g.dart';

@JsonSerializable()
class RestaurantDetails {
  const RestaurantDetails({
    required this.restaurantName,
    required this.uniqueId,
    required this.state,
    required this.view,
    required this.geo,
    required this.address,
    required this.pricePerson,
    required this.website,
    required this.breakTime,
    required this.businessHour,
    required this.updateDate,
    required this.totalComments,
    required this.totalFollowers,
    required this.restaurantPhone,
    required this.good,
    required this.normal,
    required this.bad,
    required this.rating,
    required this.photos,
    required this.comments,
    required this.createUser,
    required this.followers,
  });

  factory RestaurantDetails.fromJson(Map<String, dynamic> json) => _$RestaurantDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantDetailsToJson(this);

  final String restaurantName;
  final String uniqueId;
  final String state;
  final int view;
  final Geo geo;
  final String address;
  final String pricePerson;
  final String website;
  final List<String> businessHour;
  final String breakTime;
  final String restaurantPhone;
  final DateTime updateDate;
  final String totalComments;
  final String totalFollowers;
  final int good;
  final int normal;
  final int bad;
  final double rating;
  final List<RestaurantCommentPhoto> photos;
  final RestaurantCreateUser createUser;
  final List<RestaurantFollower> followers;
  final List<RestaurantComment> comments;
}