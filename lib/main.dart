import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_notification/bloc/add-restaurant/add_restaurant_bloc.dart';
import 'package:flutter_notification/bloc/add-restaurant/add_restaurant_repo.dart';
import 'package:flutter_notification/bloc/auth/auth_bloc.dart';
import 'package:flutter_notification/bloc/home/home_bloc.dart';
import 'package:flutter_notification/bloc/search-country/search_country_bloc.dart';
import 'package:flutter_notification/bloc/search-country/search_country_repo.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/ui/pages/app.dart';
import 'package:provider/provider.dart';

import 'core/service/notification/notification_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  NotificationService.init();
  await Firebase.initializeApp();
  final messaging = FirebaseMessaging.instance;
  final token = await messaging.getToken();
  print(token);
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  FirebaseMessaging.onMessage.listen(_onMessageHandler);
  FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenAppHandler);
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
          ],
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthModel()),
            ],
            child: const MyApp(),
          )
      ));
}

void _onMessageOpenAppHandler(RemoteMessage message) {
  print(message.notification!.body);
  NotificationService.showNotification(
    title: message.notification!.title,
    body: message.notification!.body,
  );
}

void _onMessageHandler(RemoteMessage message) {
  print("message recieved");
  print(message.notification?.body);
  NotificationService.showNotification(
    title: message.notification!.title,
    body: message.notification!.body,
  );
}

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
  NotificationService.showNotification(
    title: message.notification!.title,
    body: message.notification!.body,
  );
}