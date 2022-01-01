import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocationService {
  final Geolocator service = Geolocator();
  bool serviceEnabled = false;
  LocationPermission permission = LocationPermission.denied;

  GeoLocationService() {
    init();
  }

  init() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
  }

  Future<Position> determinePosition(BuildContext context) async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        showDialog(
          context: context,
          builder: (BuildContext context) => requestLocationPermissionAlert(context),
        );
      return Future.error('Location permissions are denied');
    }

    if (!serviceEnabled) {
      await Geolocator.getCurrentPosition();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      Navigator.of(context).pop();
      print(serviceEnabled);
      if(!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<Position> determinePostionWithOutCheck() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Widget requestLocationPermissionAlert(BuildContext context) {
    return AlertDialog(
      content: const Text("You need to grant \"Location\" permission in order to complete this operation"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')
        ),
        TextButton(
            onPressed: () async {
             await Geolocator.openAppSettings();
             Navigator.of(context).pop();
            },
            child: const Text('Settings')
        ),
      ],
    );
  }


  LocationPermission get getPermission => permission;

  bool get getPermissionIsAlways => permission == LocationPermission.always || permission == LocationPermission.whileInUse;

  bool get getServiceEnabled => serviceEnabled;
}