part of 'restaurant_details_bloc.dart';

enum RestaurantDetailStatus{
  initial,
  onLoadRestaurantData,
  onLike,
  onDel,
  delSuccessful,
  delFailed,
  likeSuccessful,
  likeFailed,
  loadRestaurantDataSuccess,
  loadFailed,
  onSetFavorite,
}

class RestaurantDetailsState extends Equatable {
  RestaurantDetailsState({
    this.status = RestaurantDetailStatus.initial,
    this.restaurant,
    this.isFavorite = false,
    this.photos = const [],
  });

  RestaurantDetailStatus status;
  RestaurantDetails? restaurant;
  List<RestaurantCommentPhoto> photos;
  bool isFavorite;

  RestaurantDetailsState copyWith({
    RestaurantDetailStatus? status,
    RestaurantDetails? restaurant,
    bool? isFavorite,
    List<RestaurantCommentPhoto>? photos,
  }) => RestaurantDetailsState(
    status: status ?? this.status,
    restaurant: restaurant ?? this.restaurant,
    isFavorite: isFavorite ?? this.isFavorite,
    photos: photos ?? this.photos,
  );

  @override
  // TODO: implement props
  List<Object?> get props => [status, restaurant, isFavorite, photos];
}
