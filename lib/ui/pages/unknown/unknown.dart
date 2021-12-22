import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FooderUnknownScreen extends StatelessWidget {
  static const String routeName = '/error';
  FooderUnknownScreen({Key? key}) : super(key: key);

  final String assetName = 'assets/img/error-404.svg';
  late final Widget errorImage = SvgPicture.asset(
      assetName,
      semanticsLabel: 'Error 404 image',
      height: 300,
  );

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            errorImage,
            const Text(
              'Whoops!'
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
                elevation: 0,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                )
              ),
              child: const Text('Back To Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              },
            )
          ],
        ),
      )
    );
  }
}
