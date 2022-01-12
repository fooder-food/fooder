part of 'add_restaurant_bloc.dart';

abstract class AddRestaurantEvent extends Equatable {
  const AddRestaurantEvent();
  @override
  List<Object?> get props => [];
}

class FetchRestaurantCategoriesEvent extends AddRestaurantEvent {}

class GetAdressEvent extends AddRestaurantEvent {
  GetAdressEvent(this.place);
  AddressComponent place;
}

class SetSelectedCategoryEvent extends AddRestaurantEvent {
  SetSelectedCategoryEvent(this.uniqueId);
  String uniqueId;
}

class SubmitAddRestaurantForm extends AddRestaurantEvent {}

class SetRestaurantName extends AddRestaurantEvent {
  SetRestaurantName(this.restaurantName);
  String restaurantName;
}

class SetRestaurantPhoneNumber extends AddRestaurantEvent {
  SetRestaurantPhoneNumber(this.phone);
  String phone;
}

class SetRestaurantPhonePrefix extends AddRestaurantEvent {
  SetRestaurantPhonePrefix(this.prefix);
  String prefix;
}

class SetRestaurantImage extends AddRestaurantEvent {
  SetRestaurantImage(this.file);
  XFile file;
}