import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_notification/bloc/favorite/favorite_repo.dart';
import 'package:flutter_notification/model/favorite_model.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepo _favoriteRepo = FavoriteRepo();
  FavoriteBloc() : super(const FavoriteState()) {
    on<FetchFavorite>(_fetchFavorite);
  }

  void _fetchFavorite(
      FetchFavorite event,
      Emitter<FavoriteState> emit
      ) async {
    try {
      emit(state.copyWith(status: FavoriteListStatus.onLoad));
      final List<Favorite> favoriteList = await _favoriteRepo.fetchFavoriteList();
      emit(state.copyWith(status: FavoriteListStatus.loadSuccess, favoriteList: favoriteList));

    } catch(e) {
      emit(state.copyWith(status: FavoriteListStatus.loadFailed));
    }
  }
}
