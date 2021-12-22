import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/core/service/storage/storage_service.dart';
import 'package:flutter_notification/model/auth_model.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/ui/pages/main/init_items.dart';
import 'package:provider/src/provider.dart';

class FooderMainScreen extends StatefulWidget {
  static const String routeName = '/';
  const FooderMainScreen({Key? key}) : super(key: key);

  @override
  State<FooderMainScreen> createState() => _FooderMainScreenState();
}

class _FooderMainScreenState extends State<FooderMainScreen> with AfterLayoutMixin<FooderMainScreen> {
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void addRestaurant(BuildContext context) {
    Navigator.of(context).pushNamed('/add-restaurant');
  }
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context);
    return Scaffold(
      body: Container(
        child: IndexedStack(
          index: _activeIndex,
          children: pages,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor.primaryColor,
        onPressed: () {
          addRestaurant(context);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: 3,
        gapLocation: GapLocation.end,
        notchSmoothness: NotchSmoothness.defaultEdge,
        height: 70,
            elevation: 10,
        tabBuilder: (index, isActive) {
          final Color color = _activeIndex == index ? themeColor.primaryColor : themeColor.unselectedWidgetColor;
          return Icon(
            iconList[index],
            color: color,
            size: 30,
          );
         },
        activeIndex: _activeIndex,
        onTap: (index) {
          setState(() {
            _activeIndex = index;
          });
        }),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    checkFirst();
  }

  void checkFirst() async {
    final String? _user = await StorageService().getByKey('user');
    if(_user != null) {
      final Map<String, dynamic> decoded =
      jsonDecode(_user) as Map<String, dynamic>;

      // keep user login.
      final Auth auth = Auth.fromJson(decoded);

      context.read<AuthModel>().setUser(auth);
    }
  }
}
