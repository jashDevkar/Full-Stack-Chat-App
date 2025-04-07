import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/chat/pages/notification_page.dart';
import 'package:frontend/chat/widgets/user_list.dart';
import 'package:frontend/core/widgets/loader.dart';
import 'package:frontend/core/widgets/show_alert.dart';
import 'package:frontend/model/user_model.dart';
import 'package:frontend/services/chat/chat_service.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserModel _userModel;

  late ChatService chatService;
  List users = [];

  @override
  void initState() {
    super.initState();

    chatService = ChatService(context);
    _userModel = BlocProvider.of<AuthBloc>(context).user;
    fetchData();
    print(_userModel.token);
  }

  bool loading = true;
  Future<void> fetchData() async {
    setState(() {
      loading = true;
    });

    List fetchedUsers = await chatService.fetchAllUsers(
      userToken: _userModel.token,
    );


    fetchedUsers =
        fetchedUsers.where((item) => item['status'] != 'Accept').toList();

    setState(() {
      users = fetchedUsers;

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
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            );
          },
        ),

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
          IconButton(
            icon: Icon(Icons.group, color: Colors.white),
            onPressed: () {},
          ),
        ],
        title: Text(
          'Swift chat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),

        backgroundColor: Colors.deepPurple.shade600.withAlpha(100),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.all(0),
              child: Column(
                spacing: 20,
                children: [
                  ClipOval(
                    child: Image(
                      image: NetworkImage(_userModel.imageUrl),
                      height: 70,
                      width: 70,
                    ),
                  ),
                  Text(_userModel.name, style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            ListTile(
              trailing: Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // print('object');
                showAlert(context);
                // BlocProvider.of<AuthBloc>(context).add(OnLogoutButtonPressed());
              },
            ),
          ],
        ),
      ),

      ///check is data is present else show a 'no user found text'
      ///every time on refresh show a
      body:
          loading
              ? const Loader()
              : RefreshIndicator(
                onRefresh: () async {
                  fetchData();
                },
                child:
                    users.isEmpty
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
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
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
