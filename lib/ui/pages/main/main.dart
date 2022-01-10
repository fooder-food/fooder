import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/core/service/storage/storage_service.dart';
import 'package:flutter_notification/model/auth_model.dart';
import 'package:flutter_notification/model/providers/navigator_model.dart';
import 'package:flutter_notification/model/providers/user_model.dart';
import 'package:flutter_notification/ui/pages/main/init_items.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

class FooderMainScreen extends StatefulWidget {
  static const String routeName = '/';
  const FooderMainScreen({Key? key}) : super(key: key);

  @override
  State<FooderMainScreen> createState() => _FooderMainScreenState();
}

class _FooderMainScreenState extends State<FooderMainScreen> with AfterLayoutMixin<FooderMainScreen> {

  @override
  void initState() {
    super.initState();
  }


  void addRestaurant(BuildContext context) {
    Navigator.of(context).pushNamed('/add-restaurant');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NavigatorModel>(
        builder: (_, navigatorModel, __) {
          return Container(
            child: IndexedStack(
              index: navigatorModel.index,
              children: pages,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: context.watch<NavigatorModel>().index,
        onTap: (value) {
          if(value !=2) {
           context.read<NavigatorModel>().updateIndex(value);
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 5,
        items: <BottomNavigationBarItem>[
          for(var index = 0; index < iconList.length; index ++)
          BottomNavigationBarItem(
            label: iconList[index]["title"],
            icon: navIcon(index, iconList[index]["icon"]),
          ),
        ],
      ), // This tra
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
      print('user token${auth.token}');
      context.read<AuthModel>().setUser(auth);
    }
  }


  Widget navIcon(int index, String icon) {
    int _activeIndex = context.watch<NavigatorModel>().index;
    if(index != 2)  {
      return Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.red,
                ),
                width: index == _activeIndex ? 24 : 0,
                height: index == _activeIndex ? 1.5 : 0,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
            child: SvgPicture.asset(icon, width: 24, color: Colors.black),
          ),
        ],
      );
    }
    return Center(
      child: GestureDetector(
        onTap: () {
          addRestaurant(context);
        },
        child: Container(
          // width: 100,
          // height: 50,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          //margin: const EdgeInsets.only(top: 10.0),
          child: SvgPicture.asset(icon, width: 26, color: Colors.white),
        ),
      ),
    );
  }
}
