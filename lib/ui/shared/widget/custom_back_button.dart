import 'package:flutter/material.dart';

import 'custom_app_bar.dart';

class CustomBackbutton extends StatefulWidget {
  CustomBackbutton({
    Key? key,
    this.onPopCallback,
  }) : super(key: key);
  final OnPopCallback? onPopCallback;

  @override
  State<CustomBackbutton> createState() => _CustomBackbuttonState();
}

class _CustomBackbuttonState extends State<CustomBackbutton> {

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () {
          if(widget.onPopCallback != null) {
            widget.onPopCallback!();
          } else {
            Navigator.of(context).pop();
          }

        },
        child: const Icon(
          Icons.arrow_back_ios_rounded,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }
}
