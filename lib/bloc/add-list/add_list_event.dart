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

class UpdateList extends AddListEvent {
  const UpdateList({
    required this.uniqueId,
    required this.title,
    required this.description
  });
  final String uniqueId;
  final String title;
  final String description;
}

class DelList extends AddListEvent {
  const DelList(this.listUniqueId);
  final String listUniqueId;
}

class CreateListItem extends AddListEvent {
  const CreateListItem({
    required this.restaurantUniqueId,
    required this.collectionUniqueId,
  });
  final String restaurantUniqueId;
  final String collectionUniqueId;
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

class ReOrderConfirm extends AddListEvent {
  const ReOrderConfirm(this.listUnique);
  final String listUnique;
}

class DeleteListItem extends AddListEvent {
  const DeleteListItem({
    required this.itemUniqueId,
    required this.listUniqueId
  });
  final String itemUniqueId;
  final String listUniqueId;
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
