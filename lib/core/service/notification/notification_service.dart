import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';



class NotificationService {

  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future init({bool isScheduled = false, SelectNotificationCallback? selectCallback}) async{
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(
      android:android,
    );
    await _notification.initialize(
        settings,
        onSelectNotification: selectCallback,
    );
  }


  static Future _notificationDetails() async {
    // final largeIconPath = await Utils.downloadFile(
    //     'https://images.unsplash.com/photo-1640101102811-6d2bc899468b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1734&q=80',
    //     'largeIcon'
    // );
    // final bigPicturePath = await Utils.downloadFile(
    //     'https://images.unsplash.com/photo-1640088097385-43a3fe062a4a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80',
    //     'largeIcon'
    // );
    // final styleInformation = BigPictureStyleInformation(
    //   // FilePathAndroidBitmap(bigPicturePath),
    //   // largeIcon: FilePathAndroidBitmap(largeIconPath),
    // );
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          channelDescription:  'channel description',
          importance: Importance.max,
        //  styleInformation:styleInformation
      ),
      iOS: IOSNotificationDetails(),
    );
  }
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notification.show(
          id,
          title,
          body,
          await _notificationDetails(),
          payload: payload
      );


}