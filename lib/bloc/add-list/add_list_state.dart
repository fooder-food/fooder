part of 'add_list_bloc.dart';

enum CollectionListStatus {
  initial,
  onDelete,
  onLoad,
  deleteListSuccess,
  deleteSuccess,
  loadSuccess,
  onUpdate,
  updateSuccess,
  updateFailed,
  loadFailed,
  onCreateItem,
  createItemSuccess,
  createItemFailed,
  onFetchInfo,
  fetchInfoSuccess,
  fetchInfoFailed,
  onSearch,
  onAddedRestaurantToList,
  addedToListSuccess,
  onDelRestaurantToList,
  delFromListSuccess,
  searchSuccess,
  onReorder,
  reorderSuccess,
  onDeleteItem,
  deleteItemSuccess,
  reorderFailed,
  searchFailed
}

class AddListState extends Equatable {
  AddListState({
    this.list = const [],
    this.status = CollectionListStatus.initial,
    this.info,
    this.restaurants = const [],
  });

  final CollectionListStatus status;
  List<CollectionList> list;
  CollectionListInfo? info;
  List<ListSearchRestaurant> restaurants;

  AddListState copyWith({
    List<CollectionList>? list,
    CollectionListStatus? status,
    CollectionListInfo? info,
    List<ListSearchRestaurant>? restaurants,
  }) {
    return AddListState(
      list: list ?? this.list,
      status: status ?? this.status,
      info: info ?? this.info,
      restaurants:  restaurants ?? this.restaurants,
    );
  }


  @override
  // TODO: implement props
  List<Object?> get props => [status, list, info, restaurants];
}


