import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification/model/geo_model.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:flutter_notification/ui/shared/widget/toast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FooderRestaurantInfoMap extends StatefulWidget {
  static const routeName = '/restaurant-info-map';
  const FooderRestaurantInfoMap({Key? key}) : super(key: key);

  @override
  State<FooderRestaurantInfoMap> createState() => _FooderRestaurantInfoMapState();
}

class _FooderRestaurantInfoMapState extends State<FooderRestaurantInfoMap> {
  final Completer<GoogleMapController> _mapController = Completer();
  final Map<MarkerId, Marker> _marker = {};
  Geo? restaurant_geo;
  String restaurantAddress = '';
  String resstaurantName = '';
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, initRestaurantMap);
  }

  void initRestaurantMap() async {
    final arg = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final latitude = arg["latitude"];
    final longitude = arg["longitude"];
    final address = arg["address"];
    final name = arg["restaurantName"];

    setState(() {
      restaurant_geo = Geo(lat: latitude, lng: longitude);
      restaurantAddress = address;
      resstaurantName = name;
    });
    _moveCamera(LatLng(latitude, longitude));

  }

  void _moveCamera(LatLng target) async {
    //
    MarkerId markerId = const MarkerId('unique');
    Marker marker =  Marker(
        markerId: markerId,
        position: target,
        draggable: false,
        onTap: () {
        }
    );
    setState(() {
      _marker[markerId] = marker;
    });
    final controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: target,
        zoom: 14,
      ),
    ));
  }

  void _toGoogleMap(Geo geo) async {
    String fallbackUrl = 'https://www.google.com/maps/search/?api=1&query=${geo.lat},${geo.lng}';
    var url = 'google.navigation:q=${geo.lat.toString()},${geo.lng.toString()}';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void _toWaze(Geo geo) async {
    var url = 'waze://?ll=${geo.lat.toString()},${geo.lng.toString()}';
    var fallbackUrl =
        'https://waze.com/ul?ll=${geo.lat.toString()},${geo.lng.toString()}&navigate=yes';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void _copyAddress(String data) {
    //await FlutterClipboard.copy(data);
    final copyData = ClipboardData(text: data);
    print(copyData.text);
    Clipboard.setData(copyData).then(
            (value) {
          showToast(
              context: context,
              msg: 'Copy Address Successful'
          );
        },
        onError: (err) {
          showToast(
              context: context,
              msg: "Error"
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      appBar: screenAppBar(appbarTheme, appTitle: resstaurantName),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            myLocationEnabled: false,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            markers: Set<Marker>.of(_marker.values),
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {

              _mapController.complete(controller);

            },
            onTap: (latLng) {
              print('map');
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
              child: restaurantGeoFunctionList(),
          ),
        ],
      ),
    );
  }
//RestaurantDetailsState state
  Widget restaurantGeoFunctionList() {

    return Container(
      height: 105,
      margin:  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    _toGoogleMap(restaurant_geo!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          width: 45,
                          height: 45,
                          child: const Center(
                            child: Icon(
                              Icons.directions,
                              color: Colors.grey,
                              size: 25,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Find Direction",
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _toWaze(restaurant_geo!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          width: 45,
                          height: 45,
                          child: const Center(
                            child: Icon(
                              Icons.directions_car,
                              color: Colors.grey,
                              size: 25,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Navigator",
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _copyAddress(restaurantAddress);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          width: 45,
                          height: 45,
                          child: const Center(
                            child: Icon(
                              Icons.file_copy,
                              color: Colors.grey,
                              size: 25,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Copy Address",
                          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
