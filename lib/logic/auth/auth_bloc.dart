import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/repositories/auth/user_auth_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserAuthRepository userAuthRepository;
  AuthBloc({required this.userAuthRepository}) : super(AuthInitialState()) {
    on<AuthEvent>((event, emit) => emit(AuthLoadingState()));
    on<AuthSignUpEvent>(_signUp);
    on<AuthLoginEvent>(_login);
    on<AuthLoginWithGoogleEvent>(_loginWithGoogle);
  }

  FutureOr<void> _signUp(
    AuthSignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      bool result = await userAuthRepository.signUp(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      if (result) {
        emit(AuthLoginWithGoogleSuccessState());
      } else {
        emit(AuthErrorState(message: 'Something went wrong'));
      }
    } catch (error) {
      emit(AuthErrorState(message: error.toString()));
    }
  }

  FutureOr<void> _login(AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      bool result = await userAuthRepository.login(
        email: event.email,
        password: event.password,
      );
      if (result) {
        emit(AuthSuccessState());
      } else {
        emit(AuthErrorState(message: 'Something went wrong'));
      }
    } catch (error) {
      emit(AuthErrorState(message: error.toString()));
    }
  }

  FutureOr<void> _loginWithGoogle(
    AuthLoginWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      bool result = await userAuthRepository.loginWithGoogle();
      if (result) {
        emit(AuthSuccessState());
      } else {
        emit(AuthErrorState(message: 'Something went wrong'));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }
}
