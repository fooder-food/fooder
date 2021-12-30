part of 'restaurant_details_bloc.dart';

enum RestaurantDetailStatus{
  initial,
  onLoadRestaurantData,
  loadRestaurantDataSuccess,
  loadFailed,
  onSetFavorite,
}

class RestaurantDetailsState extends Equatable {
  RestaurantDetailsState({
    this.status = RestaurantDetailStatus.initial,
    this.restaurant,
    this.isFavorite = false,
  });

  RestaurantDetailStatus status;
  RestaurantDetails? restaurant;
  bool isFavorite;

  RestaurantDetailsState copyWith({
    RestaurantDetailStatus? status,
    RestaurantDetails? restaurant,
    bool? isFavorite,
  }) => RestaurantDetailsState(
    status: status ?? this.status,
    restaurant: restaurant ?? this.restaurant,
    isFavorite: isFavorite ?? this.isFavorite,
  );

  @override
  // TODO: implement props
  List<Object?> get props => [status, restaurant, isFavorite];
}
