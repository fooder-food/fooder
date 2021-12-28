part of 'restaurant_location_bloc.dart';

abstract class RestaurantLocationEvent extends Equatable {
  const RestaurantLocationEvent();
  @override
  List<Object?> get props => [];
}

class SelectCountry extends RestaurantLocationEvent {
  SelectCountry(this.selectedCountry);
  Country selectedCountry;
}

class GoogleSearchPlaces extends RestaurantLocationEvent {
  const GoogleSearchPlaces(this.keyword, this.countryCode);
  final String keyword;
  final String? countryCode;
}

class SelectAddress extends RestaurantLocationEvent {
  const SelectAddress(this.placeId, this.address, {
    this.geo,
  });
  final String placeId;
  final String address;
  final GooglePlaceLocation? geo;
}

class GetGooglePlaceDetails extends RestaurantLocationEvent {
  const GetGooglePlaceDetails(this.placeId);
  final String placeId;
}

class SelectGoogleMapAddress extends RestaurantLocationEvent {
  const SelectGoogleMapAddress(this.longitude, this.latitude);
  final String longitude;
  final String latitude;
}

