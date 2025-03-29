import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/chat/widgets/user_list.dart';
import 'package:frontend/core/widgets/loader.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/services/chat/chat_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserModel _userModel;

  ChatService chatService = ChatService();
  List users = [];

  @override
  void initState() {
    super.initState();

    _userModel = BlocProvider.of<AuthBloc>(context).user;
    // print(_userModel.token);
    fetchData();
    // print(_userModel.token);
  }

  bool loading = false;
  Future<void> fetchData() async {
    loading = true;
    final fetchedUsers = await chatService.fetchAllUsers(
      userToken: _userModel.token,
    );
    setState(() {
      users = fetchedUsers;
      print(users);

      loading = false;
    });
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to chat screen
              // chatService.openChat(context, null);
            },
            icon: Icon(Icons.chat, color: Colors.white),
          ),
          IconButton(
            icon: Icon(Icons.group, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(OnLogoutButtonPressed());
            },
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
                  // ChatService().sendFriendRequest();
                  // print(_userModel.token);

                  fetchData();
                },
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    // final List<dynamic> isFriend = user['friendRequests'];
                    // print(isFriend);
                    return UserList(user: user);
                  },
                ),
              ),
    );
  }
}
