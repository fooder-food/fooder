
import 'package:flutter/material.dart';

import 'custom_back_button.dart';

typedef OnPopCallback = void Function();

PreferredSizeWidget screenAppBar(AppBarTheme appbarTheme, {
  required String appTitle,
  List<Widget> actions = const [],
  Widget? customWidget,
  OnPopCallback? onPopCallback,
}) {
  return AppBar(
    leading: CustomBackbutton(
      onPopCallback: onPopCallback,
    ),
    automaticallyImplyLeading: false,
    elevation: 0,

    bottom: PreferredSize(
      child: Container(
        color: appbarTheme.foregroundColor,
        height: 0.5,
      ),
      preferredSize: const Size.fromHeight(0.2),
    ),
    backgroundColor: appbarTheme.backgroundColor,
    title: customWidget ?? Text(appTitle, style:appbarTheme.titleTextStyle,),
    actions: actions,
  );
}