import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/services/auth/auth_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserModel _user = UserModel(token: "", name: "", email: "", imageUrl: "");

  UserModel get user => _user;
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

      if (result != null) {
        final Map<String, dynamic> response = jsonDecode(result.body);
        if (result.statusCode == 200) {
          //convert data into user model
          _user = UserModel.fromMap(response);
          final Map<String, dynamic> userData = _user.toMap();

          // store that data
          await box.put('userData', userData);

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
      final navigator = Navigator.of(event.context);
      final http.Response? result = await authService.loginUser(
        email: event.email,
        password: event.password,
      );

      if (result != null) {
        final Map<String, dynamic> response = await jsonDecode(result.body);

        if (result.statusCode == 200) {
          _user = UserModel.fromMap(response);
          final Map<String, dynamic> userData = _user.toMap();
          await box.put('userData', userData);

          emit(AuthLogedIn(loginMessage: response['message']));
          navigator.pop();
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
    final Map<dynamic, dynamic>? userData = await box.get('userData');
    if (userData == null) {
      emit(AuthInitial());
      return;
    }

    if (userData.isNotEmpty) {
      _user = UserModel.fromMap(userData);
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
    _user = UserModel(token: "", name: "", email: "", imageUrl: "");
    emit(AuthInitial());
  }
}
