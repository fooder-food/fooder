part of 'add_list_bloc.dart';

class AddListEvent extends Equatable {
  const AddListEvent();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class FetchList extends AddListEvent {
  const FetchList();
}

class AddSingleList extends AddListEvent {
  const AddSingleList({
    required this.title,
    required this.description,
  });
  final String title;
  final String description;
}

class FetchListInfo extends AddListEvent {
  const FetchListInfo({
    required this.uniqueId,
  });
  final String uniqueId;
}

class ReOrderListItem extends AddListEvent {
  const ReOrderListItem({
    required this.oldIndex,
    required this.newIndex,
  });
  final int oldIndex;
  final int newIndex;
}

class DeleteListItem extends AddListEvent {
  const DeleteListItem(this.index);
  final int index;
}

class SearchRestaurantByKeyword extends AddListEvent {
  const SearchRestaurantByKeyword(this.keyword, this.listUniqueId);
  final String keyword;
  final String listUniqueId;
}

class AddRestaurantBySearch extends AddListEvent {
  const AddRestaurantBySearch({
    required this.keyword,
    required this.restaurantUniqueId,
    required this.collectionUniqueId
  });
  final String keyword;
  final String restaurantUniqueId;
  final String collectionUniqueId;
}

class DelRestaurantBySearch extends AddListEvent {
  const DelRestaurantBySearch({
    required this.keyword,
    required this.restaurantUniqueId,
    required this.collectionUniqueId
  });
  final String keyword;
  final String restaurantUniqueId;
  final String collectionUniqueId;
}