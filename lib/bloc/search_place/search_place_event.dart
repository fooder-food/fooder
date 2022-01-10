part of 'search_place_bloc.dart';

class SearchPlaceEvent extends Equatable {
  const SearchPlaceEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchCountry extends SearchPlaceEvent {
  const FetchCountry();
}

class FetchStateBasedOnCountry extends SearchPlaceEvent {
  const FetchStateBasedOnCountry(this.code);
  final String code;
}
