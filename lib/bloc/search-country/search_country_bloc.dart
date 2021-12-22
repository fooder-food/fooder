import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_notification/bloc/search-country/search_country_repo.dart';
import 'package:flutter_notification/model/country_model.dart';

part 'search_country_event.dart';
part 'search_country_state.dart';

class SearchCountryBloc extends Bloc<RestaurantLocationEvent, SearchCountryState> {
  SearchCountryBloc({
    required SearchCountryRepo searchCountryRepo,
}) : _searchCountryRepo = searchCountryRepo,
     super(SearchCountryState()) {
    on<FetchAllCountry>(_fetchAllCountry);
    on<ReFetchAllCountry>(_refetchAllCountry);
    on<SearchCountry>(_searchCountry);
  }
  final SearchCountryRepo _searchCountryRepo;

  void _fetchAllCountry(
      FetchAllCountry event,
      Emitter<SearchCountryState> emit,
      ) async {
    emit(state.copyWith(status: CountryLoadingStatus.loading));
    try {
      final List<Country> countries = await _searchCountryRepo.fetchAllCountry();
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(
        countries: countries,
        status: CountryLoadingStatus.success,
      ));
    } catch(e) {
      emit(state.copyWith(status: CountryLoadingStatus.failed));
    }
  }

  void _refetchAllCountry(
      ReFetchAllCountry event,
      Emitter<SearchCountryState> emit,
      ) async {
    emit(state.copyWith(status: CountryLoadingStatus.loading));
    try {
      final List<Country> countries = await _searchCountryRepo.fetchAllCountry();
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(
        status: CountryLoadingStatus.success,
        countries: countries,
      ));
    } catch(e) {
      emit(state.copyWith(status: CountryLoadingStatus.failed));
    }
  }

  void _searchCountry(
      SearchCountry event,
      Emitter<SearchCountryState> emit,
      ) async {
    final String keyword = event.keyword.trim();
    final List<Country> countries = state.countries;
    List<Country> matchCountries = [...state.selectedCountries];
    if(keyword.isNotEmpty) {
      matchCountries = [... countries.where(
              (country) => (country.name.official.toLowerCase()).contains(keyword.toLowerCase())
      ).cast<Country>().toList()];
      emit(state.copyWith(status: CountryLoadingStatus.searchSuccess, selectedCountries: matchCountries));
    } else {
      emit(state.copyWith(status: CountryLoadingStatus.success));
    }


  }

}
