import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_notification/bloc/search_place/search_place_repo.dart';
import 'package:flutter_notification/model/find_place_country_model.dart';
import 'package:flutter_notification/model/find_place_state_model.dart';

part 'search_place_event.dart';
part 'search_place_state.dart';

class SearchPlaceBloc extends Bloc<SearchPlaceEvent, SearchPlaceState> {
  final SearchPlaceRepo _searchCountryRepo = SearchPlaceRepo();
  SearchPlaceBloc() : super(const SearchPlaceState()) {
    on<FetchCountry>(_fetchCountry);
    on<FetchStateBasedOnCountry>(_fetchState);
  }

  void _fetchCountry(
      FetchCountry event,
      Emitter<SearchPlaceState> emit,
      ) async {
     try {
       emit(state.copyWith(
         status: SearchPlaceStatus.loading,
       ));
       List<FindPlaceCountry> countries = await _searchCountryRepo.fetchAllCountry();
       print(countries);
       emit(state.copyWith(
         status: SearchPlaceStatus.success,
         countries: countries,
       ));
     } catch(e) {
       emit(state.copyWith(
         status: SearchPlaceStatus.failed,
       ));
     }
  }

  void _fetchState(
      FetchStateBasedOnCountry event,
      Emitter<SearchPlaceState> emit,
      ) async {
    try {
      emit(state.copyWith(
        status: SearchPlaceStatus.loading,
      ));
      List<FindPlaceState> states = await _searchCountryRepo.fetchAllState(code: event.code);
      print(states);
      emit(state.copyWith(
        status: SearchPlaceStatus.success,
        states: states,
      ));
    } catch(e) {
      emit(state.copyWith(
        status: SearchPlaceStatus.failed,
      ));
    }
  }
}
