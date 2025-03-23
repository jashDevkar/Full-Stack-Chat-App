import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
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
    fetchData();
    // print(_userModel.token);
  }

  bool loading = true;

  Future<void> fetchData() async {
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
              : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      spacing: 15.0,
                      children: [
                        ClipOval(
                          child: Image(
                            image: NetworkImage(user['imageUrl']),
                            height: 50,
                            width: 50,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 2.0,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user['name']),
                              Text(
                                user['email'],
                                maxLines: 1,
                                // style: TextStyle(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: Text('Add friend'),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}

// loading
//               ? const Loader()
//               : Column(
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       BlocProvider.of<AuthBloc>(
//                         context,
//                       ).add(OnLogoutButtonPressed());
//                     },
//                     child: Text('Logout'),
//                   ),
//                   Expanded(
//                     child:
