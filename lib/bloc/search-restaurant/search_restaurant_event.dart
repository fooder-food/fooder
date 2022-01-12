part of 'search_restaurant_bloc.dart';

class SearchRestaurantEvent extends Equatable {
  const SearchRestaurantEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SearchResturantByKeyword extends SearchRestaurantEvent {
  SearchResturantByKeyword(this.keyword);
  final String keyword;
}

class GetSearchHistory extends SearchRestaurantEvent {
  const GetSearchHistory();
}

class GetLocalSearchHistory extends SearchRestaurantEvent {
  const GetLocalSearchHistory();
}

class DelLocalSearchHistory extends SearchRestaurantEvent {
  const DelLocalSearchHistory(this.history);
  final RestaurantSearchHistory history;
}

class DelSearchHistory extends SearchRestaurantEvent {
  const DelSearchHistory(this.restaurantUniqueId);
  final String restaurantUniqueId;
}
