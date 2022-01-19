
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_notification/bloc/add-list/add_list_repo.dart';
import 'package:flutter_notification/model/collection_list_info_model.dart';
import 'package:flutter_notification/model/list_model.dart';
import 'package:flutter_notification/model/list_search_restaurant_model.dart';

part 'add_list_event.dart';
part 'add_list_state.dart';

class AddListBloc extends Bloc<AddListEvent, AddListState> {

  final AddListRepo _addListRepo = AddListRepo();

  AddListBloc() : super(AddListState()) {
    on<FetchList>(_fetchList);
    on<AddSingleList>(_addNewList);
    on<UpdateList>(_updateList);
    on<DelList>(_delList);
    on<CreateListItem>(_createListItem);
    on<FetchListInfo>(_fetchListInfo);
    on<ReOrderListItem>(_reOrderListItem);
    on<ReOrderConfirm>(_reoderListItemConfirm);
    on<DeleteListItem>(_delListItem);
    on<SearchRestaurantByKeyword>(_searchRestaurant);
    on<AddRestaurantBySearch>(_addRestaurantBySearch);
    on<DelRestaurantBySearch>(_delRestaurantBySearch);
  }

  void _fetchList(
     FetchList event,
     Emitter<AddListState> emit
  ) async {
    try {
      emit(state.copyWith(status: CollectionListStatus.onLoad));
      final list = await _addListRepo.fetchList();
      print(list);
      emit(state.copyWith(status: CollectionListStatus.loadSuccess, list: list));

    } catch(e) {
      emit(state.copyWith(status: CollectionListStatus.loadFailed));
    }
  }

  void _createListItem(
      CreateListItem event,
      Emitter<AddListState> emit
      ) async {
    try {
      emit(state.copyWith(status: CollectionListStatus.onCreateItem));
      await _addListRepo.createListItem(
          restaurantUniqueId: event.restaurantUniqueId,
          collectionUniqueId: event.collectionUniqueId
      );
      emit(state.copyWith(status: CollectionListStatus.createItemSuccess,));

    } catch(e) {
      emit(state.copyWith(status: CollectionListStatus.createItemFailed));
    }
  }

  void _fetchListInfo(
      FetchListInfo event,
      Emitter<AddListState> emit
      ) async {
    try {
      emit(state.copyWith(status: CollectionListStatus.onFetchInfo, info: null));
      final info = await _addListRepo.fetchInfo(uniqueId: event.uniqueId);
      print('items ${info.items.length}');
      emit(state.copyWith(status: CollectionListStatus.fetchInfoSuccess, info: info));

    } catch(e) {
      emit(state.copyWith(status: CollectionListStatus.fetchInfoFailed));
    }
  }

  void _addNewList(
      AddSingleList event,
      Emitter<AddListState> emit
     ) async {
    try {
      emit(state.copyWith(status: CollectionListStatus.onLoad));
      final list = await _addListRepo.addNewList(title: event.title, description: event.description);
      print(list);
      emit(state.copyWith(status: CollectionListStatus.loadSuccess, list: list));

    } catch(e) {
      emit(state.copyWith(status: CollectionListStatus.loadFailed));
    }
  }

  void _updateList(
      UpdateList event,
      Emitter<AddListState> emit
      ) async {
    final oldInfo = state.info!;
    try {
      emit(state.copyWith(status: CollectionListStatus.onUpdate, info: null));
      final info = await _addListRepo.updateList(
        title: event.title,
        description: event.description,
        uniqueId: event.uniqueId,
      );
      emit(state.copyWith(status: CollectionListStatus.updateSuccess, info: info));

    } catch(e) {
      emit(state.copyWith(status: CollectionListStatus.updateFailed, info: oldInfo));
    }
  }

  void _delList(
      DelList event,
      Emitter<AddListState> emit
      ) async {
    try {
      emit(state.copyWith(status: CollectionListStatus.onDelete));
      final list = await _addListRepo.deleteList(listUniqueId: event.listUniqueId);
      emit(state.copyWith(status: CollectionListStatus.deleteListSuccess, list: list));

    } catch(e) {
      print('error $e');
      emit(state.copyWith(status: CollectionListStatus.loadFailed));
    }
  }

