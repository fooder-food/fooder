import 'package:flutter/material.dart';
import 'package:flutter_notification/core/router/route.dart';
import 'package:flutter_notification/ui/shared/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fooder',
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

