import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_bloc_event.dart';
part 'chat_bloc_state.dart';

class ChatBlocBloc extends Bloc<ChatBlocEvent, ChatBlocState> {
  List _userFriends = [];

  List _notifications = [];

  List get notifications => _notifications;
  List get userFriends => _userFriends;

  ChatBlocBloc() : super(ChatBlocInitial()) {
    on<ChatBlocEvent>((event, emit) {});
    on<FetchAllUsers>(fetchAllUsersCallBack);
    on<FetchAllFriends>(fetchAllFriendsCallBack);
  }

  Future<List> fetchAllUsersCallBack(FetchAllUsers event, Emitter emit) async {
    return [];
  }

  Future<List> fetchAllFriendsCallBack(
    FetchAllFriends event,
    Emitter emit,
  ) async {
    return [];
  }
}
