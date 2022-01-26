part of 'notifications_bloc.dart';

enum NotificationStatus {
  initial,
  onLoad,
  setRead,
  loadSuccess,
  loadFailed,
}

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationStatus.initial,
    this.notificationList = const [],
  });

  final NotificationStatus status;
  final List<NotificationModel> notificationList;
  NotificationsState copyWith({
    NotificationStatus? status,
    List<NotificationModel>? notificationList,
})
  => NotificationsState(
    status: status ?? this.status,
    notificationList:  notificationList ?? this.notificationList,
  );


  @override
  // TODO: implement props
  List<Object?> get props => [status,notificationList];
}

