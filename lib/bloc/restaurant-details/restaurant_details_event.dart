part of 'restaurant_details_bloc.dart';

class RestaurantDetailsEvent extends Equatable {
  const RestaurantDetailsEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class FetchRestaurantInfo extends RestaurantDetailsEvent {
  const FetchRestaurantInfo(this.uniqueId, {
    this.userUniqueId
  });
  final String uniqueId;
  final String? userUniqueId;
}

class SetCommentLike extends RestaurantDetailsEvent {
  const SetCommentLike(this.commentUniqueId);
  final String commentUniqueId;
}

class SetRestaurantFavorite extends RestaurantDetailsEvent {
  const SetRestaurantFavorite(this.favorite, {
    this.restaurantUniqueId = '',
    this.userUniqueId = '',
    required this.uniqueId,
  });
  final bool favorite;
  final String restaurantUniqueId;
  final String userUniqueId;
  final String uniqueId;
}

class DeleteReview extends RestaurantDetailsEvent {
  const DeleteReview(this.uniqueId);
  final String uniqueId;
}

class FetchAllPhotos extends RestaurantDetailsEvent {
  const FetchAllPhotos(this.uniqueId);
  final String uniqueId;
}
