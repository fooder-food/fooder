import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_notification/bloc/notification/notification_repo.dart';
import 'package:flutter_notification/model/notification_model.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationRepo _notificationRepo = NotificationRepo();

  NotificationsBloc() : super(NotificationsState()) {
    on<FetchNotifications>(_fetchNotification);
    on<UpdateNotifications>(_updateNotification);
  }
  void _fetchNotification(
      FetchNotifications event,
      Emitter<NotificationsState> emit
      ) async {
    try {
      emit(state.copyWith(
        status: NotificationStatus.onLoad
      ));

      List<NotificationModel> notificationList = await _notificationRepo.fetchNotification();

      emit(state.copyWith(
          status: NotificationStatus.loadSuccess,
        notificationList: notificationList,
      ));

    } catch(e) {
      emit(state.copyWith(
        status: NotificationStatus.loadFailed,
      ));
    }
  }
  
  void _updateNotification(
      UpdateNotifications event,
      Emitter<NotificationsState> emit
      )async {
    try {
      emit(state.copyWith(
          status: NotificationStatus.setRead
      ));

      List<NotificationModel> notificationList = await _notificationRepo.updateNotificationIsRead(uniqueId: event.uniqueId);

      emit(state.copyWith(
        status: NotificationStatus.loadSuccess,
        notificationList: notificationList,
      ));

    } catch(e) {
      emit(state.copyWith(
        status: NotificationStatus.loadFailed,
      ));
    }
  }

}
