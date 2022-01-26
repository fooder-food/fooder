import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_notification/bloc/home/home_repo.dart';
import 'package:flutter_notification/bloc/notification/notifications_bloc.dart';
import 'package:flutter_notification/model/auth_model.dart';
import 'package:flutter_notification/model/restaurant_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<FetchAllRestaurant>(_fetchRestaurant);
    on<GetNotificationCount>(_fetchNotificationCount);
  }

  final HomeRepo _homeRepo = HomeRepo();

  void _fetchRestaurant(
      FetchAllRestaurant event,
      Emitter<HomeState> emit,
   ) async {
    try {
      emit(state.copyWith(
        status: HomeStatus.onLoadRestaurantData,
      ));
      List<Restaurant> restaurants = [];
      if(event.state != null) {
        restaurants = await _homeRepo.fetchRestaurant(
          state: event.state,
          sort: event.sort,
          filter: event.filter,
        );
      } else {
        restaurants = await _homeRepo.fetchRestaurant(
          latitude: event.latitude,
          longitude: event.longitude,
          radius: event.radius,
          sort: event.sort,
          filter: event.filter,
        );
      }
      emit(state.copyWith(
        status: HomeStatus.loadRestaurantDataSuccess,
        restaurants: restaurants,
      ));


    } catch(e) {
      emit(state.copyWith(
        status: HomeStatus.loadFailed,
      ));
    }
  }

  void _fetchNotificationCount(
      GetNotificationCount event,
      Emitter<HomeState> emit,
      ) async {
    try {
      emit(state.copyWith(
        status: HomeStatus.loadUserNotificationCount,
      ));
      final count = await _homeRepo.fetchNotificationCount();
      emit(state.copyWith(
        status: HomeStatus.loadRestaurantDataSuccess,
        totalNotificationCount: count,
      ));
    } catch(e) {
      emit(state.copyWith(
        status: HomeStatus.loadFailed,
      ));
    }

  }
}
