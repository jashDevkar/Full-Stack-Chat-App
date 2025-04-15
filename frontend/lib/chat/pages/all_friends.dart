// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/chat/pages/chat_screen.dart';
import 'package:frontend/chat/widgets/chat_user_list.dart';
import 'package:frontend/core/widgets/loader.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/services/chat/chat_service.dart';
import 'package:page_transition/page_transition.dart';

class AllFriends extends StatefulWidget {
  final ChatService chatService;
  final UserModel userModel;
  const AllFriends({
    super.key,
    required this.chatService,
    required this.userModel,
  });

  @override
  State<AllFriends> createState() => _AllFriendsState();
}

class _AllFriendsState extends State<AllFriends> {
  bool loading = true;
  List friendList = [];

  @override
  void initState() {
    super.initState();
    fetchAllFriends();
  }

  void fetchAllFriends() async {
    List fetchData = await widget.chatService.fetchAllFriends(
      userToken: widget.userModel.token,
    );
    setState(() {
      friendList = fetchData;
      loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: const Text(
          "Friends",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        elevation: 2.0,
      ),
      body:
          loading
              ? const Loader()
              : RefreshIndicator(
                onRefresh: () async {
                  fetchAllFriends();
                },
                child:
                    friendList.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('No users found'),
                              TextButton(
                                onPressed: fetchAllFriends,
                                child: Text('Refresh'),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount: friendList.length,
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> friend =
                                friendList[index];
                            return ChatUserList(
                              friend: friend,
                              onPressCallback: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.bottomToTop,
                                    child: ChatScreen(
                                      friend: friend,
                                      chatService: widget.chatService,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
              ),
    );
  }
}
