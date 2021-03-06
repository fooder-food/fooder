import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification/bloc/auth/auth_bloc.dart';
import 'package:flutter_notification/bloc/auth/auth_repo.dart';
import 'package:flutter_notification/ui/shared/widget/custom_app_bar.dart';
import 'package:flutter_notification/ui/shared/widget/custom_button.dart';
import 'package:flutter_notification/ui/shared/widget/custom_text_form_field.dart';
import 'package:form_field_validator/form_field_validator.dart';

class FooderEmailRegisterScreen extends StatefulWidget {
  static const String routeName = '/email-register';
  const FooderEmailRegisterScreen({Key? key}) : super(key: key);

  @override
  _FooderEmailRegisterScreenState createState() => _FooderEmailRegisterScreenState();
}

class _FooderEmailRegisterScreenState extends State<FooderEmailRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  late final PageController _pageController;
  final _emailValidator =  MultiValidator([
    RequiredValidator(errorText: 'email address is required'),
    EmailValidator(errorText: 'email format invalid'),
  ]);

  final _passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digit long'),
    PatternValidator(r'^(?=.*?[A-Za-z])(?=.*?[0-9])', errorText: 'password must contain 1 alphabet'),
  ]);

  final _usernameValidator = MultiValidator([
    RequiredValidator(errorText: 'username is required'),
  ]);

  final emailFieldMsg = [
    "email already used. please insert another email",
    "email can use",
    "",
  ];

  late String emailError;

  @override
  void initState() {
    _emailController.addListener(_emailExistListener);
    _pageController = PageController();
    emailError = emailFieldMsg[2];
    super.initState();
  }

  void _emailExistListener() async {
    if(_emailController.text.isEmpty){
      emailError = emailFieldMsg[2];
      return;
    }
    final bool isExist = await AuthRepo().checkEmailIsExist(_emailController.text);
    if(isExist) {
      setState(() {
        emailError = emailFieldMsg[0];
      });
    } else {
      setState(() {
        emailError = emailFieldMsg[1];
      });
    }
  }

  void _pageOnChanged(int page) {}

  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: screenAppBar(
        appbarTheme,
        appTitle: "",
      ),
      body:_signUpContent(context),
    );
  }

  Widget _signUpContent(context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if(state is RegisterSuccessfulState) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Register successfully!"),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is NotAuthenticatedState) {
            Navigator.of(context).pushNamed('/error');
          }
        },
        builder: (context, state) {
          if(state is AuthenticatingState) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: PageView(
                  onPageChanged: _pageOnChanged,
                  controller: _pageController,
                  children: [
                    signUpFirstPageContent(context),
                    signUpFillUsernameContent(context),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }


  Widget signUpFirstPageContent(context) {
    return   Container(
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
                error: emailError,
                errorColor: emailError != emailFieldMsg[0] ? Colors.green : Colors.red,
                validator: _emailValidator,
              ),
              FooderCustomTextFormField(
                textEditingController: _passwordController,
                labelName: 'Password',
                isPassField: true,
                validator: _passwordValidator,
              ),
              FooderCustomTextFormField(
                labelName: 'Confirm Password',
                isPassField: true,
                validator: (val) => MatchValidator(
                    errorText: 'passwords do not match')
                    .validateMatch(val!, _passwordController.text),
              ),
              Column(
                children: [
                  FooderCustomButton(
                    buttonContent: 'Sign Up',
                    isBorder: false,
                    onTap: () {
                      _pageController.animateToPage(1,
                          duration: Duration(milliseconds: 250),
                          curve: Curves.linear);
                    },
                  ),
                  FooderCustomButton(
                    buttonContent: 'Sign In',
                    isBorder: true,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          ),
        )
    );
  }

  Widget signUpFillUsernameContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: [
            Text(
              "Let's get the basics so we can give you the goods",
              style: textTheme.headline2!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FooderCustomTextFormField(
              labelName: 'What should i call your ?',
              placeholderName: 'Your Name',
              validator: _usernameValidator,
              textEditingController: _usernameController,
            ),
            FooderCustomButton(
                isBorder: false,
                buttonContent: 'Next',
                onTap: () {
                  if( _formKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(
                        RegisterEvent(
                          email: _emailController.text,
                          password: _passwordController.text,
                          username: _usernameController.text,
                        )
                    );
                    _emailController.text = "";
                    _passwordController.text = "";
                    _usernameController.text = "";
                  }
                })
          ],
        ),
      ),
    );
  }
}
