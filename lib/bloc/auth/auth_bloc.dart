import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification/bloc/auth/auth_repo.dart';
import 'package:flutter_notification/core/service/storage/storage_service.dart';
import 'package:flutter_notification/model/auth_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<RegisterEvent>(_registerUser);
    on<LoginEvent>(_login);
    on<GoogleLoginEvent>(_googleLogin);
  }
  final AuthRepo _authRepo = AuthRepo();

  void _registerUser(
      RegisterEvent event,
      Emitter<AuthState> emit
      ) async {
    emit(AuthenticatingState());
    final messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    String email = event.email;
    String password = event.password;
    final Auth auth = await _authRepo.register(email: email, password: password, deviceToken: token!);
    emit(AuthenticatedState(auth));
  }

  void _login(
      LoginEvent event,
      Emitter<AuthState> emit
      ) async {
        try {
          emit(AuthenticatingState());
          String email = event.email;
          String password = event.password;
          final Auth auth = await _authRepo.login(email: email, password: password);
          if(auth.user == null) {
            emit(UnAuthenticatedState(auth));
            return;
          }
          final String userEncode = jsonEncode(auth.toJson());
          StorageService().setStr('user', userEncode);
          // Auth user = Auth.fromJson(jsonDecode(await StorageService().getByKey('user') as String));
          emit(AuthenticatedState(auth));
        } catch (e) {
          print(e);
        }
    }


  void _googleLogin(
      GoogleLoginEvent event,
      Emitter<AuthState> emit
      ) async {
    try {
      emit(GoogleAuthenticatingState());
      final GoogleSignInAccount? account = await _authRepo.googleSignIn();
      final googleSignInAuthentication = await account?.authentication;
      emit(GoogleAuthenticatedState());

    } catch(e) {
      print(e);
    }
  }
  }
