import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FooderLoadingWidget extends StatelessWidget {
  const FooderLoadingWidget({Key? key}) : super(key: key);
  final String assetName = 'assets/img/loading.svg';

  @override
  Widget build(BuildContext context) {
    final Widget svgBg = SvgPicture.asset(assetName, height: 200,);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            svgBg,
           const SizedBox(
              height: 15,
            ),
           Text(
             "Loading ....",
             style: Theme.of(context).textTheme.subtitle2,
           ),
          ],
        ),
      ),
    );
  }
}
