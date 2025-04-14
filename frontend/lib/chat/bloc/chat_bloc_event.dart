part of 'chat_bloc_bloc.dart';


sealed class ChatBlocEvent {}



class FetchAllFriends extends ChatBlocEvent{}


class FetchAllUsers extends ChatBlocEvent{}


class FetchAllNotifications extends ChatBlocEvent{}
