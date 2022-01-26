import 'package:flutter_notification/bloc/home/home_api_provider.dart';
import 'package:flutter_notification/bloc/notification/notification_api_provider.dart';
import 'package:flutter_notification/model/notification_model.dart';
import 'package:flutter_notification/model/restaurant_model.dart';



class NotificationRepo {
  factory NotificationRepo() {
    return _instance;
  }

  NotificationRepo._constructor();

  static final NotificationRepo _instance = NotificationRepo._constructor();
  final NotificationApiProvider _notificationApiProvider = NotificationApiProvider();

  Future<List<NotificationModel>> fetchNotification() async => _notificationApiProvider.fetchNotification();
  Future<List<NotificationModel>> updateNotificationIsRead({
    required String uniqueId,
  }) async => _notificationApiProvider.updateNotificationIsRead(uniqueId: uniqueId);
}