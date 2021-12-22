import 'package:flutter/material.dart';

class FooderCustomButton extends StatelessWidget {
  final String buttonContent;
  bool disable;
  bool isBorder;
  VoidCallback? onTap;
  FooderCustomButton({
    Key? key,
    required this.isBorder,
    required this.buttonContent,
    required this.onTap,
    this.disable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all<BorderSide>(
                BorderSide(
                  color:disable? Colors.grey : theme.primaryColor,
                )
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 20),
            ),
            backgroundColor:MaterialStateProperty.all<Color>(
              disable? Colors.grey : isBorder ? Colors.white: theme.primaryColor,
            ),
            // shape: MaterialStateProperty.all<StadiumBorder>(
            //   const StadiumBorder(),
            // ),
          ),
          onPressed: disable? null : onTap, child: Text(
        buttonContent,
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
          color: disable? Colors.white : isBorder ? theme.primaryColor: Colors.white,
        ),
      )
      ),
    );
  }
}
