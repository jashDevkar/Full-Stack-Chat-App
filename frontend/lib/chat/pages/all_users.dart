import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/chat/bloc/chat_bloc.dart';
import 'package:frontend/chat/pages/notification_page.dart';
import 'package:frontend/chat/widgets/user_list.dart';
import 'package:frontend/core/widgets/loader.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/services/chat/chat_service.dart';
import 'package:page_transition/page_transition.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  late UserModel _userModel;
  late ChatService chatService;
  late ChatBloc provider;

  // List users = [];
  bool loading = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    chatService = ChatService(context);
    _userModel = BlocProvider.of<AuthBloc>(context).user;
    provider = BlocProvider.of<ChatBloc>(context);

    if (provider.allUsers.isEmpty) {
      fetchAllUsers();
    } else {
      loading = false;
    }
    // log(_userModel.token);
  }

  Future<void> fetchAllUsers() async {
    setState(() {
      loading = true;
    });

    List fetchedUsers = await chatService.fetchAllUsers(
      userToken: _userModel.token,
    );

    fetchedUsers =
        fetchedUsers.where((item) => item['status'] != 'Accept').toList();

    provider.allUsers = [...fetchedUsers];

    setState(() {
      loading = false;
    });
  }

  Future<void> sendRequest({
    required String senderToken,
    required String recieverId,
  }) async {
    await chatService.sendFriendRequest(
      context: context,
      senderToken: senderToken,
      recieverId: recieverId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: NotificationPage(),
                ),
              );
            },
            icon: Icon(Icons.notifications, color: Colors.white),
          ),
        ],
        title: Text(
          'Swift chat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),

        backgroundColor: Colors.deepPurple.shade600.withAlpha(100),
      ),
      body:
          loading
              ? const Loader()
              : RefreshIndicator(
                onRefresh: () async {
                  fetchAllUsers();
                },
                child:
                    provider.allUsers.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('No users found'),
                              TextButton(
                                onPressed: fetchAllUsers,
                                child: Text('Refresh'),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount: provider.allUsers.length,
                          itemBuilder: (context, index) {
                            final user = provider.allUsers[index];
                            return UserList(
                              user: user,
                              onPressCallback: () {
                                if (user['status'] == 'Pending' ||
                                    user['status'] == 'Friends') {
                                  return;
                                }

                                sendRequest(
                                  senderToken: _userModel.token,
                                  recieverId: user['_id'],
                                );

                                // print(user['_id']);
                              },
                            );
                          },
                        ),
              ),
    );
  }
}
