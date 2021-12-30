// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantDetails _$RestaurantDetailsFromJson(Map<String, dynamic> json) =>
    RestaurantDetails(
      restaurantName: json['restaurantName'] as String,
      uniqueId: json['uniqueId'] as String,
      state: json['state'] as String,
      view: json['view'] as int,
      geo: Geo.fromJson(json['geo'] as Map<String, dynamic>),
      address: json['address'] as String,
      pricePerson: json['pricePerson'] as String,
      website: json['website'] as String,
      breakTime: json['breakTime'] as String,
      businessHour: (json['businessHour'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      updateDate: DateTime.parse(json['updateDate'] as String),
      totalComments: json['totalComments'] as String,
      totalFollowers: json['totalFollowers'] as String,
      restaurantPhone: json['restaurantPhone'] as String,
      good: json['good'] as int,
      normal: json['normal'] as int,
      bad: json['bad'] as int,
      rating: (json['rating'] as num).toDouble(),
      photos:
          (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => RestaurantComment.fromJson(e as Map<String, dynamic>))
          .toList(),
      createUser: RestaurantCreateUser.fromJson(
          json['createUser'] as Map<String, dynamic>),
      followers: (json['followers'] as List<dynamic>)
          .map((e) => RestaurantFollower.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RestaurantDetailsToJson(RestaurantDetails instance) =>
    <String, dynamic>{
      'restaurantName': instance.restaurantName,
      'uniqueId': instance.uniqueId,
      'state': instance.state,
      'view': instance.view,
      'geo': instance.geo,
      'address': instance.address,
      'pricePerson': instance.pricePerson,
      'website': instance.website,
      'businessHour': instance.businessHour,
      'breakTime': instance.breakTime,
      'restaurantPhone': instance.restaurantPhone,
      'updateDate': instance.updateDate.toIso8601String(),
      'totalComments': instance.totalComments,
      'totalFollowers': instance.totalFollowers,
      'good': instance.good,
      'normal': instance.normal,
      'bad': instance.bad,
      'rating': instance.rating,
      'photos': instance.photos,
      'createUser': instance.createUser,
      'followers': instance.followers,
      'comments': instance.comments,
    };
