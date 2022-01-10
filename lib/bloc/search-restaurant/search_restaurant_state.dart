part of 'search_restaurant_bloc.dart';
enum SearchRestaurantStatus {
  initial,
  onSearch,
  searchSuccess,
  searchFailed,
  onGetHistory,
  getHistoryFailed,
  getHistorySuccess,
}
class SearchRestaurantState extends Equatable {
  SearchRestaurantState({
    this.restaurants = const [],
    this.historyList = const [],
    this.status = SearchRestaurantStatus.initial
  });

  List<SearchRestaurant> restaurants;
  List<RestaurantSearchHistory> historyList;
  final SearchRestaurantStatus status;

  SearchRestaurantState copyWith({
    List<SearchRestaurant>? restaurants,
    List<RestaurantSearchHistory>? historyList,
    SearchRestaurantStatus? status
  }) {
    return SearchRestaurantState(
      status: status ?? this.status,
      restaurants: restaurants ?? this.restaurants,
      historyList: historyList ?? this.historyList,
    );
}

  @override
  // TODO: implement props
  List<Object?> get props => [restaurants, status];
}
