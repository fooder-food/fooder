import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/restaurant-location/restaurant_location_bloc.dart';
import 'package:flutter_notification/bloc/restaurant-location/restaurant_location_repo.dart';
import 'package:flutter_notification/core/service/geo/geo_location.dart';
import 'package:flutter_notification/model/google_map_location_model.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:flutter_notification/ui/shared/widget/custom_button.dart';
import 'package:flutter_notification/ui/shared/widget/loading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FooderAddRestaurantMapInfoScreen extends StatefulWidget {
  static const String routeName = '/map-screen';
  const FooderAddRestaurantMapInfoScreen({Key? key}) : super(key: key);

  @override
  State<FooderAddRestaurantMapInfoScreen> createState() => _FooderAddRestaurantMapInfoScreenState();
}

class _FooderAddRestaurantMapInfoScreenState extends State<FooderAddRestaurantMapInfoScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final RestaurantLocationRepo _restaurantLocationRepo = RestaurantLocationRepo();
  final GeoLocationService _geoService = GeoLocationService();
  late final RestaurantLocationBloc _restaurantLocationBloc;
  LatLng? _position;
  GoogleMapLocation? markedPlace;
  bool buttonDisable = false;
  String defaultAddress = '';


  @override
  void initState() {
    _restaurantLocationBloc = BlocProvider.of<RestaurantLocationBloc>(context);
    super.initState();
  }


  Future<LatLng> _initGoogleMap() async {
    Position position = await _geoService.determinePostionWithOutCheck();
    setState(() {
      _position = LatLng(position.latitude, position.longitude);
    });
    // setMarker();
    return LatLng(position.latitude, position.longitude);
  }

  Future<void> setMarker() async {
   final result = await _restaurantLocationRepo.fetchGoogleMapLocation(
        longitude: _position!.longitude.toString(),
        latitude: _position!.latitude.toString()
    );
    defaultAddress = result.formattedAddress;
  }

  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return FutureBuilder<LatLng>(
      future: _initGoogleMap(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final locationModel = snapshot.data!;
          return Scaffold(
            appBar: screenAppBar(appbarTheme, appTitle: markedPlace?.formattedAddress ?? defaultAddress),
            body: Stack(
              children: [
                Listener(
                  onPointerHover: (event) {
                    setState(() {
                      buttonDisable = true;
                    });
                  },
                  onPointerUp: (event) {
                    setState(() async {
                      buttonDisable = false;
                      markedPlace = await _restaurantLocationRepo.fetchGoogleMapLocation(
                          longitude: _position!.longitude.toString(),
                          latitude: _position!.latitude.toString()
                      );
                    });
                  },
                  child: GoogleMap(
                      myLocationEnabled:false ,
                      indoorViewEnabled: true,
                      mapType: MapType.normal,
                      zoomGesturesEnabled: true,
                      onCameraMove: (cameraPosition) {
                        setState(() {
                          _position = cameraPosition.target;
                        });
                      },
                      initialCameraPosition: CameraPosition(
                        target: locationModel,
                        zoom: 15,
                      ),
                      onMapCreated: (GoogleMapController mapController) async {
                        // await setMarker();
                        _controller.complete(mapController);

                      }
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.location_pin, size: 40.0, color: Theme
                      .of(context)
                      .primaryColor,),
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

                          _restaurantLocationBloc.add(SelectAddress(markedPlace!.placeId, markedPlace!.formattedAddress));
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }),
                  ),
                ),
              ],
            ),
          );
        }
        return const FooderLoadingWidget();
      },
    );
  }
}


