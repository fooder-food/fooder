import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_notification/bloc/restaurant-location/restaurant_location_repo.dart';
import 'package:flutter_notification/model/address_component_model.dart';
import 'package:flutter_notification/model/country_model.dart';
import 'package:flutter_notification/model/google_autocomplete_place_model.dart';
import 'package:flutter_notification/model/google_place_location_model.dart';

part 'restaurant_location_event.dart';
part 'restaurant_location_state.dart';

class RestaurantLocationBloc extends Bloc<RestaurantLocationEvent, RestaurantLocationState> {
  RestaurantLocationBloc() : super(RestaurantLocationState()) {
    on<SelectCountry>(_selectCountry);
    on<GoogleSearchPlaces>(_googleSearchPlaces);
    // on<GetGooglePlaceDetails>(_getGooglePlaceDetails);
    on<SelectAddress>(_selectAddress);
  }

  final RestaurantLocationRepo _restaurantLocationRepo = RestaurantLocationRepo();

  void _selectCountry(
      SelectCountry event,
      Emitter<RestaurantLocationState> emit
      ) {
    final Country selectedCountry = event.selectedCountry;
    emit(state.copyWith(
      selectedCountry: selectedCountry,
      status: getAddressStatus.selectedCountry,
    ));
  }

  void _googleSearchPlaces(
      GoogleSearchPlaces event,
      Emitter<RestaurantLocationState> emit,
      ) async {
    emit(state.copyWith(status: getAddressStatus.onSearchLoading));
    final keyword = event.keyword.trim();
    final countryCode = event.countryCode;
    if(keyword.isEmpty) {
      emit(state.copyWith(status: getAddressStatus.noKeyword, places: []));
    }
    try {
        final List<GoogleAutoCompletePlace> places = await _restaurantLocationRepo.fetchPlaces(keyword, countryCode);
        emit(state.copyWith(
          status: getAddressStatus.findPlacesSuccess,
          places: places,
        ));

    } catch(e) {
      emit(state.copyWith(status: getAddressStatus.failed));
    }

  }


  void _selectAddress(
      SelectAddress event,
      Emitter<RestaurantLocationState> emit
      ) {
    try {
      emit(state.copyWith(status: getAddressStatus.onFindPlaceDetail));
      final GooglePlaceLocation? geo = event.geo;
      AddressComponent selectedPlace = AddressComponent(placeId: event.placeId, address: event.address);
      if(geo != null) {
        print('test');
        selectedPlace.geo = geo;
      }
      emit(state.copyWith(
        status: getAddressStatus.findPlaceDetailSuccess,
        selectedPlace: selectedPlace,
      ));
    } catch(e) {
      emit(state.copyWith(status: getAddressStatus.failed));
    }
  }

}
