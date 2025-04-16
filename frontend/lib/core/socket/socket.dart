import 'dart:async';
import 'dart:developer';

import 'package:frontend/core/constants.dart';
import 'package:frontend/services/chat/chat_service.dart';

import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class Socket {
  final ChatService chatService;
  late socket_io.Socket socket;

  final StreamController<List<Map<String, dynamic>>> chatList =
      StreamController.broadcast();

  final String userToken;

  final String userEmail;
  List<Map<String, dynamic>> _allChats = [];

  Socket({
    required this.chatService,
    required this.userToken,
    required this.userEmail,
  });

  void initSocketConnection() {
    socket = socket_io.io(
      Constants.url,
      socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      log('✅ Connected to Socket Server');

      socket.emit('register_user', {'email': userEmail});
      socket.on(
        'on_register_successfull',
        (data) => log("✅ ${data['message']}"),
      );

      socket.on('message_response', (data) {
        _allChats.add(data);
        chatList.add(_allChats);
      });
    });

    socket.onDisconnect((_) => log('❌ Disconnected'));
  }

  void sendMessage({required String recieverEmail, required String message}) {
    final Map<String, dynamic> data = {
      'senderEmail': userEmail,
      'recieverEmail': recieverEmail,
      'message': message,
    };
    socket.emit('send_message', data);
  }

  void getChatsFromServer({required String recieverEmail}) async {
    final data = await chatService.getAllChats(
      userToken: userToken,
      recieverEmail: recieverEmail,
    );

    _allChats = [...data];
    chatList.add(_allChats);
  }

  void disconnectSocket() {
    socket.disconnect();
    chatList.close();
    socket.dispose();
  }
}
