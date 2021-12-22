part of 'restaurant_location_bloc.dart';

enum getAddressStatus {
  initial,
  selectedCountry,
  onLoading,
  onSearchLoading,
  noKeyword,
  findPlacesSuccess,
  onFindPlaceDetail,
  findPlaceDetailSuccess,
  failed,
  success,
}

class RestaurantLocationState extends Equatable {
  RestaurantLocationState({
    this.address = '',
    this.status = getAddressStatus.initial,
    this.selectedCountry,
    this.places = const [],
    this.selectedPlace,
  });

  String address;
  Country? selectedCountry;
  getAddressStatus status;
  List<GoogleAutoCompletePlace> places;
  AddressComponent? selectedPlace;

  RestaurantLocationState copyWith({
    String? address,
    Country? selectedCountry,
    getAddressStatus? status,
    List<GoogleAutoCompletePlace>? places,
    AddressComponent? selectedPlace,
  }) => RestaurantLocationState(
    address: address ?? this.address,
    selectedCountry: selectedCountry ?? this.selectedCountry,
    status: status ?? this.status,
    places: places ?? this.places,
    selectedPlace: selectedPlace ?? this.selectedPlace,
  );

  get selectedCountryIsNull => selectedCountry == null ? true : false;

  @override
  List<Object?> get props => [address, selectedCountry, status];
}
