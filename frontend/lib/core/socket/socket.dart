import 'dart:async';
import 'dart:developer';

import 'package:frontend/services/chat/chat_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class Socket {
  final ChatService chatService;
  late socket_io.Socket socket;

  final StreamController chats = StreamController.broadcast();

  Socket({required this.chatService});

  void initSocketConnection(final String id) {
    socket = socket_io.io(
      'http://192.168.0.106:8000/',
      socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      log('✅ Connected to Socket Server');

      socket.on('on_register_successfull', (data) => log(data['message']));
    });

    socket.emit('register_user', {'id': id});

    socket.onDisconnect((_) => log('❌ Disconnected'));
  }

  void getChatsFromServer() async {
    final data  = await chatService.getAllChats();
  }

  void disconnectSocket() {
    socket.disconnect();
    chats.close();
    socket.dispose();
  }

  // void sendMessage() {
  //   String RecievedData;
  //   log('sending message');
  //   socket.emit('test_event', {'message': 'hello from flutter'});
  //   socket.on('test_response', (data) {
  //     RecievedData = data;
  //   });
  // }
}