  void _reOrderListItem(
      ReOrderListItem event,
      Emitter<AddListState> emit
      ) {
    emit(state.copyWith(status: CollectionListStatus.onLoad));
    print(event.oldIndex);
    print(event.newIndex);
    int oldIndex = event.oldIndex;
    int newIndex = event.newIndex;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final oldItemOrder = state.info!.items[oldIndex].order;
    state.info!.items[oldIndex].order = state.info!.items[newIndex].order;
    state.info!.items[newIndex].order = oldItemOrder;
    state.info!.items.sort((current, next) =>current.order.compareTo(next.order));
    // oldInfo.items.removeAt(event.oldIndex);
    // oldInfo.items.insert(event.newIndex, oldInfo.items[newIndex]);
    emit(state.copyWith(status: CollectionListStatus.loadSuccess,));
  }

  void _reoderListItemConfirm(
      ReOrderConfirm event,
      Emitter<AddListState> emit
      ) async {
    try {
      emit(state.copyWith(
        status: CollectionListStatus.onReorder,
      ));
      final CollectionListInfo info = await _addListRepo.reorderItem(
          listUniqueId: event.listUnique,
          newOrderList: state.info!.items
      );
      emit(state.copyWith(
        status: CollectionListStatus.reorderSuccess,
        info: info,
      ));
    } catch(e) {
      emit(state.copyWith(
        status: CollectionListStatus.reorderFailed,
      ));
    }
  }

  void _delListItem(
      DeleteListItem event,
      Emitter<AddListState> emit
      ) async {
    try {
      emit(state.copyWith(status: CollectionListStatus.onLoad));
      final CollectionListInfo info = await _addListRepo.deleteItem(
          listUniqueId: event.listUniqueId,
          itemUniqueId: event.itemUniqueId
      );

      emit(state.copyWith(status: CollectionListStatus.loadSuccess, info: info));
    } catch(e) {
      emit(state.copyWith(status: CollectionListStatus.loadFailed,));
    }
  }


  void _searchRestaurant(
      SearchRestaurantByKeyword event,
      Emitter<AddListState> emit,
      ) async {
    try {
      emit(state.copyWith(
        status: CollectionListStatus.onSearch,
      ));
      final List<ListSearchRestaurant> restaurants = await _addListRepo.fetchRestaurant(
          keyword: event.keyword,
          listUniqueId: event.listUniqueId
      );
      print('restaurants $restaurants');
      emit(state.copyWith(
        restaurants: restaurants,
        status: CollectionListStatus.searchSuccess,
      ));
    } catch(e) {
      emit(state.copyWith(
        status: CollectionListStatus.searchFailed,
      ));
    }
  }

  void _addRestaurantBySearch(
      AddRestaurantBySearch event,
      Emitter<AddListState> emit,
      ) async {
    try {
      emit(state.copyWith(
        status: CollectionListStatus.onAddedRestaurantToList,
      ));
      final List<ListSearchRestaurant> restaurants = await _addListRepo.addRestaurantBySearch(
          keyword: event.keyword,
          restaurantUniqueId: event.restaurantUniqueId,
          collectionUniqueId: event.collectionUniqueId,
      );
      print('restaurants $restaurants');
      emit(state.copyWith(
        status: CollectionListStatus.addedToListSuccess,
        restaurants: restaurants,
      ));
    } catch(e) {
      emit(state.copyWith(
        status: CollectionListStatus.searchFailed,
      ));
    }
  }

  void _delRestaurantBySearch(
      DelRestaurantBySearch event,
      Emitter<AddListState> emit,
      ) async {
    try {
      emit(state.copyWith(
        status: CollectionListStatus.onDelRestaurantToList,
      ));
      final List<ListSearchRestaurant> restaurants = await _addListRepo.delRestaurantBySearch(
        keyword: event.keyword,
        restaurantUniqueId: event.restaurantUniqueId,
        collectionUniqueId: event.collectionUniqueId,
      );
      print('restaurants $restaurants');
      emit(state.copyWith(
        status: CollectionListStatus.delFromListSuccess,
        restaurants: restaurants,
      ));
    } catch(e) {
      emit(state.copyWith(
        status: CollectionListStatus.searchFailed,
      ));
    }
  }
}
