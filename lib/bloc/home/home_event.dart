part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class FetchAllRestaurant extends HomeEvent {
  const FetchAllRestaurant({
    this.radius,
    this.longitude,
    this.latitude,
});
  final double? radius;
  final double? latitude;
  final double? longitude;
}
