import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_notification/bloc/add-restaurant/add_restaurant_repo.dart';
import 'package:flutter_notification/model/address_component_model.dart';
import 'package:flutter_notification/model/restaurant_category_model.dart';

part 'add_restaurant_event.dart';
part 'add_restaurant_state.dart';

class AddRestaurantBloc extends Bloc<AddRestaurantEvent, AddRestaurantState> {
  AddRestaurantBloc({
    required AddRestaurantRepo addRestaurantRepo,
}) : _addRestaurantRepo = addRestaurantRepo,
   super(AddRestaurantState()) {
    on<FetchRestaurantCategoriesEvent>(_fetchRestaurantCategories);
    on<GetAdressEvent>(_getPlaceAddress);
    on<SetSelectedCategoryEvent>(_addSelectedCategory);
    on<SetRestaurantName>(_setRestaurantName);
    on<SetRestaurantPhoneNumber>(_setRestaurantPhone);
    on<SetRestaurantPhonePrefix>(_setPhonePrefix);
    on<SubmitAddRestaurantForm>(_submitAddRestaurant);
  }

  final AddRestaurantRepo _addRestaurantRepo;

  void _fetchRestaurantCategories(
      FetchRestaurantCategoriesEvent event,
      Emitter<AddRestaurantState> emit,
      ) async {

    try {
      emit(state.copyState(status: AddRestaurantFormStatus.onLoad));
      final List<RestaurantCategory> categories = await _addRestaurantRepo.fetchRestaurantCategories();
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyState(
          status:AddRestaurantFormStatus.loadCategoriesSuccess,
          categories: categories,
          selectedCategoyId: categories[0].uniqueId,
      ));
      emit(state.copyState(status: AddRestaurantFormStatus.loadAllSuccess));
    } catch (_) {
      emit(state.copyState(status: AddRestaurantFormStatus.failed));
    }
  }

  void _setRestaurantName(
      SetRestaurantName event,
      Emitter<AddRestaurantState> emit,
      ) {
    emit(state.copyState(status: AddRestaurantFormStatus.onInsertRestaurantName));
    String name =event.restaurantName;
    emit(state.copyState(restaurantName: name, status: AddRestaurantFormStatus.insertedRestaurantName));
  }

  void _setRestaurantPhone(
      SetRestaurantPhoneNumber event,
      Emitter<AddRestaurantState> emit,
      ) {
    emit(state.copyState(status: AddRestaurantFormStatus.onInsertPhone));
    String phone =event.phone;
    emit(state.copyState(phoneNumber: phone, status: AddRestaurantFormStatus.insertedPhone));
  }
  void _setPhonePrefix(
      SetRestaurantPhonePrefix event,
      Emitter<AddRestaurantState> emit,
      ) {
    emit(state.copyState(status: AddRestaurantFormStatus.onInsertPhone));
    String prefix =event.prefix;
    emit(state.copyState(phonePrefix: prefix, status: AddRestaurantFormStatus.insertedPhone));
  }

  void _getPlaceAddress(
      GetAdressEvent event,
      Emitter<AddRestaurantState> emit
      ) {
    final place = event.place;
    emit(state.copyState(status: AddRestaurantFormStatus.onLoad, placeDetails: place));
    emit(state.copyState(status: AddRestaurantFormStatus.loadAllSuccess));
  }

  void _addSelectedCategory(
      SetSelectedCategoryEvent event,
      Emitter<AddRestaurantState> emit
      ) {
    emit(state.copyState(status: AddRestaurantFormStatus.onSelecteCategory));
    String uniqueId = event.uniqueId;
    emit(state.copyState(selectedCategoyId: uniqueId));
    emit(state.copyState(status: AddRestaurantFormStatus.selectedCategory));
  }

  void _submitAddRestaurant(
      SubmitAddRestaurantForm event,
      Emitter<AddRestaurantState> emit
      ) {
    final String restaurantName = state.restaurantName;
    final String restaurantAddress = state.placeDetails!.address;
    final String phoneNumber = '${state.phonePrefix}${state.phoneNumber}';
    final String selectedCategoryId = state.selectedCategoyId!;

    print('${state.restaurantName}');
    print('${state.placeDetails!.placeId}');
    print('${state.phonePrefix}${state.phoneNumber}');
  }

}
