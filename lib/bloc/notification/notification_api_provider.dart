
import 'package:flutter/material.dart';
import 'package:flutter_notification/core/service/network/network_service.dart';
import 'package:flutter_notification/model/notification_model.dart';


class NotificationApiProvider {
  final NetworkService _networkService = NetworkService();

  Future<List<NotificationModel>> fetchNotification() async{

    try {
      final response = await _networkService.get('users/notifications');
      final data = response.data["data"];
      final List<NotificationModel> notificationList = List.from(
        data.map((restaurant) => NotificationModel.fromJson(restaurant)),
      );
      return notificationList;

    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }

  Future<List<NotificationModel>> updateNotificationIsRead({
   required String uniqueId,
  }) async{

    try {
      final body = {
        "uniqueId": uniqueId,
      };
      final response = await _networkService.put('users/notifications', data: body);
      final data = response.data!["data"];
      final List<NotificationModel> notificationList = List.from(
        data.map((restaurant) => NotificationModel.fromJson(restaurant)),
      );
      return notificationList;

    } catch(e) {
      debugPrint("err cat: ${e.toString()}");
      throw Exception(e);
    }
  }
}