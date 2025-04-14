import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/core/socket/socket.dart';
import 'package:frontend/services/chat/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> friend;
  final ChatService chatService;
  const ChatScreen({
    super.key,
    required this.friend,
    required this.chatService,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  late Socket socket;

  bool loading = true;
  List allFriends = [];

  @override
  void initState() {
    super.initState();
    socket = Socket(chatService: widget.chatService);
    socket.initSocketConnection(BlocProvider.of<AuthBloc>(context).user.token);
  }

  @override
  void dispose() {
    socket.disconnectSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.friend['name'] ?? "Null",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        elevation: 2.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: socket.chats.stream,
              builder: (context, snapshot) {
                return Text('hello');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0, left: 10.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(hintText: 'Type here...'),

                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(),
                  child: GestureDetector(child: Icon(Icons.send)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
