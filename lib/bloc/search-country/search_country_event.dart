part of 'search_country_bloc.dart';

abstract class RestaurantLocationEvent extends Equatable {
  const RestaurantLocationEvent();
  @override
  List<Object?> get props => [];
}

class FetchAllCountry extends RestaurantLocationEvent {}
class ReFetchAllCountry extends RestaurantLocationEvent {}
class SearchCountry extends RestaurantLocationEvent {
  const SearchCountry(this.keyword);
  final String keyword;
}
