import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/restaurant-location/restaurant_location_bloc.dart';
import 'package:flutter_notification/bloc/restaurant-location/restaurant_location_repo.dart';
import 'package:flutter_notification/core/service/geo/geo_location.dart';
import 'package:flutter_notification/model/google_map_location_model.dart';
import 'package:flutter_notification/model/google_place_geometry_model.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:flutter_notification/ui/shared/widget/custom_button.dart';
import 'package:flutter_notification/ui/shared/widget/loading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FooderAddRestaurantMapInfoScreen extends StatefulWidget {
  static const String routeName = '/map-screen';

  const FooderAddRestaurantMapInfoScreen({Key? key}) : super(key: key);

  @override
  State<FooderAddRestaurantMapInfoScreen> createState() =>
      _FooderAddRestaurantMapInfoScreenState();
}

class _FooderAddRestaurantMapInfoScreenState
    extends State<FooderAddRestaurantMapInfoScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final RestaurantLocationRepo _restaurantLocationRepo =
      RestaurantLocationRepo();
  final GeoLocationService _geoService = GeoLocationService();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late final RestaurantLocationBloc _restaurantLocationBloc;
  LatLng? _position;
  GoogleMapLocation? markedPlace;
  bool isLoading = true;
  bool buttonDisable = true;
  String defaultAddress = '';

  @override
  void initState() {
    _restaurantLocationBloc = BlocProvider.of<RestaurantLocationBloc>(context);
    init();
    super.initState();
  }

  Future<void> init() async {
    final currentSelection = _restaurantLocationBloc.state.selectedPlace?.geo;
    final GoogleMapLocation result;
    if (currentSelection != null) {
      final target =
          LatLng(currentSelection.latitude, currentSelection.longitude);
      result = await _restaurantLocationRepo.fetchGoogleMapLocation(
          longitude: target.longitude.toString(),
          latitude: target.latitude.toString());
    } else {
      Position position = await _geoService.determinePostionWithOutCheck();
      LatLng target = LatLng(position.latitude, position.longitude);
      result = await _restaurantLocationRepo.fetchGoogleMapLocation(
          longitude: target.longitude.toString(),
          latitude: target.latitude.toString());
    }
    setState(() {
      isLoading = false;
      markedPlace = result;
    });
  }

  // Future<LatLng> _initGoogleMap() async {
  //   LatLng target;
  //   if(markedPlace?.geometry != null) {
  //     target = LatLng( markedPlace!.geometry.location.latitude, markedPlace!.geometry.location.longitude);
  //   } else {
  //
  //   }
  //   print('target ${markedPlace!.formattedAddress}');
  //   return target;
  // }

  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      appBar: screenAppBar(appbarTheme,
          appTitle: markedPlace?.formattedAddress ?? defaultAddress),
      body: FutureBuilder<GoogleMapLocation>(
        future:Future(() => markedPlace!),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return Stack(
              children: [
                Listener(
                  onPointerHover: (event) {
                    setState(() {
                      buttonDisable = true;
                    });
                  },
                  onPointerUp: (event) async {
                    final result =
                    await _restaurantLocationRepo.fetchGoogleMapLocation(
                        longitude: _position!.longitude.toString(),
                        latitude: _position!.latitude.toString());
                    setState(() {
                      buttonDisable = false;
                      markedPlace = result;
                    });
                  },
                  child: GoogleMap(
                    myLocationEnabled: false,
                    markers: Set<Marker>.of(markers.values),
                    mapType: MapType.normal,
                    zoomGesturesEnabled: true,
                    onCameraMove: (cameraPosition) {
                      setState(() {
                        _position = cameraPosition.target;
                      });
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(markedPlace!.geometry.location.latitude,
                          markedPlace!.geometry.location.longitude),
                      zoom: 15,
                    ),
                    onMapCreated: (mapController) {
                      final newGeo = LatLng(markedPlace!.geometry.location.latitude,
                          markedPlace!.geometry.location.longitude);
                      print('geo $newGeo');
                      mapController.animateCamera(CameraUpdate.newLatLng(newGeo));
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.location_pin,
                    size: 40.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 65),
                    child: FooderCustomButton(
                        isBorder: false,
                        disable: buttonDisable,
                        buttonContent: "Confirm",
                        onTap: () async {
                          _restaurantLocationBloc.add(SelectAddress(
                            markedPlace!.placeId,
                            markedPlace!.formattedAddress,
                            geo: markedPlace!.geometry.location,
                          ));
                          Navigator.of(context).pop();
                        }),
                  ),
                ),
              ],
            );
          }
          return const FooderLoadingWidget();
        },
      ),
    );
    return const FooderLoadingWidget();
  }
}
