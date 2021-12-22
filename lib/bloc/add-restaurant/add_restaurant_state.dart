part of 'add_restaurant_bloc.dart';

enum AddRestaurantFormStatus {
  initial,
  onLoad,
  onInsertRestaurantName,
  insertedRestaurantName,
  onInsertPhone,
  insertedPhone,
  onLoadCategories,
  loadCategoriesSuccess,
  loadCategoriesLoadFailed,
  loadAllSuccess,
  onSelecteCategory,
  selectedCategory,
  failed,
  success,
}


class AddRestaurantState extends Equatable {
  AddRestaurantState({
    this.restaurantName = "",
    this.placeDetails,
    this.categories = const [],
    this.status = AddRestaurantFormStatus.initial,
    this.selectedCategoyId,
    this.phoneNumber = "",
    this.phonePrefix = "",
  });

  String restaurantName;
  AddressComponent? placeDetails;
  AddRestaurantFormStatus? status;
  List<RestaurantCategory> categories;
  String? selectedCategoyId;
  String? phoneNumber;
  String? phonePrefix;

  AddRestaurantState copyState({
    String? restaurantName,
    AddressComponent? placeDetails,
    List<RestaurantCategory>? categories,
    String? selectedCategoyId,
    AddRestaurantFormStatus? status,
    String? phoneNumber,
    String? phonePrefix = "+60",
  }) {
    return AddRestaurantState(
      restaurantName: restaurantName ?? this.restaurantName,
      placeDetails: placeDetails ?? this.placeDetails,
      categories: categories ?? this.categories,
      selectedCategoyId: selectedCategoyId ?? this.selectedCategoyId,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phonePrefix:  phonePrefix ?? this.phonePrefix,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [restaurantName, placeDetails, status, categories, selectedCategoyId];

}

