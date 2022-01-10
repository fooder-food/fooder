part of 'search_place_bloc.dart';
enum SearchPlaceStatus{
  initial,
  loading,
  success,
  failed,
}

class SearchPlaceState extends Equatable {
  const SearchPlaceState({
    this.status = SearchPlaceStatus.initial,
    this.countries = const [],
    this.states = const [],
});

  final SearchPlaceStatus status;
  final List<FindPlaceCountry> countries;
  final List<FindPlaceState> states;

  SearchPlaceState copyWith({
    SearchPlaceStatus? status,
    List<FindPlaceCountry>? countries,
    List<FindPlaceState>? states,
  }) {
    return SearchPlaceState(
      status: status ?? this.status,
      countries: countries ?? this.countries,
      states: states ?? this.states,
    );
  }
  @override
  // TODO: implement props
  List<Object?> get props => [countries, status,states];
}


