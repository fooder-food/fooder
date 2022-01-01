import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/auth/auth_bloc.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:flutter_notification/ui/shared/widget/custom_button.dart';
import 'package:flutter_notification/ui/shared/widget/custom_text_form_field.dart';
import 'package:flutter_notification/ui/shared/widget/toast.dart';
import 'package:form_field_validator/form_field_validator.dart';
class FooderEmailLoginScreen extends StatefulWidget {
  static String routeName = '/email-login';

  const FooderEmailLoginScreen({Key? key}) : super(key: key);

  @override
  State<FooderEmailLoginScreen> createState() => _FooderEmailLoginScreenState();
}

class _FooderEmailLoginScreenState extends State<FooderEmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: screenAppBar(
        appbarTheme,
        appTitle: "",
      ),
      body:_content(context),
    );
  }

  final _emailValidator =  MultiValidator([
  RequiredValidator(errorText: 'email address is required'),
  EmailValidator(errorText: 'email format invalid'),
  ]);

  final _passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digit long'),
    PatternValidator(r'^(?=.*?[A-Za-z])(?=.*?[0-9])', errorText: 'password must contain 1 alphabet')
  ]);

  Widget _content(context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if(state is AuthenticatedState) {
            showToast(
                context: context,
                msg: 'Login Successful'
            );
            Navigator.of(context).pushNamed('/');
          } else if (state is UnAuthenticatedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.auth.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if(state is AuthenticatingState) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child:  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome.",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        FooderCustomTextFormField(
                          textEditingController: _emailController,
                          labelName: 'Email address',
                          validator: _emailValidator,
                        ),
                        FooderCustomTextFormField(
                          textEditingController: _passwordController,
                          isPassField: true,
                          labelName: 'Password',
                          validator: _passwordValidator,
                        ),
                        Column(
                          children: [
                            FooderCustomButton(
                              buttonContent: 'Sign In',
                              isBorder: false,
                              onTap: () {
                                if( _formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                      LoginEvent(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                      )
                                  );
                                }
                              },
                            ),
                            FooderCustomButton(
                              buttonContent: 'Sign Up',
                              isBorder: true,
                              onTap: () {
                                Navigator.of(context).pushNamed('/email-register');
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  )
              ),
            );
          }
        },
      ),
    );
  }
}

