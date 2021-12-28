import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_notification/bloc/home/home_repo.dart';
import 'package:flutter_notification/model/restaurant_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<FetchAllRestaurant>(_fetchRestaurant);
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
       final List<Restaurant> restaurants = await _homeRepo.fetchRestaurant();
      // print(restaurants);

      emit(state.copyWith(
        status: HomeStatus.loadRestaurantDataSuccess,
        restaurants: restaurants,
      ));
      print('test');

    } catch(e) {
      emit(state.copyWith(
        status: HomeStatus.loadFailed,
      ));
    }
  }
}
