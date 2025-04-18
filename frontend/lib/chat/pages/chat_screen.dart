import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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

  final ScrollController _scrollController = ScrollController();

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

    KeyboardVisibilityController().onChange.listen((isVisible) {
      if (isVisible) {
        Future.delayed(Duration(milliseconds: 300), () {
          scrollToEnd();
        });
      }
    });
  }

  scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
          ///all chats
          Expanded(
            child: StreamBuilder(
              stream: socket.chatList.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  ///if ui is rendered than this will run
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      ///check if scroll controller is attached to the listview
                      Future.delayed(Duration(milliseconds: 300), () {
                        scrollToEnd();
                      });
                    }
                  });
                  return ListView.builder(
                    controller: _scrollController,
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
                    if (_controller.text.trim().isEmpty) {
                      _controller.clear();
                      return;
                    }
                    socket.sendMessage(
                      recieverEmail: widget.friend['email'],
                      message: _controller.text,
                    );
                    _controller.clear();
                    Future.delayed(Duration(milliseconds: 100), scrollToEnd);
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
