import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/chat/widgets/user_list.dart';
import 'package:frontend/core/widgets/loader.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/services/chat/chat_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late UserModel _userModel;
  late List friendRequests;

  bool loading = true;

  late ChatService chatService;

  @override
  void initState() {
    super.initState();

    chatService = ChatService(context);
    _userModel = BlocProvider.of<AuthBloc>(context).user;

    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      loading = true;
    });
    final fetchedResponse = await chatService.fetchAllFriends(
      userToken: _userModel.token,
    );

    setState(() {
      friendRequests = fetchedResponse;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body:
          loading
              ? const Loader()
              : RefreshIndicator(
                onRefresh: () async {
                  await fetchData();
                },
                child:
                    friendRequests.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('No users found'),
                              TextButton(
                                onPressed: fetchData,
                                child: Text('Refresh'),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount: friendRequests.length,
                          itemBuilder: (context, index) {
                            final user = friendRequests[index];
                            // print('userrr $user');
                            return UserList(
                              user: user,
                              onPressCallback: () {
                                chatService.acceptFriendRequest(
                                  senderToken: _userModel.token,
                                  recieverId: user['_id'],
                                  context: context,
                                );
                              },
                            );
                          },
                        ),
              ),
    );
  }
}
