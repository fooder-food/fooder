part of 'add_restaurant_bloc.dart';

enum AddRestaurantFormStatus {
  initial,
  onLoad,
  onAddRestaurantImage,
  addedRestaurantImage,
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
  onAddRestaurant,
  addRestaurantSuccess,
  addRestaurantFailed,
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
    this.image,
  });

  String restaurantName;
  AddressComponent? placeDetails;
  AddRestaurantFormStatus? status;
  List<RestaurantCategory> categories;
  String? selectedCategoyId;
  String? phoneNumber;
  String? phonePrefix;
  XFile? image;

  AddRestaurantState copyState({
    String? restaurantName,
    AddressComponent? placeDetails,
    List<RestaurantCategory>? categories,
    String? selectedCategoyId,
    AddRestaurantFormStatus? status,
    String? phoneNumber,
    String? phonePrefix = "+60",
    XFile? image,
  }) {
    return AddRestaurantState(
      restaurantName: restaurantName ?? this.restaurantName,
      placeDetails: placeDetails ?? this.placeDetails,
      categories: categories ?? this.categories,
      selectedCategoyId: selectedCategoyId ?? this.selectedCategoyId,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phonePrefix:  phonePrefix ?? this.phonePrefix,
      image: image ?? this.image,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [restaurantName, placeDetails, status, categories, selectedCategoyId, image];

}

