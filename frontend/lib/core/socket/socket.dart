import 'dart:developer';

import 'package:frontend/services/chat/chat_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class Socket {
  final ChatService chatService;
  late socket_io.Socket socket;

  final BehaviorSubject<List<Map<String, dynamic>>> chatList =
      BehaviorSubject.seeded([]);

  final String userToken;

  final String userEmail;

  Socket({
    required this.chatService,
    required this.userToken,
    required this.userEmail,
  });

  void initSocketConnection() {
    socket = socket_io.io(
      'http://192.168.0.106:8000',
      socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      log('✅ Connected to Socket Server');

      socket.emit('register_user', {'email': userEmail});
      socket.on('on_register_successfull', (data) => log(data['message']));

      socket.on('message_response', (data) {
        final chat = chatList.value;
        final List<Map<String, dynamic>> updatedChat = [...chat, data];
        chatList.add(updatedChat);
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

    final List<Map<String, dynamic>> chats = [...data];
    chatList.add(chats);
  }

  void disconnectSocket() {
    socket.disconnect();
    chatList.close();
    socket.dispose();
  }


}
