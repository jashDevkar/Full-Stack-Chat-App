import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/chat/widgets/chat_tile.dart';
import 'package:frontend/core/socket/socket.dart';
import 'package:frontend/core/widgets/loader.dart';
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

    socket = Socket(
      chatService: widget.chatService,
      userToken: BlocProvider.of<AuthBloc>(context).user.token,
      userEmail: BlocProvider.of<AuthBloc>(context).user.email,
    );
    socket.initSocketConnection();
    socket.getChatsFromServer(recieverEmail: widget.friend['email']);
  }

  @override
  void dispose() {
    socket.disconnectSocket();
    super.dispose();
  }

  bool isFirstSnapshot = true;

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
          ///all chats
          Expanded(
            child: StreamBuilder(
              stream: socket.chatList.stream,
              builder: (context, snapshot) {
                log(
                  (snapshot.connectionState == ConnectionState.waiting)
                      .toString(),
                );
                if (snapshot.connectionState == ConnectionState.waiting) {
                  isFirstSnapshot = false;
                  return const Loader();
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> chat = snapshot.data![index];
                      return ChatTile(
                        chat: chat,
                        currentUserEmail:
                            BlocProvider.of<AuthBloc>(context).user.email,
                      );
                    },
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Center(child: Text('Start conversation'));
                }

                return Container();
              },
            ),
          ),

          ///input field
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                      left: 10.0,
                      top: 10.0,
                      bottom: 8.0,
                    ),
                    child: TextField(
                      maxLines: 4,
                      minLines: 1,
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type here...',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),

                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
                IconButton(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10.0),
                  // color: Colors.deepPurple,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  focusColor: Colors.deepPurple,
                  onPressed: () {
                    socket.sendMessage(
                      recieverEmail: widget.friend['email'],
                      message: _controller.text,
                    );
                    _controller.clear();
                  },

                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
