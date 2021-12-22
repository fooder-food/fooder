import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({
  required String msg,
  required BuildContext context,
  ToastGravity? gravity,
  Toast? toast,
  Color? backgroundColor,
  Color? textColor,
}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: toast ?? Toast.LENGTH_SHORT,
    gravity: gravity ?? ToastGravity.BOTTOM,
    backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
    textColor: textColor ?? Colors.white,
    fontSize: 16.0,
  );
}