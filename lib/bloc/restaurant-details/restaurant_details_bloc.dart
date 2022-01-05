import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_notification/bloc/restaurant-details/restaurant_details_repo.dart';
import 'package:flutter_notification/model/restaurant_details_model.dart';

part 'restaurant_details_event.dart';
part 'restaurant_details_state.dart';

class RestaurantDetailsBloc extends Bloc<RestaurantDetailsEvent, RestaurantDetailsState> {
  RestaurantDetailsBloc() : super(RestaurantDetailsState()) {
    on<FetchRestaurantInfo>(_fetchRestaurantInfo);
    on<SetRestaurantFavorite>(_addFavorite);
  }

  final RestaurantDetailsRepo _restaurantDetailsRepo = RestaurantDetailsRepo();

  void _fetchRestaurantInfo(
      FetchRestaurantInfo event,
      Emitter<RestaurantDetailsState> emit
      ) async {
    emit(state.copyWith(status: RestaurantDetailStatus.onLoadRestaurantData));
    try {
      bool isFavorite = false;
      final RestaurantDetails restaurant = await _restaurantDetailsRepo.fetchRestaurantData(uniqueId: event.uniqueId);
      print('user unique ${event.userUniqueId}');
      if(event.userUniqueId != null) {
        for(var i = 0; i < restaurant.followers.length; i++) {
          if(event.userUniqueId == restaurant.followers[i].uniqueId) {
            isFavorite = true;
          }
        }
      }

      emit(state.copyWith(status: RestaurantDetailStatus.loadRestaurantDataSuccess, restaurant: restaurant, isFavorite: isFavorite));
    } catch (e) {
      emit(state.copyWith(status: RestaurantDetailStatus.loadFailed));
    }
  }

  Future<void> _addFavorite(
      SetRestaurantFavorite event,
      Emitter<RestaurantDetailsState> emit
      ) async {
      emit(state.copyWith(status: RestaurantDetailStatus.onSetFavorite));
      if(event.userUniqueId.isNotEmpty && event.restaurantUniqueId.isNotEmpty) {
        if(event.favorite) {
          await _restaurantDetailsRepo.addFavorite(
              userUniqueId: event.userUniqueId,
              restaurantUniqueId: event.restaurantUniqueId);

        } else {
          final follower = state.restaurant!.followers.where((element) => element.uniqueId == event.userUniqueId).toList()[0];
          await _restaurantDetailsRepo.delFavorite(uniqueId: follower.favoriteUniqueId);
        }
      }
      final RestaurantDetails restaurant = await _restaurantDetailsRepo.fetchRestaurantData(uniqueId: event.uniqueId);
      emit(state.copyWith(
        status: RestaurantDetailStatus.loadRestaurantDataSuccess,isFavorite: event.favorite, restaurant: restaurant));
  }
}