import 'package:flutter/material.dart';
import 'package:flutter_notification/ui/pages/home/home.dart';
import 'package:flutter_notification/ui/pages/list/list.dart';
import 'package:flutter_notification/ui/pages/search/search.dart';

List<Map<String, dynamic>> iconList = [
  {
    "id": 0,
    "icon": "assets/img/find_location.svg",
    "title": "Find"
  },
  {
    "id": 1,
    "icon": "assets/img/search.svg",
    "title": "Search"
  },
  {
    "id": 2,
    "icon":  "assets/img/Icon_plus.svg",
    "title": ""
  },
  {
  "id": 3,
  "icon":  "assets/img/my_list.svg",
  "title": "My List"
  },
  {
  "id": 4,
  "icon":  "assets/img/favorite.svg",
  "title": "My Favorite"
  },

];


List<Widget> pages = [
  const FooderHomeScreen(),
  const FooderSearchScreen(),
  Container(),
  const FooderMyListScreen(),
  const FooderSearchScreen(),
];