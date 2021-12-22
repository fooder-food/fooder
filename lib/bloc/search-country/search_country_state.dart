part of 'search_country_bloc.dart';

enum CountryLoadingStatus{
  initial,
  loading,
  success,
  searchSuccess,
  failed,
}

class SearchCountryState extends Equatable {
  SearchCountryState({
    this.countries = const [],
    this.selectedCountries = const [],
    this.status = CountryLoadingStatus.initial,
  });
  List<Country> countries;
  List<Country> selectedCountries;
  final CountryLoadingStatus status;

  SearchCountryState copyWith({
    List<Country>? countries,
     List<Country>? selectedCountries,
     CountryLoadingStatus? status,
   }) {
     return SearchCountryState(
       countries: countries ?? this.countries,
       selectedCountries: selectedCountries ?? this.countries,
       status: status ?? this.status,
     );
  }

  @override
  List<Object?> get props => [countries, selectedCountries];
}
