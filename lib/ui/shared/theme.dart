import 'dart:ui';

import 'package:flutter/material.dart';

class FooderAppTheme {
  //font size
  static const double bodyFontSize = 14;
  static const double smallFontSize = 16;
  static const double normalFontSize = 18;
  static const double largeFontSize = 24;
  static const double titleFontSize = 30;

  // light mode
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color.fromRGBO(255, 114, 94, 1.0),
      //primaryColor: const Color.fromRGBO(255, 114, 94, 1.0),
    secondaryHeaderColor: Colors.grey[600],
    canvasColor: Colors.white,
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: normalFontSize,
          fontWeight: FontWeight.normal,
        )
      ),
    pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android:
            CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS:
            CupertinoPageTransitionsBuilder(),
          }
      ),
    inputDecorationTheme:  const InputDecorationTheme(
      border: InputBorder.none,
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: titleFontSize,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        fontSize: largeFontSize,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      subtitle1: TextStyle(
        fontSize: smallFontSize,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      subtitle2: TextStyle(
        fontSize: bodyFontSize,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    )

  );

  // dark mode
  static final Color darkTextColor = Colors.blue;
  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.pink,
    canvasColor: const Color.fromRGBO(255, 254, 222, 1),
    textTheme: const TextTheme(
      bodyText2: TextStyle(fontSize: bodyFontSize),
      headline4: TextStyle(fontSize: smallFontSize),
      headline3: TextStyle(fontSize: normalFontSize),
      headline2: TextStyle(fontSize: largeFontSize),
    ),
  );


}