import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/auth/auth_bloc.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/sign_button.dart';


class FooderLoginSelectScreen extends StatefulWidget {
  const FooderLoginSelectScreen({Key? key}) : super(key: key);
  static const String routeName = '/login';

  @override
  State<FooderLoginSelectScreen> createState() => _FooderLoginSelectScreenState();
}

class _FooderLoginSelectScreenState extends State<FooderLoginSelectScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.antiAlias,
        children: [
          const SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: Opacity(
                opacity: 0.7,
                child: Image(
                  image:AssetImage('assets/img/login_image.jpg'),
                ),
              ),
            ),
          ),
          loginMethodList(context),
          Positioned(
            right: 15,
            bottom: 15,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false,
                  arguments: {
                    "index": 1,
                  }
                );
              },
              child: Text(
                "SKIP",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.black87,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget loginMethodList(context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if(state is GoogleAuthenticatingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
            height: MediaQuery.of(context).size.height - 150,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignInButton(
                    padding: 15,
                    buttonType: ButtonType.google,
                    buttonSize: ButtonSize.large,
                    width: 350,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () async {
                      context.read<AuthBloc>().add(GoogleLoginEvent());
                    }
                ),
                const SizedBox(
                  height: 20,
                ),
                SignInButton(
                    padding: 15,
                    buttonType: ButtonType.facebook,
                    buttonSize: ButtonSize.large,
                    width: 350,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                    }
                ),
                const SizedBox(
                  height: 20,
                ),
                SignInButton(
                    padding: 15,
                    buttonType: ButtonType.mail,
                    buttonSize: ButtonSize.large,
                    width: 350,
                    btnText: "Sign in with Mail",
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/email-login');
                    }
                )
              ],
            ),
          );
        }

      },
    );
  }
}