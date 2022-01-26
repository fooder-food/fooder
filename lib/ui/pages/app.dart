import 'package:flutter/material.dart';
import 'package:flutter_notification/core/router/route.dart';
import 'package:flutter_notification/core/service/navigate_service.dart';
import 'package:flutter_notification/ui/shared/theme.dart';

import '../../main.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fooder',
      navigatorKey: getIt<NavigateService>().key,
      debugShowCheckedModeBanner: false,
      theme: FooderAppTheme.lightTheme,
      darkTheme: FooderAppTheme.darkTheme,
      initialRoute: FooderRoute.initialRouteName,
      onGenerateRoute: FooderRoute.generateRoute,
      onUnknownRoute: FooderRoute.unknownRoute,
      routes: FooderRoute.routes,
    );
  }
}

