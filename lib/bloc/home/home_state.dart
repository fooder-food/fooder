part of 'home_bloc.dart';

enum HomeStatus{
  initial,
  onLoadRestaurantData,
  loadRestaurantDataSuccess,
  loadFailed,
}

class HomeState extends Equatable {
  HomeState({
    this.status = HomeStatus.initial,
    this.restaurants = const [],
  });

  HomeStatus? status;
  List<Restaurant> restaurants;

  HomeState copyWith({
    HomeStatus? status,
    List<Restaurant>? restaurants,
  }) => HomeState(
    status: status ?? this.status,
    restaurants: restaurants ?? this.restaurants,
  );

  @override
  // TODO: implement props
  List<Object?> get props => [status, restaurants];
}

