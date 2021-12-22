import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/restaurant-location/restaurant_location_bloc.dart';
import 'package:flutter_notification/ui/pages/auth/email_login.dart';
import 'package:flutter_notification/ui/pages/auth/email_register.dart';
import 'package:flutter_notification/ui/pages/auth/login.dart';
import 'package:flutter_notification/ui/pages/main/main.dart';
import 'package:flutter_notification/ui/pages/profile/edit_profile.dart';
import 'package:flutter_notification/ui/pages/profile/profile.dart';
import 'package:flutter_notification/ui/pages/restaurant/add_restaurant.dart';
import 'package:flutter_notification/ui/pages/restaurant/add_restaurant_map_info.dart';
import 'package:flutter_notification/ui/pages/restaurant/restaurant_locate.dart';
import 'package:flutter_notification/ui/pages/restaurant/search_country.dart';
import 'package:flutter_notification/ui/pages/unknown/unknown.dart';

class FooderRoute {
  static String initialRouteName = FooderMainScreen.routeName;

  static final RestaurantLocationBloc _restaurantLocationBloc = RestaurantLocationBloc();

  //router map
  static final Map<String, WidgetBuilder> routes = {
    FooderMainScreen.routeName: (ctx) => const FooderMainScreen(),
    FooderLoginSelectScreen.routeName: (ctx) => const FooderLoginSelectScreen(),
    FooderEmailLoginScreen.routeName: (ctx) => const FooderEmailLoginScreen(),
    FooderEmailRegisterScreen.routeName: (ctx) => const FooderEmailRegisterScreen(),
    FooderAddRestaurantScreen.routeName: (ctx) => BlocProvider.value(
      value: _restaurantLocationBloc,
      child: const FooderAddRestaurantScreen(),
    ),
    FooderRestaurantLocateScreen.routeName: (ctx) => BlocProvider.value(
      value:_restaurantLocationBloc,
      child: const FooderRestaurantLocateScreen(),
    ),
    FooderSearchCountryScreen.routeName: (ctx) => BlocProvider.value(
      value: _restaurantLocationBloc,
      child: const FooderSearchCountryScreen(),
    ),
    FooderAddRestaurantMapInfoScreen.routeName: (ctx) => BlocProvider.value(
      value: _restaurantLocationBloc,
      child: const FooderAddRestaurantMapInfoScreen(),
    ),
    FooderUnknownScreen.routeName: (ctx) => FooderUnknownScreen(),
    FooderProfileScreen.routeName: (ctx) => const FooderProfileScreen(),
    FooderEditProfileScreen.routeName: (ctx) => FooderEditProfileScreen(),

  };

  //route factory
  static final RouteFactory  generateRoute = (settings) => null;

  //unknown route
  static final RouteFactory unknownRoute = (settings) => CupertinoPageRoute(
    settings: settings,
    builder: (BuildContext context) => FooderUnknownScreen());

}