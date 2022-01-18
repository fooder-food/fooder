import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_notification/bloc/search-restaurant/search_restaurant_repo.dart';
import 'package:flutter_notification/core/service/storage/storage_service.dart';
import 'package:flutter_notification/model/restaurant_search_history_model.dart';
import 'package:flutter_notification/model/search_restaurant_model.dart';

part 'search_restaurant_event.dart';
part 'search_restaurant_state.dart';

class SearchRestaurantBloc extends Bloc<SearchRestaurantEvent, SearchRestaurantState> {

  final SearchRestaurantRepo _searchRestaurantRepo = SearchRestaurantRepo();

  SearchRestaurantBloc() : super(SearchRestaurantState()) {
    on<SearchResturantByKeyword>(_searchRestaurant);
    on<GetSearchHistory>(_getSearchHistory);
    on<GetLocalSearchHistory>(_getLocalSearchHistory);
    on<DelLocalSearchHistory>(_deleteLocalSearchHistory);
    on<DelSearchHistory>(_deleteSearchHistory);
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

  void _getLocalSearchHistory(
      GetLocalSearchHistory event,
      Emitter<SearchRestaurantState> emit
      ) async {
    try {
      emit(state.copyWith(
        status: SearchRestaurantStatus.onGetHistory,
      ));

      print('tst');

      final rawHistoryList = await StorageService().getByKey('history_list') ?? '';
      final historyList = rawHistoryList == '' ? '' : jsonDecode(rawHistoryList);
      print(historyList);
      if(historyList is String) {
        emit(state.copyWith(
          status: SearchRestaurantStatus.getHistorySuccess,
        ));
      } else {
        final newHistoryList = (historyList as List).map((e) => RestaurantSearchHistory.fromJson(e)).toList();
        emit(state.copyWith(
          status: SearchRestaurantStatus.getHistorySuccess,
          historyList: newHistoryList,
        ));
      }


    } catch(e) {
      emit(state.copyWith(
        status: SearchRestaurantStatus.getHistoryFailed,
      ));
    }
  }

  void _deleteLocalSearchHistory(
      DelLocalSearchHistory event,
      Emitter<SearchRestaurantState> emit
      ) async {
    try {
      emit(state.copyWith(
        status: SearchRestaurantStatus.onGetHistory,
      ));
      final rawHistoryList = await StorageService().getByKey('history_list') ?? '';
      final historyList = rawHistoryList == '' ? '' : jsonDecode(rawHistoryList);

      List<RestaurantSearchHistory> newHistoryList = (historyList as List).map((e) => RestaurantSearchHistory.fromJson(e)).toList();
      newHistoryList.removeWhere((element) => element.restaurantUniqueId == event.history.restaurantUniqueId);
      final String historyListEncode = jsonEncode(newHistoryList);
      await StorageService().setStr('history_list', historyListEncode);
      emit(state.copyWith(
        status: SearchRestaurantStatus.getHistorySuccess,
        historyList: newHistoryList,
      ));
    } catch(e) {
      emit(state.copyWith(
        status: SearchRestaurantStatus.getHistoryFailed,
      ));
    }
  }

  void _deleteSearchHistory(
      DelSearchHistory event,
      Emitter<SearchRestaurantState> emit
      ) async {
    try {
      emit(state.copyWith(
        status: SearchRestaurantStatus.onGetHistory,
      ));
      List<RestaurantSearchHistory> newHistoryList = await _searchRestaurantRepo.delSearchHistory(uniqueId: event.restaurantUniqueId);
      print(newHistoryList);
      emit(state.copyWith(
        status: SearchRestaurantStatus.getHistorySuccess,
        historyList: newHistoryList,
      ));
    } catch(e) {
      emit(state.copyWith(
        status: SearchRestaurantStatus.getHistoryFailed,
      ));
    }
  }
}
