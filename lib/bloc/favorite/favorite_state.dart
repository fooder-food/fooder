part of 'favorite_bloc.dart';

enum FavoriteListStatus {
  initial,
  onLoad,
  loadSuccess,
  loadFailed,
}

class FavoriteState extends Equatable {
  const FavoriteState({
    this.favoriteList = const [],
    this.status = FavoriteListStatus.initial
  });
  final List<Favorite> favoriteList;
  final FavoriteListStatus status;

  FavoriteState copyWith({
    final List<Favorite>? favoriteList,
    final FavoriteListStatus? status,
  }) => FavoriteState(
    favoriteList: favoriteList ?? this.favoriteList,
    status: status ?? this.status,
  );

  @override
  List<Object> get props => [status, favoriteList];
}
