import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_notification/core/service/geo/geo_location.dart';
import 'package:flutter_notification/core/service/storage/storage_service.dart';
import 'package:flutter_notification/model/providers/select_place.dart';
import 'package:flutter_notification/model/providers/user_search_radius.dart';
import 'package:flutter_notification/ui/pages/home/widget/select_place.dart';
import 'package:flutter_notification/ui/shared/widget/custom_button.dart';
import 'package:flutter_notification/ui/shared/widget/toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
class FooderRequestLocationScreen extends StatefulWidget {
  const FooderRequestLocationScreen({Key? key}) : super(key: key);

  @override
  State<FooderRequestLocationScreen> createState() => _FooderRequestLocationScreenState();
}

class _FooderRequestLocationScreenState extends State<FooderRequestLocationScreen> {
  final String assetName = 'assets/img/location_logo.svg';

 // final GeoLocationService _geoLocationService = GeoLocationService();

  void _agreeLocation() async {
    final GeoLocationService _geoLocationService = GeoLocationService();
    try {
      await _geoLocationService.determinePosition(context);
      if(_geoLocationService.getServiceEnabled && _geoLocationService.getPermissionIsAlways) {
        context.read<SelectPlaceModel>().updateLocationPriority(true);
        final String firstViewEncode = jsonEncode(true);
        await StorageService().setStr('first_view', firstViewEncode);
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        return;
      }
    } catch(e) {
      //showToast(msg: 'unknown error', context: context);
      print(e);
    }
  }
  _disagreeAction() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => FooderSelectPlaceScreen()
        ),
            (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Widget svgBg = SvgPicture.asset(assetName, height: 200,);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            svgBg,
            const SizedBox(
              height: 15,
            ),
            Text(
              'Location based services ',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2!.copyWith(
                fontSize: 22,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Agree to location based services to conveniently search restaurants near you.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 14,
                fontWeight: FontWeight.w400
              ),
            ),
            const SizedBox(
              height: 15,
            ),
           FooderCustomButton(
             isBorder: false,
             buttonContent: 'Agree',
             onTap: () {
               _agreeLocation();
             }
           ),
            FooderCustomButton(
                isBorder: true,
                buttonContent: 'Disagree',
                onTap: () {
                  _disagreeAction();
                }
            ),

          ],
        ),
      )
    );
  }
}
