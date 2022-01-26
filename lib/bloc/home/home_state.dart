part of 'home_bloc.dart';

enum HomeStatus{
  initial,
  onLoadRestaurantData,
  loadUserNotificationCount,
  loadRestaurantDataSuccess,
  loadFailed,
}

class HomeState extends Equatable {
  HomeState({
    this.status = HomeStatus.initial,
    this.restaurants = const [],
    this.totalNotificationCount,
  });

  HomeStatus? status;
  List<Restaurant> restaurants;
  int? totalNotificationCount;

  HomeState copyWith({
    HomeStatus? status,
    List<Restaurant>? restaurants,
    int? totalNotificationCount
  }) => HomeState(
    status: status ?? this.status,
    restaurants: restaurants ?? this.restaurants,
    totalNotificationCount: totalNotificationCount ?? this.totalNotificationCount,
  );

  @override
  // TODO: implement props
  List<Object?> get props => [status, restaurants, totalNotificationCount];
}

