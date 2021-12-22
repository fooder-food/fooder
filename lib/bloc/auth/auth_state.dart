part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthenticatingState extends AuthState {}

class GoogleAuthenticatingState extends AuthState {}

class GoogleAuthenticatedState extends AuthState {}

class AuthenticatedState extends AuthState {
  AuthenticatedState(this.auth);
  final Auth auth;
}

class UnAuthenticatedState extends AuthState {
  UnAuthenticatedState(this.auth);
  final Auth auth;
}

class NotAuthenticatedState extends AuthState {
  NotAuthenticatedState(this.err);
  final Object err;
}