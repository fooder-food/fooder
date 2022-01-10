import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_notification/bloc/search-restaurant/search_restaurant_repo.dart';
import 'package:flutter_notification/model/restaurant_search_history_model.dart';
import 'package:flutter_notification/model/search_restaurant_model.dart';

part 'search_restaurant_event.dart';
part 'search_restaurant_state.dart';

class SearchRestaurantBloc extends Bloc<SearchRestaurantEvent, SearchRestaurantState> {

  final SearchRestaurantRepo _searchRestaurantRepo = SearchRestaurantRepo();

  SearchRestaurantBloc() : super(SearchRestaurantState()) {
    on<SearchResturantByKeyword>(_searchRestaurant);
    on<GetSearchHistory>(_getSearchHistory);
  }

  void _searchRestaurant(
      SearchResturantByKeyword event,
      Emitter<SearchRestaurantState> emit,
      ) async {
      try {
        emit(state.copyWith(
          status: SearchRestaurantStatus.onSearch,
        ));
       List<SearchRestaurant> restaurants = await _searchRestaurantRepo.fetchRestaurant(keyword: event.keyword);
       print(restaurants);
        emit(state.copyWith(
          restaurants: restaurants,
          status: SearchRestaurantStatus.searchSuccess,
        ));
      } catch(e) {
        emit(state.copyWith(
          status: SearchRestaurantStatus.searchFailed,
        ));
      }
  }

  void _getSearchHistory(
      GetSearchHistory event,
      Emitter<SearchRestaurantState> emit
      ) async {
    try {
      emit(state.copyWith(
        status: SearchRestaurantStatus.onGetHistory,
      ));
      List<RestaurantSearchHistory> historyList = await _searchRestaurantRepo.fetchSearchHistory();
      emit(state.copyWith(
        historyList: historyList,
        status: SearchRestaurantStatus.getHistorySuccess,
      ));
    } catch(e) {
      emit(state.copyWith(
        status: SearchRestaurantStatus.getHistoryFailed,
      ));
    }
  }
}
