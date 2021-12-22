part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  LoginEvent({
    required this.email,
    required this.password,
});
  final String email;
  final String password;
}

class GoogleLoginEvent extends AuthEvent {}

class RegisterEvent extends AuthEvent {
   RegisterEvent({
      required this.email,
      required this.password,
   });
   final String email;
   final String password;
}

class LogoutEvent extends AuthEvent {}

