part of 'notifications_bloc.dart';

class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class FetchNotifications extends NotificationsEvent {
  const FetchNotifications();
}

class UpdateNotifications extends NotificationsEvent {
  const UpdateNotifications(this.uniqueId);
  final String uniqueId;
}
