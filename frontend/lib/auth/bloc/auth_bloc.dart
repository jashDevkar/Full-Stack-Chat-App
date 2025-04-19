import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
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
    on<AuthEvent>((event, emit) {
      emit(AuthLoading());
    });

    on<OnRegisterButtonPressed>(onRegisterButtonPressedCallback);

    on<OnLoginButtonPressed>(onLoginButtonPressedCallback);

    on<CheckUserIsLogedIn>(checkUserIsLogedInCallback);

    on<OnLogoutButtonPressed>(logoutButtonPressedCallback);

    on<ClearLocalStorage>(clearLocalStorageCallback);

    on<OnResetState>(resetStateCallback);
  }

  void onRegisterButtonPressedCallback(
    OnRegisterButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final Response? result = await authService.registerUser(
        name: event.name,
        email: event.email,
        password: event.password,
        image: event.image,
      );

      if (result != null) {
        final Map<String, dynamic> response = result.data!;

        if (result.statusCode == 200) {
          //convert data into user model
          _user = UserModel.fromMap(response);

          // store that data
          await box.put('userData', response);

          emit(AuthLogedIn(loginMessage: response['message']));
          return;
        }
        emit(AuthFailure(errorMessage: response['message']));
      } else {
        emit(
          AuthFailure(
            errorMessage: 'Registration failed. Please try again later.',
          ),
        );
      }
    }catch(e){
      emit(
        AuthFailure(
          errorMessage:
              'An error occurred during registration. Please try again.  $e',
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
    } catch (e) {
      log(e.toString());
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
    final Map<dynamic, dynamic>? userData = box.get('userData');
    if (userData == null) {
      // await Future.delayed(Duration(seconds: 3)).then((val) {
      //   emit(AuthInitial());
      // });

      emit(AuthInitial());
      return;
    }

    if (userData.isNotEmpty) {
      // await Future.delayed(Duration(seconds: 3)).then((val) {
      //   _user = UserModel.fromMap(userData);
      //   emit(AuthLogedIn());
      //   return;
      // });

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

  void clearLocalStorageCallback(ClearLocalStorage event, Emitter emit) async {
    await box.clear();
    _user = UserModel(token: "", name: "", email: "", imageUrl: "");
    emit(AuthInitial());
  }

  void resetStateCallback(OnResetState event, Emitter emit) {
    emit(AuthInitial());
  }
}
