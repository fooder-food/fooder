import 'package:flutter/material.dart';

class FooderRestaurantInfoScreen extends StatefulWidget {
  static const routeName = '/restaurant-info';
  const FooderRestaurantInfoScreen({Key? key}) : super(key: key);

  @override
  _FooderRestaurantInfoScreenState createState() => _FooderRestaurantInfoScreenState();
}

class _FooderRestaurantInfoScreenState extends State<FooderRestaurantInfoScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,initRestaurantInfo);
  }

  void initRestaurantInfo() {
    final arg = ModalRoute.of(context)!.settings.arguments;
    print(arg);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(),
    );
  }
}
