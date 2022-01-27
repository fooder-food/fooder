import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_notification/bloc/add-list/add_list_bloc.dart';
import 'package:flutter_notification/bloc/add-restaurant/add_restaurant_bloc.dart';
import 'package:flutter_notification/bloc/add-restaurant/add_restaurant_repo.dart';
import 'package:flutter_notification/bloc/auth/auth_bloc.dart';
import 'package:flutter_notification/bloc/favorite/favorite_bloc.dart';
import 'package:flutter_notification/bloc/home/home_bloc.dart';
import 'package:flutter_notification/bloc/restaurant-details/restaurant_details_bloc.dart';
import 'package:flutter_notification/bloc/review/review_bloc.dart';
import 'package:flutter_notification/bloc/search-country/search_country_bloc.dart';
import 'package:flutter_notification/bloc/search-country/search_country_repo.dart';
import 'package:flutter_notification/bloc/search-restaurant/search_restaurant_bloc.dart';
import 'package:flutter_notification/bloc/search_place/search_place_bloc.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/model/providers/user_search_radius.dart';
import 'package:flutter_notification/ui/pages/app.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'bloc/notification/notifications_bloc.dart';
import 'core/service/navigate_service.dart';
import 'core/service/notification/notification_service.dart';
import 'model/providers/navigator_model.dart';
import 'model/providers/notification_count_model.dart';
import 'model/providers/select_place.dart';

final GetIt getIt = GetIt.instance;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  setupLocator();
  NotificationService.init(
    selectCallback: (payload) {
      final data = jsonDecode(payload!);
      print(data);
      if(data["param"] == 'restaurant') {
        getIt<NavigateService>().pushNamed('/restaurant-info',arguments: {
          'uniqueId': data["uniqueId"],
        });
      }
    },
  );
  _initPlatform();
  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider<AddRestaurantBloc>(
              create: (_) => AddRestaurantBloc(addRestaurantRepo: AddRestaurantRepo()),
            ),
            BlocProvider<SearchCountryBloc>(
              create: (_) => SearchCountryBloc(searchCountryRepo: SearchCountryRepo()),
            ),
            BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
            BlocProvider<HomeBloc>(create: (_)=>HomeBloc(),),
            BlocProvider<RestaurantDetailsBloc>(create: (_) =>RestaurantDetailsBloc()),
            BlocProvider<SearchPlaceBloc>(create: (_) =>SearchPlaceBloc()),
            BlocProvider<SearchRestaurantBloc>(create: (_) =>SearchRestaurantBloc()),
            BlocProvider<AddListBloc>(create: (_) =>AddListBloc()),
            BlocProvider<FavoriteBloc>(create:(_) => FavoriteBloc()),
            BlocProvider<ReviewBloc>(create: (_) => ReviewBloc()),
            BlocProvider<NotificationsBloc>(create: (_) => NotificationsBloc()),
          ],
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthModel()),
              ChangeNotifierProvider(create: (_) => UserSearchRadiusModel()),
              ChangeNotifierProvider(create: (_) => NavigatorModel()),
              ChangeNotifierProvider(create: (_) => SelectPlaceModel()),
              ChangeNotifierProvider(create: (_) => NotificationCountModel()),
            ],
            child: const MyApp(),
          )
      ));
}

void setupLocator(){
  getIt.registerSingleton(NavigateService());
  getIt.registerSingleton(NotificationCountModel());
}
Future<void> _initPlatform() async {

  const String oneSignalAppId = '646548d6-1afc-4403-b2c2-b102eae04e91';
  OneSignal.shared.setAppId(oneSignalAppId);
  OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
    print('FOREGROUND HANDLER CALLED WITH: ${event}');
    NotificationService.showNotification(
      title: event.notification.title,
      body: event.notification.body,
      payload: jsonEncode(event.notification.additionalData!["data"]),
    );
    int count = getIt<NotificationCountModel>().count + 1;
    getIt<NotificationCountModel>().updateCount(count);
    print( getIt<NotificationCountModel>().count);

    /// Display Notification, send null to not display
    event.complete(null);

  });

}