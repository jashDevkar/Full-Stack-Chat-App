import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List allFriends = [];
  List allNotifications = [];
  List allUsers = [];
  ChatBloc() : super(ChatInitial()) {
    on<EmptyAllFields>(emptyAllFieldsCallBack);
  }

  void emptyAllFieldsCallBack(EmptyAllFields event, Emitter emit) {
    allFriends.clear();
    allNotifications.clear();
    allUsers.clear();
  }
}
