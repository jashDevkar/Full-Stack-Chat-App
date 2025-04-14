part of 'chat_bloc_bloc.dart';


sealed class ChatBlocState {}

final class ChatBlocInitial extends ChatBlocState {}

final class Success extends ChatBlocState {}

final class Failure extends ChatBlocState {
  final String message;

  Failure({required this.message});
}
