part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class OnRegisterButtonPressed extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String image;

  OnRegisterButtonPressed({
    required this.name,
    required this.email,
    required this.password,
    required this.image,
  });
}

class OnLoginButtonPressed extends AuthEvent {
  final String email;
  final String password;
  BuildContext context;

  OnLoginButtonPressed({
    required this.email,
    required this.password,
    required this.context,
  });
}

class OnLogoutButtonPressed extends AuthEvent {}

class CheckUserIsLogedIn extends AuthEvent {}

class ClearLocalStorage extends AuthEvent {}
