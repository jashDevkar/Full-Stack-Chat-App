part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLogedIn extends AuthState {
  final String? loginMessage;
  AuthLogedIn({this.loginMessage});
}

final class AuthLoading extends AuthState {}

final class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure({required this.errorMessage});
}


class AuthInitialLoading extends AuthState{}
