import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/services/auth/auth_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthService authService = AuthService();
  final box = Hive.box('myBox');

  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) => emit(AuthLoading()));

    on<OnRegisterButtonPressed>(onRegisterButtonPressedCallback);

    on<OnLoginButtonPressed>(onLoginButtonPressedCallback);

    on<CheckUserIsLogedIn>(checkUserIsLogedInCallback);

    on<OnLogoutButtonPressed>(logoutButtonPressedCallback);

    on<ClearLocalStorage>(clearLocalStorageCallback);
  }

  void onRegisterButtonPressedCallback(
    OnRegisterButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final http.Response? result = await authService.registerUser(
        name: event.name,
        email: event.email,
        password: event.password,
        image: "jbjb",
      );
      print(jsonDecode(result?.body ?? ""));
      if (result != null) {
        final response = jsonDecode(result.body);
        if (result.statusCode == 200) {
          await box.put('token', response['token']);
          emit(AuthLogedIn(loginMessage: response['message']));
          return;
        }
        emit(AuthFailure(errorMessage: response['message']));
      } else {
        emit(
          AuthFailure(errorMessage: 'Registration failed. Please try again.'),
        );
      }
    } on (Exception e,) {
      emit(
        AuthFailure(
          errorMessage:
              'An error occurred during registration. Please try again.',
        ),
      );
    }
  }

  void onLoginButtonPressedCallback(
    OnLoginButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final http.Response? result = await authService.loginUser(
        email: event.email,
        password: event.password,
      );

      // print(result?.body);

      if (result != null) {
        final response = jsonDecode(result.body);

        if (result.statusCode == 200) {
          await box.put('token', response['token']);

          print(response['message']);

          emit(AuthLogedIn(loginMessage: response['message']));

          return;
        }
        emit(AuthFailure(errorMessage: response['message']));
      } else {
        emit(
          AuthFailure(
            errorMessage: 'Login failed. Please check your credentials.',
          ),
        );
      }
    } on (Exception e,) {
      emit(
        AuthFailure(
          errorMessage: 'An error occurred during login. Please try again.',
        ),
      );
    }
  }

  void checkUserIsLogedInCallback(
    CheckUserIsLogedIn event,
    Emitter emit,
  ) async {
    final String? token = await box.get('token');
    if (token == null) {
      emit(AuthInitial());
      return;
    }

    if (token.isNotEmpty) {
      emit(AuthLogedIn());
      return;
    }
    emit(AuthInitial());
  }

  void logoutButtonPressedCallback(
    OnLogoutButtonPressed event,
    Emitter emit,
  ) async {
    await box.clear();
    emit(AuthInitial());
  }

  clearLocalStorageCallback(ClearLocalStorage event, Emitter emit) async {
    await box.clear();
    emit(AuthInitial());
  }
}
